// ==============================
// Power BI / Power Query (M)
// Import and parse Splunk savedsearches.conf files
// ==============================
let
  // 🔧 CHANGE THIS to your Splunk etc root (e.g., "C:\Program Files\Splunk\etc" or "/opt/splunk/etc")
  RootFolder = "C:\Sources\splunk\apps",

  // ------------------------------
  // Helper: join lines ending with "\" into the next line
  // ------------------------------
  CombineContinuations = (lines as list) as list =>
    let
      seed = [out = {}, carry = "", cont = false],
      folded =
        List.Accumulate(
          lines,
          seed,
          (s, l) =>
            let
              // strip BOM if present and trim end
              l0 = Text.Replace(l, Character.FromNumber(65279), ""),
              t  = Text.TrimEnd(l0),
              ends = Text.EndsWith(t, "\"),
              piece = if ends then Text.Start(t, Text.Length(t) - 1) else t,
              combined = if s[cont] then s[carry] & piece else piece
            in
              if ends then
                [out = s[out], carry = combined, cont = true]
              else
                [out = s[out] & {combined}, carry = "", cont = false]
        ),
      result =
        if folded[cont] and Text.Length(folded[carry]) > 0
        then folded[out] & {folded[carry]}
        else folded[out]
    in
      result,

  // ------------------------------
  // Helper: parse savedsearches.conf text -> table [Stanza, Key, Value]
  // - INI-like sections [stanza]
  // - Key = Value (split on first "=" only)
  // - Ignores comment lines that START with "#"
  // - Handles "\" line continuations (already combined above)
  // ------------------------------
  ParseSavedSearchesText = (confText as text) as table =>
    let
      lines0 = Lines.FromText(confText),
      lines  = CombineContinuations(lines0),
      // remove empty and full-line comments
      filtered =
        List.Select(
          lines,
          (ln) =>
            let t = Text.Trim(ln)
            in  (t <> "") and (not Text.StartsWith(t, "#"))
        ),
      // walk lines, carry current stanza
      folded =
        List.Accumulate(
          filtered,
          [stanza = null, rows = {}],
          (s, ln) =>
            let
              t = Text.Trim(ln),
              isHeader = Text.StartsWith(t, "[") and Text.EndsWith(t, "]"),
              newStanza =
                if isHeader
                then Text.BetweenDelimiters(t, "[", "]")
                else s[stanza],
              eqPos = Text.PositionOf(t, "=", Occurrence.First),
              isKV  = (not isHeader) and (eqPos >= 1),
              key   = if isKV then Text.Trim(Text.Start(t, eqPos)) else null,
              val   = if isKV then Text.Trim(Text.Range(t, eqPos + 1)) else null,
              row   = if isKV and (newStanza <> null) then [Stanza=newStanza, Key=key, Value=val] else null,
              outRows = if row <> null then s[rows] & {row} else s[rows]
            in
              [stanza = newStanza, rows = outRows]
        ),
      rowsList = folded[rows],
      asTable  = if List.Count(rowsList) = 0 then #table({"Stanza","Key","Value"}, {}) else Table.FromRecords(rowsList, type table [Stanza=text, Key=text, Value=text])
    in
      asTable,

  // ------------------------------
  // Gather files
  // ------------------------------
  AllFiles = Folder.Files(RootFolder),
  SavedConfFiles = Table.SelectRows(AllFiles, each Text.Lower([Name]) = "savedsearches.conf"),

  // Read each file as text (UTF-8 fallback to ANSI if needed)
  WithText =
    Table.AddColumn(
      SavedConfFiles,
      "ConfText",
      each try Text.FromBinary(File.Contents([Folder Path] & [Name]), TextEncoding.Utf8)
           otherwise Text.FromBinary(File.Contents([Folder Path] & [Name]), TextEncoding.Windows),
      type text
    ),

  // Parse to rows
  Parsed =
    Table.AddColumn(
      WithText,
      "Rows",
      each ParseSavedSearchesText([ConfText]),
      type table [Stanza=text, Key=text, Value=text]
    ),

  Expanded =
    Table.ExpandTableColumn(
      Parsed,
      "Rows",
      {"Stanza","Key","Value"},
      {"Stanza","Key","Value"}
    ),

  // ------------------------------
  // Derive metadata: app, user, scope, precedence
  // ------------------------------
  AddPathNorm = Table.AddColumn(Expanded, "PathNorm", each Text.Replace(Text.Lower([Folder Path] & [Name]), "\", "/"), type text),

  // app name (from apps or users tree)
  AddApp =
    Table.AddColumn(
      AddPathNorm,
      "App",
      each
        let p = [PathNorm] in
          if Text.Contains(p, "/apps/") then
            let after = Text.AfterDelimiter(p, "/apps/") in Text.BeforeDelimiter(after, "/")
          else if Text.Contains(p, "/users/") then
            let
              afterUsers = Text.AfterDelimiter(p, "/users/"),
              rest      = Text.AfterDelimiter(afterUsers, "/") // skip username
            in Text.BeforeDelimiter(rest, "/")
          else if Text.Contains(p, "/system/") then "system"
          else null,
      type text
    ),

  // user (if coming from etc/users/<user>/...)
  AddUser =
    Table.AddColumn(
      AddApp,
      "User",
      each
        let p = [PathNorm] in
          if Text.Contains(p, "/etc/users/") then
            let after = Text.AfterDelimiter(p, "/etc/users/") in Text.BeforeDelimiter(after, "/")
          else null,
      type text
    ),

  // scope + simple precedence:
  //   users (highest) > local > default > other
  AddScope =
    Table.AddColumn(
      AddUser,
      "Scope",
      each
        let p = [PathNorm] in
          if Text.Contains(p, "/etc/users/") then "users"
          else if Text.Contains(p, "/local/") then "local"
          else if Text.Contains(p, "/default/") then "default"
          else "other",
      type text
    ),

  AddScopePriority =
    Table.AddColumn(
      AddScope,
      "ScopePriority",
      each if [Scope] = "users" then 4
           else if [Scope] = "local" then 3
           else if [Scope] = "default" then 2
           else 1,
      Int64.Type
    ),

  AddFilePath = Table.AddColumn(AddScopePriority, "FilePath", each [Folder Path] & [Name], type text),

  // Keep handy columns
  SavedSearches_Raw =
    Table.SelectColumns(
      AddFilePath,
      {"Stanza","Key","Value","App","User","Scope","ScopePriority","FilePath","Date modified","Date created"}
    ),

  // ------------------------------
  // Resolve duplicates by precedence & recency, then pivot keys -> columns
  // ------------------------------
  Sorted =
    Table.Sort(
      SavedSearches_Raw,
      {
        {"Stanza", Order.Ascending},
        {"Key", Order.Ascending},
        {"ScopePriority", Order.Descending},
        {"Date modified", Order.Descending}
      }
    ),

  // Choose the "winner" row per (Stanza, Key)
  WinnersGrouped =
    Table.Group(
      Sorted,
      {"Stanza","Key"},
      {
        {"Chosen", each Table.FirstN(_, 1), type table [Stanza=text, Key=text, Value=text, App=text, User=text, Scope=text, ScopePriority=Int64.Type, FilePath=text, #"Date modified"=datetime, #"Date created"=datetime]}
      }
    ),
  Winners =
    Table.ExpandTableColumn(
      WinnersGrouped, "Chosen",
      {"Value","App","User","Scope","ScopePriority","FilePath","Date modified","Date created"},
      {"Value","App","User","Scope","ScopePriority","FilePath","Date modified","Date created"}
    ),

  // Pivot values
  KeysList = List.Sort(List.Distinct(Winners[Key])),
  SavedSearches_Resolved =
    let
      valuesOnly = Table.SelectColumns(Winners, {"Stanza","Key","Value"}),
      pivoted = Table.Pivot(valuesOnly, KeysList, "Key", "Value"),
      // Attach one source column per search (the file that provided the 'search' key, if present)
      sourcePerKey =
        let
          // We only keep the source of the 'search' key for quick reference; duplicate the idea if you want more
          srcRows = Table.SelectRows(Winners, each [Key] = "search"),
          srcSlim = Table.SelectColumns(srcRows, {"Stanza","FilePath","App","User","Scope"}),
          srcDistinct = Table.Distinct(srcSlim, {"Stanza"}),
          renamed = Table.RenameColumns(srcDistinct, {{"FilePath","search.SourceFile"}, {"App","search.SourceApp"}, {"User","search.SourceUser"}, {"Scope","search.SourceScope"}})
        in
          renamed,
      final = Table.NestedJoin(pivoted, {"Stanza"}, sourcePerKey, {"Stanza"}, "src", JoinKind.LeftOuter),
      expanded = Table.ExpandTableColumn(final, "src", {"search.SourceFile","search.SourceApp","search.SourceUser","search.SourceScope"}, {"search.SourceFile","search.SourceApp","search.SourceUser","search.SourceScope"})
    in
      expanded
in
    SavedSearches_Resolved
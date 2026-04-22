```powerquery
let
  // 👇 CHANGE THIS to your local Sigma repo root
  RepoRoot = "D:\github\sigma\",

  // Grab all files under the repo
  AllFiles = Folder.Files(RepoRoot),

  // Helper: does a path contain any segment that starts with "rules" (case-insensitive)?
  IsRulesSubpath = (folderPath as text) as logical =>
    let
      norm      = Text.Lower(Text.Replace(folderPath, "\", "/")),
      segments  = List.Select(Text.Split(norm, "/"), each _ <> ""),
      hasRules  = List.AnyTrue(List.Transform(segments, each Text.StartsWith(_, "rules")))
    in
      hasRules,

  // Keep only YAML files inside rules* folders
  YamlInRules = Table.SelectRows(
    AllFiles,
    each ((Text.Lower([Extension]) = ".yml" or Text.Lower([Extension]) = ".yaml") and IsRulesSubpath([Folder Path]))
  ),

  // Read file text
  WithOriginal = Table.AddColumn(
    YamlInRules, "Original", each Text.FromBinary([Content], TextEncoding.Utf8), type text
  ),

  // -------- YAML-ish parser tailored for Sigma --------
  ParseSigma = (txt as text) as record =>
    let
      // Lines
      linesBin = Text.ToBinary(txt, TextEncoding.Utf8),
      lines    = Lines.FromBinary(linesBin),

      // Utility: leading-space count
      Indent = (s as text) as number => Text.Length(s) - Text.Length(Text.TrimStart(s)),

      // Find first top-level key line like: key:
      FindTopKeyIndex = (key as text) as number =>
        List.PositionOf(
          List.Transform(lines, (l) => if Indent(l)=0 and Text.StartsWith(Text.TrimStart(l), key & ":") then true else false),
          true
        ),

      // Collect subsequent lines in the current block (indent > 0)
      CollectBlock = (startIndex as number) as list =>
        let
          next = startIndex + 1,
          block =
            List.Generate(
              () => [i = next],
              each [i] < List.Count(lines) and Indent(lines{[i]}) > 0,
              each [i = [i] + 1],
              each lines{[i]}
            )
        in
          block,

      // Normalize output: text or joined list
      AsJoinedText = (v as any) as nullable text =>
        if v is null then null
        else if v is list then Text.Combine(List.Transform(v, each _ as text), " | ")
        else if v is text then v
        else Text.From(v),

      // Parse a top-level key into text or list (supports: inline scalar, block scalar | >, or list - items)
      GetTop = (key as text) as nullable any =>
        let
          idx = FindTopKeyIndex(key),
          res =
            if idx < 0 then null else
            let
              line     = lines{idx},
              after    = Text.Trim(Text.AfterDelimiter(line, ":", 0)),
              isBlock  = (after = "|" or after = ">"),
              block    = CollectBlock(idx),

              // List items (e.g., references/tags/falsepositives)
              listLines = List.Select(block, each Text.StartsWith(Text.TrimStart(_), "- ")),
              listItems = List.Transform(listLines, each Text.Trim(Text.AfterDelimiter(Text.TrimStart(_), "- "))),

              // Block scalar (dedent)
              blockIndent =
                if List.Count(block)=0 then 0
                else List.Min(List.Transform(block, each Indent(_))),
              blockText =
                if List.Count(block)=0 then null
                else Text.Combine(List.Transform(block, each Text.Range(_, blockIndent)), "#(lf)")
            in
              if after <> "" and not isBlock then after
              else if isBlock then blockText
              else if List.Count(listItems) > 0 then listItems
              else null
        in
          res,

      // Nested under logsource:
      GetLogsource = (subkey as text) as nullable text =>
        let
          lidx = FindTopKeyIndex("logsource"),
          val =
            if lidx < 0 then null else
            let
              block   = CollectBlock(lidx),
              matchIx = List.PositionOf(
                List.Transform(block, (l) => if Text.StartsWith(Text.TrimStart(l), subkey & ":") then true else false),
                true
              )
            in
              if matchIx < 0 then null
              else
                let ln = block{matchIx}
                in Text.Trim(Text.AfterDelimiter(Text.TrimStart(ln), ":", 0))
        in
          val,

      // Map fields
      title      = AsJoinedText(GetTop("title")),
      id         = AsJoinedText(GetTop("id")),
      status     = AsJoinedText(GetTop("status")),
      description= AsJoinedText(GetTop("description")),
      references = AsJoinedText(GetTop("references")),
      author     = AsJoinedText(GetTop("author")),
      date       = AsJoinedText(GetTop("date")),
      modified   = AsJoinedText(GetTop("modified")),
      tags       = AsJoinedText(GetTop("tags")),
      fp         = AsJoinedText(GetTop("falsepositives")),
      level      = AsJoinedText(GetTop("level")),
      license    = AsJoinedText(GetTop("license")),

      // logsource.*
      lsCategory   = AsJoinedText(GetLogsource("category")),
      lsDefinition = AsJoinedText(GetLogsource("definition")),
      lsProduct    = AsJoinedText(GetLogsource("product")),
      lsService    = AsJoinedText(GetLogsource("service")),

      out = [
        title = title,
        id = id,
        status = status,
        description = description,
        references = references,
        author = author,
        date = date,
        modified = modified,
        tags = tags,
        #"logsource.category" = lsCategory,
        #"logsource.definition" = lsDefinition,
        #"logsource.product"   = lsProduct,
        #"logsource.service"   = lsService,
        falsepositives = fp,
        level = level,
        license = license
      ]
    in
      out,

  // Parse each file
  WithParsed = Table.AddColumn(WithOriginal, "Parsed", each ParseSigma([Original])),

  // Expand to the requested columns + file path + original text
  Expanded = Table.ExpandRecordColumn(
    WithParsed,
    "Parsed",
    {
      "title","id","status","description","references","author","date","modified","tags",
      "logsource.category","logsource.definition","logsource.product","logsource.service",
      "falsepositives","level","license"
    },
    {
      "title","id","status","description","references","author","date","modified","tags",
      "logsource.category","logsource.definition","logsource.product","logsource.service",
      "falsepositives","level","license"
    }
  ),

  WithFilepath = Table.AddColumn(Expanded, "Filepath", each [Folder Path] & [Name], type text),

  // Keep original columns order first
  Reordered = Table.ReorderColumns(
    WithFilepath,
    {
      "title","id","status","description","references","author","date","modified","tags",
      "logsource.category","logsource.definition","logsource.product","logsource.service",
      "falsepositives","level","license","Filepath","Original"
    }
  ),

  // ✅ Add a merged 'logsource' column without dropping the three source columns
  WithLogsource = Table.AddColumn(
    Reordered,
    "logsource",
    each 
      let parts = List.RemoveNulls({[#"logsource.category"], [#"logsource.product"], [#"logsource.service"]})
      in if List.IsEmpty(parts) then null else Text.Combine(parts, " "),
    type text
  ),

  // Final column order (puts 'logsource' after the three specific ones)
  Final = Table.ReorderColumns(
    WithLogsource,
    {
      "title","id","status","description","references","author","date","modified","tags",
      "logsource.category","logsource.definition","logsource.product","logsource.service","logsource",
      "falsepositives","level","license","Filepath","Original"
    }
  )
in
  Final
```
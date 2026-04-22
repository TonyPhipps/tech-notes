// ==============================
// Power BI / Power Query (M)
// Import and parse ONE Splunk savedsearches.conf file
// ==============================
let
    // 🔧 CHANGE THIS to point to your file or direct download URL:
    // Example (local):  "C:\Program Files\Splunk\etc\apps\search\local\savedsearches.conf"
    // Example (SharePoint direct file URL): "https://somewhere.sharepoint.com/sites/aSiteName/Shared Documents/savedsearches.conf"
    ConfFilePath = "C:\Sources\splunk\apps\search\local\savedsearches.conf",

    // Detect if path is a web URL
    IsWeb = Text.StartsWith(ConfFilePath, "http", Comparer.OrdinalIgnoreCase),

    // Load file
    SourceBinary =
        if IsWeb then
            Web.Contents(ConfFilePath)
        else
            File.Contents(ConfFilePath),

    // Read as text
    ConfText =
        try Text.FromBinary(SourceBinary, TextEncoding.Utf8)
        otherwise Text.FromBinary(SourceBinary, TextEncoding.Windows),

    //----------------------------------
    // Helper: combine "\" continuations
    //----------------------------------
    CombineContinuations = (lines as list) as list =>
        let
            seed = [out = {}, carry = "", cont = false],
            folded =
                List.Accumulate(
                    lines,
                    seed,
                    (s, l) =>
                        let
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

    //----------------------------------
    // Parse text into [Stanza,Key,Value]
    //----------------------------------
    ParseSavedSearchesText = (confText as text) as table =>
        let
            lines0 = Lines.FromText(confText),
            lines  = CombineContinuations(lines0),
            filtered =
                List.Select(
                    lines,
                    (ln) =>
                        let t = Text.Trim(ln)
                        in (t <> "") and (not Text.StartsWith(t, "#"))
                ),
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
            asTable =
                if List.Count(rowsList) = 0
                then #table({"Stanza","Key","Value"}, {})
                else Table.FromRecords(rowsList, type table [Stanza=text, Key=text, Value=text])
        in
            asTable,

    Parsed = ParseSavedSearchesText(ConfText),

    //----------------------------------
    // Add metadata and pivot
    //----------------------------------
    PathNorm = Text.Replace(Text.Lower(ConfFilePath), "\", "/"),

    AddMeta =
        Table.AddColumn(Parsed, "FilePath", each ConfFilePath, type text),

    KeysList = List.Sort(List.Distinct(AddMeta[Key])),
    Pivoted = Table.Pivot(AddMeta, KeysList, "Key", "Value")
in
    Pivoted

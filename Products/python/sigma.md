# Install via pip
```bat
pip install sigma-cli
```

Install plugins
```bat
sigma plugin list
sigma plugin install splunk
```

# Convert Rules

- Assuming you are in a directory with a 'sigma' folder and inside it is the git repository 'sigma-master'.
- For Linux, use '\' in place of '^'
- If a single error is detected, no output file will result.

Basic Sample

- Just make sure the LAST property is always the source directory/file.

```bat
sigma convert ^
    --target splunk ^
    --pipeline splunk_windows ^
    ./sigma/sigma-master/rules
```

Use a Custom pipeline
```bat
    --pipeline my_pipeline.yml ^
```

Generate a savedsearches.conf file for splunk
```bat
    -f savedsearches ^
    --output ./sigma/output/output.txt ^
```

Output rules to a folder
```bat
    --output ./sigma/output/{rule}.txt ^
```

Review any  errors
```bat
--verbose ^
```

Stuffed example
```bat
sigma convert ^
    --target splunk ^
    --pipeline splunk_windows ^
    --output ./sigma/output/{rule}.txt ^
    ./sigma/sigma-master/rules
```

Mass-Convert via Powershell
- Assumes a python venv named "sigma" resides in user home directory.

```powershell
$venv = "C:\Users\youruser\python\sigma"
$inputDir = "./sigma-master/rules/windows/"
$outputDir = "./output"

# Ensure output directory exists
New-Item -ItemType Directory -Path $outputDir -Force

& "$venv\Scripts\Activate.ps1"

# Loop through each YAML rule file
Get-ChildItem -Path $inputDir -Recurse -Filter "*.yml" | ForEach-Object {
    $ruleName = $_.BaseName  # Extracts the filename without extension
    $outputFile = "$outputDir/$ruleName.txt"
    
    Write-Host "Converting: $($_.FullName) -> $outputFile"

    sigma convert --target splunk --pipeline splunk_windows --output $outputFile $_.FullName
    
}

deactivate
```
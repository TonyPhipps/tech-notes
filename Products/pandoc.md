https://github.com/jgm/pandoc

Install MiKTeX to convert to pdf
https://miktex.org/download

Convert from Markdown to Word
```
cd D:\path\to\file
pandoc README.md -s -o README.docx
```

Convert using extra options on output
```
cd D:\path\to\file
pandoc README.md -s -o README.docx -t markdown_strict --wrap=none
```
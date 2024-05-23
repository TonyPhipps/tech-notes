https://github.com/jgm/pandoc

Install MiKTeX to convert to pdf
https://miktex.org/download

# Adobe pdf

Go-To Conversion with Eisvogel Template (PDF Only)
https://github.com/Wandmalfarbe/pandoc-latex-template
```
pandoc "path\to\source.md" -o "output.pdf" --from markdown --template "eisvogel.latex" --listings --toc
```

Variables template, to be first lines of md file
```
---
title: "Your Title"
author: 
date: "2024-05-06"
subject: "Your Subject"
keywords: [your, tags]
subtitle: "Your Subtitle"
lang: "en"
titlepage: true
titlepage-logo: "images/logo.jpg"
logo-width: 400px
toc-own-page: true
papersize: letter
...
```

# HTML

```
pandoc -f markdown README.md -o README.html -s --highlight-style=tango --toc  
```

# Microsoft Word docx

Convert from Markdown to Word

Have pandoc produce a reference template. Change the styles in this as desired.

```
pandoc -o custom-reference.docx --print-default-data-file reference.docx
```

Basic example/test
```
cd D:\path\to\inputfile
pandoc -f markdown README.md -s -o README.docx
```

Convert using extra options and a reference doc to set styles
```
cd D:\path\to\inputfile
--wrap=none --toc --highlight-style=tango
pandoc README.md -f markdown -o mdtodoc.docx -t docx --highlight-style=tango --toc  --reference-doc .\custom-reference.docx
```
You will either get a popup when opening the docx to generate a TOC, or it will need to be manually updated by clicking on the TOC heading/area.

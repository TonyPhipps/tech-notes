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


Go-To Conversion with Eisvogel Template
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
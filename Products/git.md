First time setup (remove --global to set for just the current repository)
```
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

Use Git Credential Manager for Windows to handle creds, especially for locally-managed git servers
*See https://github.com/microsoft/Git-Credential-Manager-Core*
```
git config --global credential.helper manager
```

Edit global configs
(can set/blank credential manager manually)
```
git config --global --edit
```

Purge any line containing "word"
... in all file histories in the repository.

```
git filter-branch --tree-filter "find . -type f -exec sed -i -e '/$*word/d' {} \;" -f
```

Remove SSL Certificate verification 
(add --global to apply to all). WARNING: For troubleshooting only. Disables certification verification entirely, allowing MITM.
```
git config http.sslVerify false
```

Fix the error "SSL certificate problem: unable to get local issuer certificate"
```
git config --global http.sslBackend schannel
```

Display recent Git Changes
```
git --no-pager log --pretty=format:'\"%h\", \"%an\", \"%ci\", \"%s\", \"%b\"' --after "2023-11-30"
```


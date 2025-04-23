# First time setup (remove --global to set for just the current repository)
```
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

# Set Global AutoCRLF so EOL's are not changed
```
git config --global core.autocrlf false
```


# Edit global configs
(can set/blank credential manager manually)
```
git config --global --edit
```

# Cancel Pending Changes
```
git merge --abort
git rebase --abort
git restore .
```

# Delete Local Branch
Replace 'dev' with branch name
```
git branch -D dev
```

# Store Current Changes and Rebase
```
git stash
git pull origin master (or main)
git stash pop
```

# Purge any line containing "word"
... in all file histories in the repository.

```
git filter-branch --tree-filter "find . -type f -exec sed -i -e '/$*word/d' {} \;" -f
```

# Remove a single file from Git commit history
Great for removing accidentally huge files.
- First, ensure the repo is not protected
```
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch path/to/file.ext' --prune-empty --tag-name-filter cat -- --all
git gc
git repack
git push origin --force --all

```
- Schedule or wait for housekeeping to take place

# Use BFG To Remove a Single File
```
cd /path/to/bfg.jar
java -jar bfg-1.14.0.jar -b 100M D:\gitlab\ics-secops-scripts\
cd /path/to/gitrepo
git reflog expire --expire=now --all
git gc --prune=now --aggressive

```

# Remove SSL Certificate verification 
(add --global to apply to all). WARNING: For troubleshooting only. Disables certification verification entirely, allowing MITM.
```
git config http.sslVerify false
```

# Fix the error "SSL certificate problem: unable to get local issuer certificate"
```
git config --global http.sslBackend schannel
```

# Display recent Git Changes
```
git --no-pager log --pretty=format:'\"%h\", \"%an\", \"%ci\", \"%s\", \"%b\"' --after "2023-11-30"
```



# Setup SSH Key
Generate a key pair
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Start the ssh-agent in the background (as admin)
```
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
```

Add the SSH key to the ssh-agent (as non-admin)
```
sh-add c:/Users/YOU/.ssh/id_ed25519
```

Add the SSH key to the Github account
- Name > Settings > SSH and GPG Keys
- New SSH Key
- Copy contents of publickey.pub
- Paste into text block and provide a name

Attempt a Clone
- At the main repo page, click <> Code
- Go to Local > SSH tab
- Copy the Git address for SSH and use it to clone via VSCode


# Migrate a Repo

- Open the source repo in terminal
- Issue these commands
```
git remote add remoterepo https://yourLogin@github.com/yourLogin/yourRepoName.git
git push --mirror remoterepo
```
- Then go in and set the default branch and remove the old default as needed.
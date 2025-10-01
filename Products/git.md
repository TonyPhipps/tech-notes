- [First time setup (remove --global to set for just the current repository)](#first-time-setup-remove---global-to-set-for-just-the-current-repository)
- [Set Global AutoCRLF so EOL's are not changed](#set-global-autocrlf-so-eols-are-not-changed)
- [Edit global configs](#edit-global-configs)
- [Cancel Pending Changes](#cancel-pending-changes)
- [Delete Local Branch](#delete-local-branch)
- [Store Current Changes and Rebase](#store-current-changes-and-rebase)
- [Purge any line containing "word"](#purge-any-line-containing-word)
- [Remove a single file from Git commit history](#remove-a-single-file-from-git-commit-history)
- [Use BFG To Remove a Single File](#use-bfg-to-remove-a-single-file)
- [Remove SSL Certificate verification](#remove-ssl-certificate-verification)
- [Fix the error "SSL certificate problem: unable to get local issuer certificate"](#fix-the-error-ssl-certificate-problem-unable-to-get-local-issuer-certificate)
- [Display recent Git Changes](#display-recent-git-changes)
- [Setup SSH Key](#setup-ssh-key)
- [Using Two GitHub Accounts with SSH on Windows](#using-two-github-accounts-with-ssh-on-windows)
- [Migrate a Repo](#migrate-a-repo)


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
ssh-add c:\Users\YOU\.ssh\id_ed25519
```

Add the SSH key to the Github account
- Name > Settings > SSH and GPG Keys
- New SSH Key
- Copy contents of id_ed25519.pub
- Paste into text block and provide a name

Attempt a Clone
- At the main repo page, click <> Code
- Go to Local > SSH tab
- Copy the Git address for SSH and use it to clone via VSCode

# Using Two GitHub Accounts with SSH on Windows
Explains how to configure **two separate GitHub accounts** (e.g. `work` and `personal`) on a single Windows machine using SSH.

### Generate separate SSH keys for each account

Work account
```powershell
ssh-keygen -t ed25519 -C "work-email@example.com" -f $HOME\.ssh\id_ed25519_work
```

- **Private key:** `id_ed25519_work`  
- **Public key:** `id_ed25519_work.pub`  

Personal account
```powershell
ssh-keygen -t ed25519 -C "personal-email@example.com" -f $HOME\.ssh\id_ed25519_personal
```

- **Private key:** `id_ed25519_personal`  
- **Public key:** `id_ed25519_personal.pub`  

**Important:**  
- The **private key** (`id_ed25519_*`) stays only on your computer.  
- The **public key** (`*.pub`) is uploaded to GitHub.  

### Add each public key to the right GitHub account

Copy the contents of each **public key** (`.pub`) file to the clipboard and add it in GitHub:
- Go to **GitHub → Settings → SSH and GPG keys → New SSH key**.  
- Paste the correct public key into the matching GitHub account.  

### Configure SSH to tell accounts apart

Edit (or create) the file ```C:\Users\<You>\.ssh\config```

Add:

```
# Work account
Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes

# Personal account
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
  IdentitiesOnly yes
```

### Start the SSH agent and load both private keys

```powershell
# Enable and start ssh-agent
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent

# Clear old keys (optional)
ssh-add -D

# Add private keys
ssh-add c:\Users\YOU\.ssh\id_ed25519_work
ssh-add c:\Users\YOU\.ssh\id_ed25519_personal

# Verify
ssh-add -l
```

### Test authentication

```powershell
ssh -T git@github-work
ssh -T git@github-personal
```

Expected output:
```
Hi WorkUser! You've successfully authenticated...
Hi PersonalUser! You've successfully authenticated...
```

### Use the correct account per repo

When cloning or updating remotes, use the alias defined in `~/.ssh/config`.

#### Work repo
```powershell
git clone git@github-work:WorkUser/RepoName.git

# Or if repo already exists
git remote set-url origin git@github-work:WorkUser/RepoName.git
```

#### Personal repo
```powershell
git clone git@github-personal:PersonalUser/RepoName.git

# Or if repo already exists
git remote set-url origin git@github-personal:PersonalUser/RepoName.git
```



# Migrate a Repo

- Open the source repo in terminal
- Issue these commands
```
git remote add remoterepo https://yourLogin@github.com/yourLogin/yourRepoName.git
git push --mirror remoterepo
```
- Then go in and set the default branch and remove the old default as needed.
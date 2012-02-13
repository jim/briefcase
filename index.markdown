---
layout: home
title: Briefcase
---

briefcase is a tool to facilitate keeping dotfiles in git, including those with
private information (such as `.gitconfig`).

By keeping your configuration files in a git public git repository, you
can share your settings with others. Any secret information is kept in a
single file outside the repository (it's up to you to backup and
transport this file).


## Getting started

<pre>
$ gem install briefcase
$ briefcase import ~/.bashrc

You don't appear to have a git repository at /Users/jim/.dotfiles. Do you want
to create one now?
?  (create or abort) c
<span class="info">Creating git repository at /Users/jim/.dotfiles</span>
</pre>

At this point, a git repository will have been created at `~/.dotfiles`,
and `bashrc` will have been moved there and added to the git index. You
can verify this using `briefcase git`, which passes everything through to
the `git` executable (assuming it is installed and on your path).

    $ briefcase git status

    # On branch master
    # Changes to be committed:
    #   (use "git rm --cached <file>..." to unstage)
    #
    # new file:   bashrc

You'll probably want to check the `bashrc` file into your new git repo. Which
can be done using the `git` command again.

    $ briefcase git ci -m "Added bashrc"

Great. You've successfully added the first file to your new dotfiles
repo. I recommend creating a repo on Github or another Git hosting
service, adding it as a remote, and pushing your dotfiles there for
safekeeping.

    $ briefcase git remote add origin git@github.com:jim/dotfiles.git
    $ briefcase git push origin master

## Commands

### import

Imports a dotfile into the dotfiles directory, moving it to the dotfiles directory
and replacing it with a symlink to its new location.

<pre>
$ briefcase import ~/.vimrc

<span class="intro">Importing /Users/jim/.vimrc into /Users/jim/.dotfiles</span>
<span class="info">Moving /Users/jim/.vimrc to /Users/jim/.dotfiles/vimrc</span>
<span class="info">Symlinking /Users/jim/.vimrc -> /Users/jim/.dotfiles/vimrc</span>
<span class="success">Done.</span>
</pre>

### redact

Imports a dotfile that contains sensitive information.

<pre>
$ briefcase redact ~/.config_with_secrets

<span class="intro">Importing /Users/jim/.config_with_secrets into /Users/jim/.dotfiles</span>
<span class="info">Moving /Users/jim/.config_with_secrets to /Users/jim/.dotfiles/config_with_secrets</span>
<span class="info">Symlinking /Users/jim/.config_with_secrets -> /Users/jim/.dotfiles/config_with_secrets</span>
<span class="info">Creating redacted version at /Users/jim/.dotfiles/config_with_secrets.redacted</span>
</pre>

The user is presented with an editor (either `vim` or the value of the environment
variable `BRIEFCASE_EDITOR`), where sensitive information like this:

    password: superSecretPassword

can be replaced with what appears to be a commented out call to a briefcase function:

    password: # briefcase(password)

When the file is saved and closed, Briefcase will detect this change and save
`superSecretPassword` to the sercets file using the key `password`.

The edited file is then saved with a `.redacted` extension, and the original file is
added to `~/.dotfiles/.gitignore` so it will not be added to the repository.

<pre>
<span class="info">Storing secret value for key: password</span>
<span class="info">Adding /Users/jim/.dotfiles/config_with_secrets.redacted to /Users/jim/.dotfiles/.gitignore</span>
<span class="success">Done.</span>
</pre>


### sync
Creates a symlink in the user's home directory for each dotfile in the dotfiles
directory.

<pre>
$ briefcase sync

<span class="intro">Synchronizing dotfiles between /Users/jimb/.dotfiles and /Users/jimb</span>
<span class="info">Symlink verified: /Users/jimb/.ackrc -> /Users/jimb/.dotfiles/ackrc</span>
<span class="info">Symlink verified: /Users/jimb/.autotest -> /Users/jimb/.dotfiles/autotest</span>
<span class="info">Symlink verified: /Users/jimb/.gitconfig -> /Users/jimb/.dotfiles/gitconfig</span>
<span class="info">Symlink verified: /Users/jimb/.gvimrc -> /Users/jimb/.dotfiles/gvimrc</span>
<span class="info">Symlink verified: /Users/jimb/.irbrc -> /Users/jimb/.dotfiles/irbrc</span>
<span class="info">Symlink verified: /Users/jimb/.vim -> /Users/jimb/.dotfiles/vim</span>
<span class="info">Symlink verified: /Users/jimb/.vimrc -> /Users/jimb/.dotfiles/vimrc</span>
<span class="info">Symlink verified: /Users/jimb/.zshenv -> /Users/jimb/.dotfiles/zshenv</span>
<span class="info">Symlink verified: /Users/jimb/.zshrc -> /Users/jimb/.dotfiles/zshrc</span>
<span class="success">Done.</span>
</pre>

### generate

Creates local versions of all redacted dotfiles, using information found in the
secrets file to fill in any values that were removed.

<pre>
$ briefcase generate

<span class="intro">Generating redacted dotfiles in /Users/jim/.dotfiles</span>
<span class="info">Generating /Users/jim/.dotfiles/gitconfig</span>
<span class="info">Loading existing secrets from /Users/jim/.briefcase_secrets</span>
<span class="info">Restoring secret value for key: git_user</span>
<span class="info">Restoring secret value for key: git_email</span>
<span class="info">Restoring secret value for key: github_user</span>
<span class="info">Restoring secret value for key: github_token</span>
<span class="success">Done.</span>
</pre>


### git

The `git` command passes all commands through to the `git` executable,
assuming it is installed on your path. All commands are executed in your
dotfiles directory.

    $ briefcase git status

    # On branch master
    nothing to commit (working directory clean)

## Filesystem layout

With briefcase, dotfiles are stored in a centralized location (by default ~/.dotfiles),
and symlinks are created for these files in the user's home directory. Here
is a basic setup for a .gitconfig file:

    +-~/                      Home directory
    | +-.briefcase_secrets    Secrets file
    | +-.gitconfig            Symlink to ~/.dotfiles/gitconfig
    | +-.dotfiles/            Dotfiles directory
    | | +-gitconfig           Standard Dotfile
    | | +-gitconfig.redacted  Redacted dotfile

### Home directory

Where the action happens. Dotfiles that normally exist here are replaced by
symlinks to files in the dotfiles directory.

> **Default location: `~`**
> Override by setting BRIEFCASE_HOME_PATH in your environment.

### Dotfiles directory

Where dotfiles are stored.

> **Default location: `~/.dotfiles`**
> Override by setting BRIEFCASE_DOTFILES_PATH in your environment.

There are two types of dotfiles.

#### Standard dotfiles

A basic config file that would normally live in a user's home directory.

#### Redacted dotfiles
A config file that contains some secret information. The file is stored, sans
secret info, with a '.redacted' extension in the repo. The dotfile that is
symlinked to the user's home directory is then generated from this file.

### Secrets file

This file contains the information removed from dotfiles imported using the
redact command.

> **Default location: `~/.briefcase_secrets`**
> Override by setting BRIEFCASE_SECRETS_PATH in your environment.

## Copyright

Copyright (c) 2012 Jim Benton. See LICENSE for details.

---
layout: home
title: Briefcase
---

# briefcase

briefcase is a tool to facilitate keeping dotfiles in git, including those with
private information (such as `.gitconfig`).


## Getting started

    gem install briefcase
    briefcase import ~/.bashrc

    You don't appear to have a git repository at #{dotfiles_path}. Do you want to create one now?
    $ y
    Creating git repository at #{dotfiles_path}


At this point, a git repository will have been created at `~/.dotfiles`. At some
point more of the git workflow will be automated (such as creating a repository
at Github), but for now most git tasks are manual:

    cd ~/.dotfiles
    git commit -m "Added bashrc"

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
<span class="info">Moving /Users/jim/.config_with_secrsts to /Users/jim/.dotfiles/config_with_secrets</span>
<span class="info">Symlinking /Users/jim/.config_with_secrets -> /Users/jim/.dotfiles/config_with_secrets</span>
<span class="info">Creating redacted version at /Users/jim/.dotfiles/config_with_secrets.redacted</span>

editor opens, after making changes as detailed above:

<span class="info">Storing secret value for key: password</span>
<span class="info">Adding /Users/jim/.dotfiles/config_with_secrets.redacted to /Users/jim/.dotfiles/.gitignore</span>
<span class="success">Done.</span>
</pre>

The user is presented with an editor, where the sensitive information can be
removed by replacing secret information with a commented out call to a
briefcase function:

    # before
    password: superSecretPassword

    # after
    password: # briefcase(password)

This file is then saved with a `.redacted` extension, and the original file is
added to `~/.dotfiles/.gitignore` so it will not be added to the repository.

`superSecretPassword` will be stored using the key `password` in the secrets file.

### sync
Creates a symlink in the user's home directory for each dotfile in the dotfiles
directory.

### generate
Creates local version of a redacted dotfile, using information found in the
secrets file to fill in any that was removed.


## Filesystem layout

With briefcase, dotfiles are stored in a centralized location (by default ~/.dotfiles),
and symlinks are created for these files in the user's home directory. Here
is a basic setup for a .gitconfig file:

    +-~/                      Home Directory
    | +-.briefcase_secrets    Secrets file
    | +-.gitconfig            Symlink to ~/.dotfiles/gitconfig
    | +-.dotfiles/            Dotfiles directory
    | | +-gitconfig           Standard Dotfile
    | | +-gitconfig.dynamic   Redacted dotfile

### Home directory (~)

Where the action happens. Dotfiles that normally exist here are replaced by
symlinks to files in the dotfiles directory

### Dotfiles directory (~/)

Where dotfiles are stored. There are two types of dotfiles.

#### Standard dotfiles

A basic config file that would normally live in a user's home directory.

#### Redacted dotfiles
A config file that contains some secret information. The file is stored, sans
secret info, with a '.redacted' extension in the repo. The dotfile that is
symlinked to the user's home directory is then generated from this file.

### Secrets file

This file, be default located at ~/.briefcase_secrets, contains the information
removed from dotfiles imported using the redact command.


## Configuration

The following environment variables can by used to customized the paths used by briefcase:

    BRIEFCASE_DOTFILES_PATH: dotfiles path, defaults to BRIEFCASE_HOME_PATH/.dotfiles
    BRIEFCASE_HOME_PATH: the user's home directory, defaults to ~
    BRIEFCASE_SECRETS_PATH: secrets path, defaults to BRIEFCASE_HOME_PATH/.briefcase_secrets


## Copyright

Copyright (c) 2011 Jim Benton. See LICENSE for details.


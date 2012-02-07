# Briefcase

[Briefcase](http://jim.github.com/briefcase/) is a tool to facilitate keeping dotfiles in git, including those with private information (such as .gitconfig).

By keeping your configuration files in a git public git repository, you can share your settings with others. Any secret information is kept in a single file outside the repository (it’s up to you to backup and transport this file).

[The project homepage](http://jim.github.com/briefcase/) includes
installation and usage documentation.

[![Build Status](https://secure.travis-ci.org/[jim]/[briefcase].png)](http://travis-ci.org/[jim]/[briefcase])

## Changelog

* 0.4.0 Renamed project Briefcase. First public release.
* 0.3.0 Added code documentation, internal renaming, general cleanup. First public release.
* 0.2.0 Added redact command, use .redacted for dynamic dotfiles
* 0.1.3 The sync command no longer creates symlinks for dynamic files
* 0.1.2 Added dynamic file generation

## Note on Patches/Pull Requests
* Fork the project.
* Make your feature addition or bug fix on a topic branch.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request.

## Copyright

Copyright (c) 2012 Jim Benton. See LICENSE for details.

# Dotfiles

### Description
A collection of configurations for my systems

## Prerequisites
- a c compiler
- make 
- zsh
- neofetch
- nvim
- ripgrep (telescope dep)

## Setup
- clone repo to $HOME/.config
    * if dir already exists and is not empty:
    * `cd $HOME/.config`
    * `git init`
    * `git remote add origin git@github.com:willacharlotte/dotfiles.git`
    * `git pull origin main --allow-unrelated-histories`
- init submodules with `git submodule update --init --recursive`
- add `ZDOTDIR=~/.config/zsh` to /etc/zsh/zshenv (create if doesn't exist)

## Windows config
- copy alacritty/ to %APPDATA%/alacritty/

## TODO
- find a way to symlink %APPDATA%/alacritty/ to alacritty/

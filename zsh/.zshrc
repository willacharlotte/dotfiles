# =================================
# Sources 
# =================================

[[ -f $ZDOTDIR/zsh_exports.zsh ]] && source $ZDOTDIR/zsh_exports.zsh
[[ -f $ZDOTDIR/zsh_aliases.zsh ]] && source $ZDOTDIR/zsh_aliases.zsh
[[ -f $ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && source $ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# =================================
# Keymaps
# =================================

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# =================================
# ZVM config
# =================================

# ZVM_VI_HIGHLIGHT_FOREGROUND=black
# ZVM_VI_HIGHLIGHT_BACKGROUND=white
ZVM_VISUAL_LINE_MODE_CURSOR=ZVM_CURSOR_BEAM

# =================================
# Prompt 
# =================================

# Constants
COLOUR_OK='white'
COLOUR_FAIL='red'
COLOUR_DULL='008'
LEADING_SYM='☾' 
ZGP_STAGED_SYM='+'
ZGP_UNSTAGED_SYM='!'
ZGP_UNTRACKED_SYM='?'

autoload -Uz add-zsh-hook

gen_git_message () {
  [[ -f $ZDOTDIR/plugins/zsh-git-parse/zsh-git-parse.plugin.zsh ]] && source $ZDOTDIR/plugins/zsh-git-parse/zsh-git-parse.plugin.zsh > /dev/null 2> /dev/null

  if [[ "$ZGP_IS_GIT" == true ]]; then
    GIT_MESSAGE="on $ZGP_BRANCH"

    if [[ $ZGP_STATUS_STAGED -ne 0 || $ZGP_STATUS_UNSTAGED -ne 0 || $ZGP_STATUS_UNTRACKED -ne 0 ]]; then
      GIT_MESSAGE+=" |"
      if [[ $ZGP_STATUS_STAGED -ne 0 ]]; then
        GIT_MESSAGE+=" $ZGP_STATUS_STAGED$ZGP_STAGED_SYM"
      fi
      if [[ $ZGP_STATUS_UNSTAGED -ne 0 ]]; then
        GIT_MESSAGE+=" $ZGP_STATUS_UNSTAGED$ZGP_UNSTAGED_SYM"
      fi
      if [[ $ZGP_STATUS_UNTRACKED -ne 0 ]]; then
        GIT_MESSAGE+=" $ZGP_STATUS_UNTRACKED$ZGP_UNTRACKED_SYM"
      fi
    fi
  else
    GIT_MESSAGE=''
  fi
}

add-zsh-hook precmd gen_git_message

setopt prompt_subst

# Prompt Definitions
PS1="%F{$COLOUR_DULL}%~%f %B%(?.%F{$COLOUR_OK}$LEADING_SYM%f.%F{$COLOUR_FAIL}$LEADING_SYM%f)%b "
RPS1='%F{$COLOUR_DULL}$GIT_MESSAGE%f'

# =================================
# Misc config
# =================================

# completion
autoload -Uz compinit
zstyle ':completion:*' menu select
setopt MENU_COMPLETE # disable 'double tab' with case insensitivity
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
compinit
_comp_options+=(globdots) # hidden files

# history size and location
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
# [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# neofetch on zsh open
neofetch

# remove beeps (unreliant)
unsetopt BEEP

# remove hightlight on pastes
zle_highlight=('paste:none')

# syntax highlighting: needs to be last
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =================================
# Cursors
# =================================

# \e[0 q or \e[ q: reset to what's defined in profile
# \e[1 q: blinking block
# \e[2 q: steady block
# \e[3 q: blinking underline
# \e[4 q: steady underline
# \e[5 q: blinking I-beam
# \e[6 q: steady I-beam


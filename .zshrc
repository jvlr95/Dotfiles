# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# set up the prompt
# autoload -Uz promptinit
# promptinit
# prompt adam1

setopt histignorealldups sharehistory

# Keep 1000 lines of history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# User configuration
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias exa='exa -alh --icons'
# alias terraform="tofu"
alias k='kubectl'
alias code='codium'
alias wk='watch kubectl get'
alias workstation='distrobox enter workstation'

# default 11cpus to make
#export MAKEFLAGS="-j11"

# ASDF - Bash & Git
. "$HOME/.asdf/asdf.sh"
# Rust tools dir
export PATH="$HOME/.cargo/bin:$PATH"
# Bin local
export PATH="$HOME/.local/bin:$PATH"
# golang 
export PATH=$PATH:~/.asdf/installs/golang/1.23.3/bin
export PATH=$PATH:~/.asdf/installs/golang/1.23.3/packages/bin
# python
export PATH=$PATH:~/.asdf/installs/python/3.12.0/bin
# java
export PATH=$PATH:~/.asdf/installs/java/openjdk-23/bin
# ruby
export PATH=$PATH:~/.asdf/installs/ruby/

# Kube Editor default
export KUBE_EDITOR=vim
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
# kubernetes tools
alias alpine='kubectl run "$USER-network-tools" -i --tty --image=alpine:latest --image-pull-policy=IfNotPresent --restart=Never --rm -- sh -c "apk update && apk add --no-cache busybox-extras bind-tools mtr iputils curl wget traceroute tcpdump redis zsh && zsh"'
#-------------------------------------------------------------------------------------------------------
# source theme p10k
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"

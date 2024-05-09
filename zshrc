# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
ZSH_THEME="powerlevel10k/powerlevel10k"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Plugins config
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)

# Export local bin
export $(dbus-launch)
. "$HOME/.asdf/asdf.sh"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# Custom editor kubernetes
export KUBE_EDITOR=vim
# Linuxbrew package manager
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Starship terminal
eval "$(starship init zsh)"
# alias
alias searchDir='source ~/.local/bin/searchDir'
alias viFind='source ~/.local/bin/viFind'
alias exal='exa -alh'
alias p3='python3 '
#Acessar Benji function
alias installbenji='npm install ~/Solinftec/scripts-infra/helpers/benji/'
alias benji='~/Solinftec/scripts-infra/helpers/benji/execFile.js'
alias vi='vim'

# Enable Powerlevel10k instant prompt (must stay near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git colorize)
source $ZSH/oh-my-zsh.sh

# PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"

# Google Cloud SDK
if [ -f '/Users/yuval/Downloads/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/yuval/Downloads/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/yuval/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/yuval/Downloads/google-cloud-sdk/completion.zsh.inc'
fi

# AWS
export AWS_PROFILE=staging-power
export PGSSLROOTCERT="${HOME}/.local/share/aws/ca-certificates/amazon-rds-us-east-1-root-ca-rsa2048-g1.pem"

# Shell keybindings (Emacs-style navigation)
bindkey "\eb" backward-word        # Option+Left (via escape sequence)
bindkey "\ef" forward-word         # Option+Right (via escape sequence)
bindkey "^U" backward-kill-line    # Ctrl+U = delete to start of line
bindkey "^K" kill-line             # Ctrl+K = delete to end of line
bindkey "^W" backward-kill-word    # Ctrl+W = delete word backward

# Aliases
alias grep='ggrep'
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"

autoload -Uz compinit
compinit

setopt autocd
setopt interactivecomments
setopt histignorealldups

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

PROMPT='%n@%m:%~ %# '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
export PATH="$HOME/.npm-global/bin:$PATH"

# OpenClaw Completion
source "/home/ldy/.openclaw/completions/openclaw.zsh"
alias claw='tmux attach -t openclaw || (tmux new-session -d -s openclaw && tmux send-keys -t openclaw "export https_proxy=http://127.0.0.1:10808 && openclaw dashboard" C-m && tmux attach -t openclaw)'

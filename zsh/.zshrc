# Enable Powerlevel10k instant prompt. Keep this block near the top of the file.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
export PATH="$HOME/.npm-global/bin:$PATH"

if [[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]]; then
  source "$HOME/.openclaw/completions/openclaw.zsh"
fi

alias claw='tmux attach -t openclaw || (tmux new-session -d -s openclaw && tmux send-keys -t openclaw "export https_proxy=http://127.0.0.1:10808 && openclaw dashboard" C-m && tmux attach -t openclaw)'

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

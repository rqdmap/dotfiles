source <(fzf --zsh)

export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

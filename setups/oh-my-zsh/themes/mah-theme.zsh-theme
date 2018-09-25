#!/usr/bin/env zsh

########## COLOR ###########
for COLOR in CYAN WHITE YELLOW MAGENTA BLACK BLUE RED DEFAULT GREEN GREY; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi


LINE_SPLIT_LIM=10


PR_RESET="%{$reset_color%}"
RED_START="${PR_RESET}${PR_GREY}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<${PR_RESET} "
RED_END="${PR_RESET}${PR_BRIGHT_RED}>${PR_RESET}${PR_RED}>${PR_GREY}>${PR_RESET} "
GREEN_END="${PR_RESET}${PR_BRIGHT_GREEN}>${PR_RESET}${PR_GREEN}>${PR_GREY}>${PR_RESET} "
GREEN_BASE_START="${PR_RESET}${PR_GREY}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>${PR_RESET}"
GREEN_START_P1="${PR_RESET}${GREEN_BASE_START}${PR_RESET} "
DIVISION="${PR_RESET}${PR_RED} < ${PR_RESET}"
VCS_DIRTY_COLOR="${PR_RESET}${PR_YELLOW}"
Vcs_CLEAN_COLOR="${PR_RESET}${PR_GREEN}"
VCS_SUFIX_COLOR="${PR_RESET}${PR_RED}› ${PR_RESET}"
# ########## COLOR ###########
# ########## SVN ###########
ZSH_THEME_SVN_PROMPT_PREFIX="${PR_RESET}${PR_RED}‹svn:"
ZSH_THEME_SVN_PROMPT_SUFFIX=""
ZSH_THEME_SVN_PROMPT_DIRTY="${VCS_DIRTY_COLOR}✘ ${VCS_SUFIX_COLOR}"
ZSH_THEME_SVN_PROMPT_CLEAN="${VCS_CLEAN_COLOR}✔ ${VCS_SUFIX_COLOR}"
# ########## SVN ###########
# ########## GIT ###########
ZSH_THEME_GIT_PROMPT_PREFIX="${PR_RESET}${PR_RED}(git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="${PR_RESET}${PR_RED}) ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_ADDED="${PR_RESET}${PR_YELLOW}✚ ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_MODIFIED="${PR_RESET}${PR_YELLOW}✹ ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_DELETED="${PR_RESET}${PR_YELLOW}✖ ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_RENAMED="${PR_RESET}${PR_YELLOW}➜ ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_RESET}${PR_YELLOW}═ ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${PR_RESET}${PR_YELLOW}✭ ${PR_RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY="${VCS_DIRTY_COLOR}✘ "
ZSH_THEME_GIT_PROMPT_CLEAN="${VCS_CLEAN_COLOR}✔ "
# ########## GIT ###########


# Context: user@directory or just directory
prompt_context () {
    if [[ -n "$SSH_CLIENT" ]]; then
        echo -n "${PR_RESET}%{$fg[$NCOLOR]%}$USER@%m${PR_RESET}${PR_BRIGHT_YELLOW} %~%<<${PR_RESET}"
    else
        echo -n "${PR_RESET}${PR_BRIGHT_YELLOW}%~%<<${PR_RESET}"
    fi
}

set_prompt () {
    # required for the prompt
    setopt prompt_subst
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -gt 8 ]]; then
        colors
    fi

    local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

    local prompt_info="$(prompt_context)"' $(git_super_status) $(svn_prompt_info)'
    local prompt_trailer='%{$fg[red]%}%(!.#.»)%{$reset_color%}'


    PROMPT="%{$fg[red]%}╭─%{$reset_color%} $prompt_info
%{$fg[red]%}╰%{$reset_color%}$prompt_trailer "

    PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
    RPROMPT=$return_code

    return
}

set_prompt

packages=(
    "pm:git"
    "pm:pygmentize"
    "pm:diff-so-fancy"
)

links=(
    "$ADM_DIR"/ $HOME/.config/git
    "$ADM_DIR"/spreadsheet2csv $HOME/.bin/spreadsheet2csv
    "$ADM_DIR"/git-listobjectsbysize $HOME/.bin/git-listobjectsbysize
)

st_rc() {
    alias g='git'

    alias ga='git add'
    alias gaa='git add --all'

    alias gc='git commit -v'
    alias gc!='git commit -v --amend'
    alias gcn!='git commit -v --no-edit --amend'
    alias gca='git commit -v -a'
    alias gca!='git commit -v -a --amend'
    alias gcmsg='git commit -m'

    alias gd='git diff'
    alias gdca='git diff --cached'

    alias gl='git pull'
    alias gp='git push'

    alias gl='git pull'
    alias glg='git log --stat'
    alias glgp='git log --stat -p'
    alias glgg='git log --graph'
    alias glgga='git log --graph --decorate --all'
    alias glgm='git log --graph --max-count=10'
    alias glo='git log --oneline --decorate'
    alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    alias glola="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
    alias glog='git log --oneline --decorate --graph'
    alias gloga='git log --oneline --decorate --graph --all'

    alias gsb='git status -sb'
    alias gst='git status'
    alias gsi='git status --ignored'

    alias grh='git reset HEAD'
}

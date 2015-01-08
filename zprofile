# ~/.zprofile .profile fot the z shell

# the default user is

if [[ -f ~/.zdefault_user ]]; then
    export DEFAULT_USER=$(cat ~/.zdefault_user)
fi
    

if [[ -f ~/.profile ]]; then
    source ~/.profile
fi

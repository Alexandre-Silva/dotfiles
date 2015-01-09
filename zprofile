# ~/.zprofile .profile fot the z shell

if [[ -f ~/.profile ]]; then
    emulate sh -c '. ~/.profile'
fi

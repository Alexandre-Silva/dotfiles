# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi


export EDITOR='gvim'
export VISUAL='gvim'
export PAGER='less'
export BROWSER='firefox'

#Merdas uteis em geral
export GIT_HOME="$HOME/.git"

export ECLIPSE_HOME="$HOME/.eclipse"
#export PATH=$ECLIPSE_HOME/eclipse:$PATH
export GWT_HOME="$ECLIPSE_HOME/plugins/com.google.gwt.eclipse.sdkbundle_2.6.0/gwt-2.6.0"

# jpdfboorkmarks
export JPDFBOOKMARKS_HOME=$HOME/.jpdfbookmarks
#export PATH=$PATH:$JPDFBOOKMARKS_HOME/jpdfbookmarks
#export PATH=$PATH:$JPDFBOOKMARKS_HOME/jpdfbookmarks_cli

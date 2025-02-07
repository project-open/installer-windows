# .bash_profile

export CVSROOT=":pserver:anonymous@cvs.project-open.net:/home/cvsroot"
export CVSREAD="yes"
export CVS_RSH="ssh"
export EDITOR=emacs

alias "l=ls -als"


# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

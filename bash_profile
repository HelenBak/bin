# git completion and prompt
source ~/.git-completion.bash
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1

start_sshagent()
{
    rm -rf /tmp/ssh-*
    ssh-agent -t 86400 > ~/.ssh-agent.sh
    #ssh-agent > ~/.ssh-agent.sh
    echo "No agent! ssh-agent started."
    . ~/.ssh-agent.sh
    ssh-add -k
}

if [ -f ~/.ssh-agent.sh ]; then
    SSHAGENT=$(pidof ssh-agent)
    if [ "$SSHAGENT" == "" ] ; then
        start_sshagent
    else
        . ~/.ssh-agent.sh
    fi

    if [ ! -e $SSH_AUTH_SOCK ] ; then
        echo "check exist SSH_AUTH_SOCK $SSH_AUTH_SOCK"
        start_sshagent
    fi
else
   start_sshagent
fi

if [ ! -S $SSH_AUTH_SOCK ] ; then
    start_sshagent
fi

# bash_aliases
if [ -f ~/.bash_aliases ] ; then
    . ~/.bash_aliases
fi

MY_LOCAL_PATH=/usr/local/sbin:/usr/local/bin
#MY_PKG_PATH=/usr/pkg/sbin:/usr/pkg/bin
MY_PKG_PATH=/opt/pkg/sbin:/opt/pkg/bin
MY_BIN=$HOME/bin:$HOME/src/bin:$HOME/.local/bin


#export GOROOT=/opt/pkg/go
#export GOPATH=$HOME/Documents/Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

export PATH=$MY_BIN:$GOROOT/bin:$GOPATH/bin:$MY_PKG_PATH:$MY_LOCAL_PATH:/bin:/usr/bin:/sbin:/usr/sbin
#export SVN_EDITOR=/usr/bin/vim
export EDITOR=vi
export PAGER=less
export IGNOREEOF=5

export CLICOLOR=1
#export LSCOLORS="exGxcxdxcxegedabagacad"
export LSCOLORS="GxFxcxdxCxegedCxCxExEx"
#export LSCOLORS="exfxcxdxcxegedabagacad"

######## function list ##########
title()
{
 local host_name;
 host_name=`hostname` 
 echo -ne "\033]0;$host_name \007"
}

# for svn version 
scm_ps() 
{
  local s=
  svn info >/dev/null 2>&1
  if [[ "_$?" = "_0" ]] ; then
    s=\(svn:$(LANG=en_US.UTF-8; svn info | sed -n -e '/^Last Changed Rev: \([0-9]*\).*$/s//\1/p' )\)
  else
    s="$(__git_ps1 "(git:%s)")"
  fi
  echo -n "${s}"
}

tmux_ps()
{
  local s=
  if [ -n "$TMUX" ] ; then
    s='$(tmux setenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) $PWD)'
    echo -n "${s}"
  fi
}
######## end function list ##########
title
export PS1=$(tmux_ps)$(color -p white)'<\T>'$(color -p 10)'[\h]'$(color -p 219)':$?:'$(color -p none)''$(color -p brightcyan)'\w'$(color -p brightred)'$(scm_ps)'$(color -p none)' \$'

umask 022

# less man page
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

ulimit -c unlimited

TMOUT=0

set -o vi

bind -m vi-insert "\C-l":clear-screen
#export LANG=ko_KR.EUC-KR
export LANG=en_US.UTF-8

#export http_proxy=http://username:password@my.proxy.com:8000
#export https_proxy=http://username:password@my.proxy.com:8000

export TERM=xterm-256color


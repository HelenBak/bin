# git completion and prompt
source ~/.git-completion.bash
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1

MY_LOCAL_PATH=/usr/local/sbin:/usr/local/bin
MY_BIN=$HOME/bin:$HOME/src/bin

export PATH=$MY_BIN:/bin:/usr/bin:/sbin:/usr/sbin:$MY_LOCAL_PATH
export SVN_EDITOR=/usr/bin/vim
export EDITOR=/usr/bin/vim
export PAGER=/usr/bin/less
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

# vi
alias vt='vi -t main'

#scons
alias sc='scons ver=14'
alias scc='scons -c'

# cmake
alias cmc='pushd ..;rm -rf build;mkdir build;popd'
alias cm='cmake ..'
alias cmp='cmake -DCMAKE_INSTALL_PREFIX=~/local ..'
alias cmd='cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ..'
alias cmb='cmake --build'
alias cmpd='cmake -DCMAKE_INSTALL_PREFIX=~/local -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ..'

# cd
alias wk='cd ~/work'
alias h='history'
alias rehash='hash -r'
alias ...='cd ../../'
alias ..='cd ..'
alias dc='cd'
alias cd-='cd -'
alias ps-ef='ps -ef'
alias tmux='tmux -2'
alias tm='tmux -2'
alias tma='tmux attach'
alias tms='tmux list-session'
#alias ldd='otool -L'

alias i='clang-format38 -style="{Language: Cpp, BreakBeforeBraces: WebKit, PointerAlignment: Left}" -i'
alias f='find . -name ".*.r[0-9]*" | grep -v ".svn"'
alias mkae='make'
alias amke='make'
alias amek='make'

alias diff='diff -Nurp -x ".svn"'
alias grep='grep --colour=auto --exclude=tags --exclude="*.svn*"'
alias rg='grep --colour=auto --exclude=\*.svn\* --exclude=tags -nr'
alias svndiff='svn diff --diff-cmd /usr/bin/diff -x -Nurp'
alias ob='objdump -S -l -w -D'

alias euckr='export LANG=ko_KR.EUC-KR;export LC_ALL=ko_KR.EUC-KR'
alias utf8='export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8'

alias 퍄='vi'
alias ㅊㅇ='cd'

alias rb='cd ~/work/regexbench'
alias twlib='cd ~/work/tw-lib'
alias twmgr='cd ~/work/tw-manager'
alias sf='cd ~/work/sniffles'

# for less color display
alias less='less -R'
alias vi='vim'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

ulimit -c unlimited

TMOUT=0

alias ssh='ssh -oStrictHostKeyChecking=no'
alias scp='scp -oStrictHostKeyChecking=no'
set -o vi

bind -m vi-insert "\C-l":clear-screen
#export LANG=ko_KR.EUC-KR
export LANG=en_US.UTF-8

#export http_proxy=http://username:password@my.proxy.com:8000
#export https_proxy=http://username:password@my.proxy.com:8000

export TERM=xterm-256color



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

# for less color display
alias less='less -R'
alias vi='vim'

alias ssh='ssh -oStrictHostKeyChecking=no'
alias scp='scp -oStrictHostKeyChecking=no'

# go
alias gw='cd $GOPATH'

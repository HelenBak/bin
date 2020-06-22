
# vi
alias vi='vim'
alias vt='vi -t main'
alias vd='vimdiff'

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

# tmux
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

# grep
alias diff='diff -Nurp -x ".svn"'
alias grep='grep --colour=auto --exclude=tags --exclude="cscope.**"'
alias rg='grep --colour=auto --exclude=\*.svn\* --exclude=tags -nr'
alias svndiff='svn diff --diff-cmd /usr/bin/diff -x -Nurp'
alias ob='objdump -S -l -w -D'

alias euckr='export LANG=ko_KR.EUC-KR;export LC_ALL=ko_KR.EUC-KR'
alias utf8='export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8'

alias 퍄='vi'
alias ㅊㅇ='cd'

# for less color display
alias less='less -R'

alias ssh='ssh -oStrictHostKeyChecking=no'
alias scp='scp -oStrictHostKeyChecking=no'

# go
alias gw='cd $GOPATH'
alias gr='cd $GOROOT'
alias gf='gofmt'

# ipmitool
alias sipm='ipmitool -H 10.10.10.201 -U ADMIN -P ADMIN -I lanplus'
alias fipm='ipmitool -H 10.10.10.202 -U ADMIN -P ADMIN -I lanplus'

# expect
alias server='expect -f ~/.ssh/expect/Server.ex'
alias db='expect -f ~/.ssh/expect/LabeuDb.ex'
alias bpvr='expect -f ~/.ssh/expect/LabeuBpVr.ex'

# kraken
alias wkk='cd ~/work/kraken'
alias kbp='cd ~/work/kraken/cmd/blackpearl'
alias kvr='cd ~/work/kraken/cmd/vrouter'
alias kpt='cd ~/work/kraken/proto/vpc'
alias kpb='cd ~/work/kraken/pb/vpc'
alias kpkg='cd ~/work/kraken/pkg'
alias kdev='cd ~/work/kraken.dev'
alias bp='cd cmd/blackpearl'
alias vr='cd cmd/vrouter'

# ovs
alias vls='./cache/bin/vrouter list --rpc-addr 172.16.21.129:5555| jq -r '
alias fwin='sudo ovs-ofctl -O OpenFlow13 dump-flows ovsbr --color --names table=140'
alias fwe='sudo ovs-ofctl -O OpenFlow13 dump-flows ovsbr --color --names table=40'

#docker
alias dmysql='sudo docker exec -it mysql mysql -uroot -pcloudinfra'

# ssh
alias keyadd='ssh-add ~/.ssh/id_rsa'
alias sgtest='~/work/kraken/scripts/securitygroup/sgtest.sh'
alias sgconf='cp ~/work/kraken/scripts/securitygroup/sgtest.conf.example ./sgtest.conf'

# bin
bash, vim, tmux, git, screen, cscope, tags, tigrc, clang-format. doxygen format, color 등의 환경 설정 저장
아래 파일을 실행하면 계정 디렉토리에 환경파일이 링크로 생성

``` setconf.sh ```
## 지원 OS
* Linux/FreeBSD

## 환경파일 설명
* bash
* vimrc, vim
* tmux
* gitconfig,gitignore,git-prompt.sh
* screen
* mkcscope.sh
* tigrc
* ycm_extra_conf.py
* clang-format
* inputrc
* lesshst
* color

## git
``` git clone --recurse-submodules https://github.com/HelenBak/bin.git ```

## submodule 
``` git submodule init/update ```

## Linux 환경

### install
``` apt install cscope ctag vim.nox ```

### ycm 컴파일
```
apt install python-dev 
install.py --clang-completer
```
### vim 설치 관리자
[참고] https://nolboo.kim/blog/2016/09/20/vim-plugin-manager-vundle/
1. vim 명령 모드에서 :PluginInstall을 실행
1. 터미널에서 vim +PluginInstall +qall로 플러그인을 설치

## FreeBSD 환경

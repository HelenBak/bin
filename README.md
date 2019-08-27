# bin
bash, vim, tmux, git, screen, cscope, tags, tigrc, clang-format. doxygen format, color 등의 환경 설정 저장
아래 파일을 실행하면 계정 디렉토리에 환경파일이 링크로 생성
``` setconf.sh ```

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
``` apt install cscope ctag vim.nox python-dev ```

### vim 설치 관리자
[참고] https://nolboo.kim/blog/2016/09/20/vim-plugin-manager-vundle/
1. vim 명령 모드에서 :PluginInstall을 실행
1. 터미널에서 vim +PluginInstall +qall로 플러그인을 설치

### ycm 컴파일
```
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer
```

## FreeBSD 환경

## MacOS 환경

### brew command
``` /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ```

### install
```
brew install --with-python3 vim
```
###  VIM에서 Python개발을 위한 편집
[참고] http://egloos.zum.com/mcchae/v/11321964

#### 필요한 패키지 설치
```
brew install vim ctags git ack
pip install pep8 flake8 pyflakes isort yapf
```

#### vimrc 새로 설정
```
mv ~/.vimrc ~/.vimrc.org
wget -O ~/.vimrc  https://raw.github.com/fisadev/fisa-vim-config/master/.vimrc 
```



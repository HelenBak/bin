#!/usr/bin/env bash
#
#

# [2017.03.10] sy82free
# 
# 목적: env 내의 개인환경파일을 사용하기 위해서 생성된 스크립트
#
#

ENV="$HOME/bin"
DATE=`date +%y%m%d%k%M%S`
LN="/bin/ln"
MV="/bin/mv"
TR="/usr/bin/tr"
ANSWER=

toLower()
{
	eval "$2=`echo $1 | $TR '[A-Z]' '[a-z]'`"
}

toUpper()
{
	eval "$2=`echo $1 | $TR '[a-z]' '[A-Z]'`"
}

is_this_ok()
{
	read INPUT

	# 답변이 없는 경우
	if [ "_$INPUT" == "_" ] ; then
		#echo "  >> Answer is NO."
		return 1
	fi

	# 소문자로 변환
	#ANSWER=`echo $INPUT | tr '[A-Z]' '[a-z]'`
	toLower $INPUT ANSWER
	# 답변이 yes가 아닌 경우 (
	if [ "$ANSWER" != "y" ] && [ "$ANSWER" != "yes" ] ; then
		#echo "  >> Answer is NO."
		return 1
	fi

	return 0;
}

error()
{
	echo -e " [ \033[40;31mERROR\033[0m ] \033[40;31m$1\033[\0m"
}

question()
{
	echo -e " [  \033[40;32mQnA\033[0m  ] \033[40;32m$1\033[\0m"
	echo -n "  > $2 (N/y)? "
}

setconf()
{
	SRC="$ENV/$1"

	if [ "_$2" == "_" ] ; then
		question "$SRC -> $HOME/$1" "Do you want to make link path"

		is_this_ok $SRC $1
		RET=$?
		if [ $RET -eq 1 ]; then
			return
		fi

		DST="$HOME/$1"
	elif [ "$2" == "." ] ; then
		# 만약에 .이면 첫이름앞에 ".이름"으로 링크파일 생성
		DST="$HOME/.$1"
	else
		DST="$HOME/$2"
	fi

	# SRC 경로가 있는지 확인
	#if [ ! -e $SRC ] || [ ! -d $SRC ] ;then
	if [ ! -e $SRC ] ;then
		error "$SRC don't exist."

		# SRC는 없는데 경로가 있다면?
		if [ -e $DST ] ; then
			error "But $DST exist."
		fi
		return
	fi

	if [ -h $DST ] ;then
		echo " [ EXIST ] $DST"
	elif [ -e $DST ] ;then
		echo -e " [ \033[40;36mMOVE\033[0m  ] \033[40;31m$DST -> $DST.$DATE\033[\0m"
		$MV $DST $DST.$DATE

		echo -e " [ \033[40;35mCHANGE\033[0m] \033[40;32m$DST\033[\0m ($SRC)"
		$LN -s $SRC $DST
	elif [ ! -h $DST ] ;then
		echo -e " [ \033[40;33mN E W\033[\0m ] \033[40;36m$DST\033[\0m ($SRC)"
		$LN -s $SRC $DST
	else
		echo " [ EXIST ] $DST"
	fi
}

echo  -e "\033[37mSetting My Config\033[m"

# BASH
setconf bash_profile .
setconf bash_aliases .

#GIT
setconf gitignore .
setconf git-completion.bash .
setconf gitconfig .
setconf gitignore .
setconf git-prompt.sh .

# tmux use, screen disable
#setconf screenrc .

# SSH
setconf ssh .

# VIM
setconf vim .
setconf vimrc .vimrc

# tig
setconf tigrc .

# TMUX
setconf tmux.conf .
setconf tmux .
setconf tmux-powerlinerc .

# tmuxifier disable
#setconf tmuxifier .
#setconf tmuxifier/layouts .layouts
#setconf tmuxifier.conf .

setconf inputrc .
setconf clang-format .
setconf lesshst .

# testing
#setconf testing

echo  -e "\033[37mComplete\033[m"

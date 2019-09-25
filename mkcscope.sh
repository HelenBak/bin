#!/bin/sh

# 2019.09.25 
# 공백을 쓰고자 했으나 cscope명령에서 문제가 발생했지만 해결 못함 
# G_PWD=$(echo $PWD| sed 's/ /\\ /g')
#`find -E "/Users/suadmin/Documents/Go/fastGo/golangbook/Unit 65" -regex '( |.)*\.(c(pp|c)?|h(pp)?|py|go)' > $CSCOPE_FILES`

G_PWD=$PWD
CSCOPE_FILES=cscope.files
PWD_CSCOPE_FILES=$G_PWD/$CSCOPE_FILES

delete_cscope_files()
{
 rm -f cscope.in.out
 rm -f cscope.out
 rm -f cscope.po.out
 rm -f tags
}

do_cscope_files_linux()
{
    rm -rf cscope.out

    find $G_PWD -regextype posix-egrep -regex '.*\.(c(pp)?|h|py|go)' > $G_PWD/$CSCOPE_FILES

    cscope -b -k -q -i cscope.files

    rm -rf cscope.files

    ctags -R

    echo Complete
}

do_cscope_files_freebsd()
{
    rm -rf cscope.out

    find -E $G_PWD -regex '.*\.(c(pp|c)?|h(pp)?|py|go)' > $G_PWD/$CSCOPE_FILES

    cscope -b -k -q -i cscope.files

    rm -rf cscope.files

    exctags -R

    echo Complete
}

do_cscope_files_darwin()
{
    rm -rf cscope.out

    find -E $G_PWD -regex '( |.)*\.(c(pp|c)?|h(pp)?|py|go)' > $G_PWD/$CSCOPE_FILES

    cscope -b -k -q -i $CSCOPE_FILES

    rm -rf $CSCOPE_FILES

    ctags -R

    echo Complete
}

do_cscope_files()
{

    os=`uname`
    case $os in
        Linux)
            do_cscope_files_linux
            ;;
        FreeBsd)
            do_cscope_files_freebsd
            ;;
        Darwin)
            do_cscope_files_darwin
            ;;
        *)
            echo " `basename $0` is support linux/freebsd." >&2
        ;;
    esac
}

check_space_in_path()
{
    if [[ "$G_PWD" =~ " " ]]; then
        echo "Check whitespace in this path.($G_PWD)"
        exit 128
    fi
}

_action=${1:-start}
check_space_in_path

case ${_action} in
    start)
        do_cscope_files
        exit 0
        ;;

    stop)
        delete_cscope_files
        exit 1
        ;;

    restart)
        ;;

    *)
        echo " `basename $0` {start|stop|restart}" >&2
        exit 64
        ;;
esac
exit 0

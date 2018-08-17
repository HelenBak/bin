#!/bin/sh

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

    find $PWD -regextype posix-egrep -regex '.*\.(c(pp)?|h|py)' > $PWD/cscope.files

    cscope -b -k -q -i cscope.files

    rm -rf cscope.files

    ctags -R

    echo Complete
}

do_cscope_files_freebsd()
{
    rm -rf cscope.out

    find -E $PWD -regex '.*\.(c(pp|c)?|h(pp)?|py)' > $PWD/cscope.files

    cscope -b -k -q -i cscope.files

    rm -rf cscope.files

    exctags -R

    echo Complete
}

do_cscope_files()
{

    os=`uname`
    case $os in
        Linux)
            do_cscope_files_linux
            ;;
        FreeBsd|Darwin)
            do_cscope_files_freebsd
            ;;
        *)
            echo " `basename $0` is support linux/freebsd." >&2
        ;;
    esac
}

_action=${1:-start}

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

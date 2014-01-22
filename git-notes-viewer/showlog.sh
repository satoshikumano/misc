USAGE="Usage: `basename $0` [-h] [-l number]"

if [ $# -eq 0 ]; then
    echo $USAGE
fi
# Parse command line options.
while getopts hl: OPT; do
    case "$OPT" in
        h)
            echo $USAGE
            exit 0
            ;;
        l)
            LIMIT=$OPTARG
            echo number limitation: $LIMIT
            ;;
        \?)
            # getopts issues an error message
            echo $USAGE >&2
            exit 1
            ;;
    esac
done

# Remove the switches we parsed above.
shift `expr $OPTIND - 1`

# Add actual process

out=`git notes | sed -e 's/ .*$//g'`
count=1
for line in $out
do
    if test -z "$LIMIT" || test $count -le $LIMIT; then
        tag=`git show $line | grep Version:`
        desc=`git show $line | grep Description:`
        if test -n "$tag" && test -n "$desc"; then
            echo ---------------------------------------------------------------------------------------------------
            echo $tag
            echo $desc
            echo ---------------------------------------------------------------------------------------------------
        fi
        count=$((count+1))
    else
        break
    fi
done

# EOF

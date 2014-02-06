USAGE="Usage: `basename $0` [-h] [-l number]"

if [ $# -eq 0 ]; then
    echo $USAGE
fi

out=`git notes | sed -e 's/ .*$//g'`
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
            out=`echo $out | head -n $LIMIT`
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

# output in console.
for line in $out
do
    tag=`git show $line | grep Version:`
    issue=`git show $line | grep Issue:`
    desc=`git show $line | grep Description:`
    if test -n "$tag" && test -n "$desc"; then
        echo ---------------------------------------------------------------------------------------------------
        echo $tag
        if test -n "$issue"; then
            echo $issue
        fi
        echo $desc
        echo "Note object: $line"
        echo ---------------------------------------------------------------------------------------------------
    fi
done

# EOF

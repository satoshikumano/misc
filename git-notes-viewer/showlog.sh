USAGE="Usage: `basename $0` [-h] [-l number] [-v version]"

if [ $# -eq 0 ]; then
    echo $USAGE
fi

out=`git notes | sed -e 's/ /,/g'`
# Parse command line options.
while getopts hlv: OPT; do
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
        v)
            version=$OPTARG
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
    IFS=','
    set -- $line
    tag=`git show $1 | grep "Version: $version"`
    issue=`git show $1 | grep Issue:`
    desc=`git show $1 | grep Description:`
    if test -n "$tag" && test -n "$desc"; then
        echo $tag
        if test -n "$issue"; then
            echo $issue
        fi
        echo $desc
        echo "Note object: $1"
        echo "Commit: $2"
        echo --------------------------------------------------------------------------------
    fi
done

# EOF

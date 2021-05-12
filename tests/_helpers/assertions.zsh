_zunit_assert_mock_times() {
    local target=$1
    local count=$2
    shift 2

    local len=$(cat -- ${target}_mock_times)
    if [[ $len != $count ]]; then
        echo "'$target' is called for $len times(s)"
        exit 1
    fi

    local i
    for (( i = 1; i <= len; i++ )); do
        local mock=${target}_mock_$i
        if [[ -e ${mock}_fail ]]; then
            echo "$mock: $(cat -- ${mock}_fail)"
            exit 1
        fi
    done
}

_zunit_post_assert() {
    local -A replacements=(
        \$reset_color $reset_color
        \$bold_color $bold_color
    )

    local var key value name target
    for var in fg fg_bold fg_no_bold bg bg_bold bg_no_bold; do
        for key in ${(k)${(P)var}}; do
            name="\$$var\[$key\]"
            replacements[$name]=${${(P)var}[$key]}
        done
    done

    local input=$(cat)
    for key in ${(k)replacements}; do
        target=${key//\\/}
        [[ -z $tap ]] && target='\e[4;38;5;242m'$target'\e[4;31m'

        input=${input//${replacements[$key]}/$target}
    done

    echo -n - $input
}
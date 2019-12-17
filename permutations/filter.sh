#/bin/sh

random_string()
{
    cat /dev/urandom | base64 | fold -w ${1:-10} | head -n 1
}

save () {
    for i do printf %s\\n "$i" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/' \\\\/" ; done
    echo " "
}

load() {
    set -o noglob
    eval "set -- $1"
    set +o noglob
}

count_len() {
    char="$1"
    string="$2"

    echo "${string}" | awk -F"${char}" '{print NF}'
}

get_from_input() {
    input="$1"
    n="$2"

    oIFS="$IFS"
    IFS=","
    set -o noglob
    set -- $input
    set +o noglob
    IFS="$oIFS"

    eval echo \"\${"$n"}\"
}

get_input() {
    inputs="$1"
    n="$2"

    oIFS="$IFS"
    IFS=";"
    set -o noglob
    set -- $inputs
    set +o noglob
    IFS="$oIFS"

    eval echo \"\${"$n"}\"
}

get_from_output() {
    output="$1"
    n="$2"

    oIFS="$IFS"
    IFS=","
    set -o noglob
    set -- $output
    set +o noglob
    IFS="$oIFS"

    eval echo \"\${"$n"}\"
}

get_output() {
    outputs="$1"
    n="$2"

    oIFS="$IFS"
    IFS=";"
    set -o noglob
    set -- $outputs
    set +o noglob
    IFS="$oIFS"

    eval echo \"\${"$n"}\"
}

run() {
    echo "run:"

    echo "$1" | while read k
    do
        echo "> $k"
    done
}

run_on() {
    local num="$1"
    local pre="$2"

    if [ "$num" -eq 0 ]
    then
        run "$pre" || return 1
        return 0
    fi

    ls -1 "/input/$num" | while read j
    do
        run_on $((num-1)) "$(echo "$j"; echo "$pre")" || return 1
    done
}

main() {
    inputs_meta="${INPUTS_META:-}"
    outputs_meta="${OUTPUTS_META:-}"

    if ! [ "$(count_len ';' "$inputs_meta")" -eq "$(count_len ';' "$outputs_meta")" ]
    then
        echo "Number of inputs must match number of outputs."
        failed=true
        return 1
    fi
    if [ "$(count_len ';' "$inputs_meta")" -eq 1 ]
    then
        cp -r /input/* /output/
        return 0
    fi
    # ls -1 /input | while read f
    # do
    #     ls -1 "$f" | while read j
    #     do
    #         if echo "$j" | grep ';'
    #         then
    #             echo "Job contains ';': $j."
    #             failed=true
    #             return 1
    #         fi
    #     done || return 1
    # done || return 1

    run_on "$(ls -1 /input | wc -l)" "" || return 1
}

failed=false

main || failed=true

$failed && echo "Failure." && exit 1
echo "Done."

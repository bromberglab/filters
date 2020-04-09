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


main() {
    inputs_meta="${INPUTS_META:-}"
    outputs_meta="${OUTPUTS_META:-}"

    if ! [ "$(count_len ';' "$outputs_meta")" -eq "$(ls -1 /input/ | wc -l)" ]
    then
        echo "Number of inputs must match number of outputs."
        failed=true
        return 1
    fi
    if [ "$(count_len ';' "$outputs_meta")" -lt 2 ]
    then
        echo "At least 2 inputs required."
        failed=true
        return 1
    fi

    i=0
    ls -1 /input | while read f
    do
        i=$((i+1))
        cp -r "/input/$f" /outputs/$i
    done
}

failed=false

main || failed=true

$failed && echo "Failure." && exit 1
echo "Done."

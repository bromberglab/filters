#/bin/sh

failed=false
i=0

ls -1 /input | while read job
do
    if ! [ "$(ls -1 "/input/$job" | wc -l)" -eq 0 ]
    then
        if ! [ "$(ls -1 "/input/$job" | wc -l)" -eq 1 ]
        then
            echo "Too many files for job $job."
            failed=true
            exit 1
        fi

        filename="$(ls -1 "/input/$job")"

        cat "/input/$job/$filename" | while read line
        do
            i=$((i+1))
            mkdir -p "/output/$i.$job"
            echo "$line" > "/output/$i.$job/$filename"
        done
    fi
done

$failed && echo "Failure." && exit 1
exit 0

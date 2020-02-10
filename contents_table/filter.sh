#/bin/sh

failed=false
i=0

ls -1 /input | while read job
do
    if ! [ "$(ls -1 "/input/$job" | wc -l)" -eq 0 ]
    then
        ls -1 "/input/$job" | while read filename
        do
            mkdir /output/csv.job
            echo "$job;$filename;$(cat "/input/$job/$filename")" >> /output/csv.job/table.csv
        done
    fi
done

$failed && echo "Failure." && exit 1
exit 0

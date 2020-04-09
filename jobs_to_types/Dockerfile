FROM alpine

LABEL bio-node="v1" \
    tier=3 \
    bio-node_entrypoint=false \
    input="*" \
    output_n="*" \
    parallelism=0 \
    parameters='--override-job-name myjob'

ADD filter.sh /

ENTRYPOINT [ "sh", "-c", "/filter.sh" ]

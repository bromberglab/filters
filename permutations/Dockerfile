FROM alpine

LABEL bio-node="v1" \
    tier=3 \
    bio-node_entrypoint=false \
    input_n="*" \
    output_n="*" \
    parallelism=0

ADD filter.sh /

ENTRYPOINT [ "sh", "-c", "/filter.sh" ]

FROM alpine

LABEL bio-node="v1" \
    tier=3 \
    bio-node_entrypoint=false \
    input="*" \
    output="*"

ADD filter.sh /

ENTRYPOINT [ "sh", "-c", "/filter.sh" ]

echo "${DOCKER_PASSWORD}" | docker login -u ${DOCKER_USERNAME} --password-stdin

ls -1 | while read filter
do
    if [ -d "$filter" ]
    then
        cd "$filter"
        docker build -t "bromberglab/bio-node-filter.$filter" .
        docker push "bromberglab/bio-node-filter.$filter"
        cd ..
    fi
done

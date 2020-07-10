echo "${DOCKER_PASSWORD}" | docker login -u ${DOCKER_USERNAME} --password-stdin

ls -1 | while read filter
do
    if [ -d "$filter" ]
    then
        cd "$filter"
        docker build -t "bio-node-filters/$filter" .
        docker push "bio-node-filters/$filter"
        cd ..
    fi
done

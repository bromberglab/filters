ls -1 | while read filter
do
    if [ -d "$filter" ]
    then
        cd "$filter"
        docker build -t "gcr.io/$GKE_PROJECT/filters/$filter"
        docker push "gcr.io/$GKE_PROJECT/filters/$filter"
        cd ..
    fi
done

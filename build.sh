find . -type d -depth 1 | while read filter
do
    cd "$filter"
    docker build -t "gcr.io/$GKE_PROJECT/filters/$filter"
    docker push "gcr.io/$GKE_PROJECT/filters/$filter"
    cd ..
done

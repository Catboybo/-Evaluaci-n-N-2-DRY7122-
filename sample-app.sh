#!/bin/bash

docker rm -f samplerunning || true
docker rmi -f sampleapp || true

rm -rf tempdir

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "FROM python:3.8-slim" >> tempdir/Dockerfile
echo "ENV PIP_NO_CACHE_DIR=1" >> tempdir/Dockerfile
echo "ENV PIP_DISABLE_PIP_VERSION_CHECK=1" >> tempdir/Dockerfile
echo "RUN pip install flask --no-cache-dir --progress-bar off" >> tempdir/Dockerfile

echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile

echo "EXPOSE 9999" >> tempdir/Dockerfile

echo "CMD python /home/myapp/sample_app.py" >> tempdir/Dockerfile

cd tempdir

docker build -t sampleapp .

docker run -t -d -p 9999:9999 --name samplerunning sampleapp

docker ps -a

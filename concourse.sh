#cloud-config
#/bin/bash

if [ $1 == "web" ] ; then
    /usr/bin/docker run --name web -h web --dns=8.8.8.8 -v '/home/ec2-user/keys/web:/concourse-keys' -e CONCOURSE_EXTERNAL_URL='${external_name}' -e CONCOURSE_POSTGRES_HOST='${postgres_endpoint}' -e CONCOURSE_POSTGRES_DATABASE='concourse' -e CONCOURSE_POSTGRES_SSLMODE='disable' -e CONCOURSE_POSTGRES_PORT='5432' -e CONCOURSE_POSTGRES_PASSWORD='${postgres_password}' -e CONCOURSE_POSTGRES_USER='${postgres_username}' -e CONCOURSE_GARDEN_DNS_SERVER='8.8.8.8' -e CONCOURSE_BASIC_AUTH_USERNAME='${concourse_username}' -e CONCOURSE_BASIC_AUTH_PASSWORD='${concourse_password}' --restart=always -p 8080:8080 concourse/concourse:${concourse_version} web
elif [ $1 == "worker" ] ; then
    /usr/bin/docker run --name worker --link='web' --privileged -v '/home/ec2-user/keys/worker:/concourse-keys' -e CONCOURSE_GARDEN_DNS_SERVER='8.8.8.8' -e CONCOURSE_TSA_HOST='web:2222' --restart=always concourse/concourse:${concourse_version} worker
fi
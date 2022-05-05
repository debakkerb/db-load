#!/usr/bin/env bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source ../app/.envrc
source ../loadgenerator/.envrc

IMAGE_TAG=$(git describe --always --dirty)

kubectl create namespace blog

ROOT_SQL_PASSWORD=$(openssl rand -base64 18)
BLOG_SQL_PASSWORD=$(openssl rand -base64 18)

kubectl create secret -n blog generic mysql-db-credentials \
  --from-literal username=blog-user \
  --from-literal root-password=$ROOT_SQL_PASSWORD \
  --from-literal blog-password=$BLOG_SQL_PASSWORD

kubectl apply -f ./mysql.yaml

MYSQL_STATUS=$(kubectl get pods --selector=app=mysql --output="jsonpath={.items[*].status.phase}")
echo "MySQL Pod Status: ${MYSQL_STATUS}"

while [ "${MYSQL_STATUS}" != "Running" ]; do
  echo "MySQL not ready yet, status: ${MYSQL_STATUS}"
  sleep 5
  MYSQL_STATUS=$(kubectl -n blog get pods --selector=app=mysql --output="jsonpath={.items[*].status.phase}")
done

echo "Deploying blog application with name ${IMAGE_NAME} and tag ${IMAGE_TAG}"

sed \
  -e "s~#IMAGE_NAME~${BLOG_IMAGE_NAME}~g" \
  -e "s~#IMAGE_TAG~${IMAGE_TAG}~g" \
  ./blog.yaml \
  | kubectl apply -f -

BLOG_ADDRESS=$(kubectl -n blog get services blog --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

while [ -z "${BLOG_ADDRESS}" ]; do
  echo "Blog address not running: ${BLOG_ADDRESS}"
  sleep 5
  BLOG_ADDRESS=$(kubectl -n blog get services blog --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
done

echo "Validating application deployment ..."
curl http://${BLOG_ADDRESS}/v1/healthcheck

BODY='{"title":"Blog Title","intro":"introduction","content":"content"}'
curl -i -d "$BODY" http://${BLOG_ADDRESS}/v1/blogposts

sed \
  -e "s~#IMAGE_NAME~${LOAD_GENERATOR_IMAGE_NAME}~g" \
  -e "s~#IMAGE_TAG~${IMAGE_TAG}~g" \
  ./loadgenerator.yaml \
  | kubectl apply -f -

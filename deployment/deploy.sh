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

kubectl apply -f ./01_-_namespace.yaml

ROOT_SQL_PASSWORD=$(openssl rand -base64 18)
BLOG_SQL_PASSWORD=$(openssl rand -base64 18)

kubectl create secret -n blog generic mysql-db-credentials \
  --from-literal username=blog-user \
  --from-literal root-password=$ROOT_SQL_PASSWORD \
  --from-literal blog-password=$BLOG_SQL_PASSWORD

kubectl apply -f ./02_-_mysql.yaml

kubectl apply -f ./03_-_blog.yaml

BLOG_ADDRESS=$(kubectl -n blog get services blog --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Validating application deployment ..."
curl http://${BLOG_ADDRESS}/v1/healthcheck

BODY='{"title":"Blog Title","intro":"introduction","content":"content"}'
curl -i -d "$BODY" http://34.79.15.143/v1/blogposts


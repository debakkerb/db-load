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

# Include variables from .envrc file
include ./.envrc

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N]' && read ans && [ $${ans:-N} = y ]

## run/blog: Run the cmd/blog application
.PHONY: run/blog
run/blog:
	go run ./cmd/blog -db-dsn=${BLOGPOST_DB_DSN}

## db/mysql: Connect to the database using mysql
.PHONY: db/mysql
db/mysql:
	mysql ${BLOGPOST_DB_DSN}

# ==================================================================================== #
# BUILD
# ==================================================================================== #

current_time := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
git_description := $(shell git describe --always --dirty)
linker_flags = '-s -X main.buildTime=${current_time} -X main.version=${git_description}'

## build/blog: build the cmd/blog application
.PHONY: build/blog
build/blog:
	@echo 'Building cmd/blog ...'
	go build -ldflags=${linker_flags} -o=./bin/blog ./cmd/blog
	GOOS=linux GOARCH=amd64 go build -ldflags=${linker_flags} -o=./bin/linux_amd64/blog ./cmd/blog

## build/docker: Build the cmd/blog application in a docker container
.PHONY: build/docker
build/docker:
	@echo 'Building cmd/blog container ...'
	docker build -t ${IMAGE_NAME}:${git_description} ./ && docker push ${IMAGE_NAME}:${git_description}
	@echo 'New container image created, with tag ${git_description}'


# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

.PHONY: audit
audit:
	@echo 'Formatting code ...'
	go fmt ./...
	@echo 'Vetting code ...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests ...'
	go test -race -vet=off ./...

.PHONY: vendor
vendor:
	@echo 'Tidying and verifying module dependencies ...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies ...'
	go mod vendor

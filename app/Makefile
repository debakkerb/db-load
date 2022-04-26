# Include variables from .envrc file
include .envrc

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

## run/api: Run the cmd/api application
.PHONY: run/api
run/api:
	go run ./cmd/api -db-dsn=${BLOGPOST_DB_DSN}

## db/mysql: Connect to the database using mysql
.PHONY: db/mysql
db/mysql:
	mysql ${BLOGPOST_DB_DSN}

# ==================================================================================== #
# BUILD
# ==================================================================================== #

current_time = $(shell date --iso-8601=seconds)
git_description = $(shell git describe --always --dirty)
linker_flags = '-s -X main.buildTime=${current_time} -X main.version=${git_description}'

## build/api: build the cmd/api application
.PHONY: build/api
build/api:
	@echo 'Building cmd/api ...'
	go build -ldflags=${linker_flags} -o=./bin/blog ./cmd/api
	GOOS=linux GOARCH=amd64 go build -ldflags=${linker_flags} -o=./bin/linux_amd64/api ./cmd/api

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

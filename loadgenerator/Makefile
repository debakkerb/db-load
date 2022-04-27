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
# BUILD
# ==================================================================================== #

git_description := $(shell git describe --always --dirty)

## build/docker: Build the cmd/blog application in a docker container
.PHONY: build/docker
build/docker:
	@echo 'Building load generator container ...'
	docker build -t ${IMAGE_NAME}:${git_description} ./ && docker push ${IMAGE_NAME}:${git_description}
	@echo 'New container image created, with tag ${git_description}'
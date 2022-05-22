/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  project_id  = var.create_project ? format("%s-%s-%s", var.prefix, var.project_name, random_id.randomizer.hex) : var.project_name
  parent_type = var.parent == null ? null : split("/", var.parent)[0]
  parent_id   = var.parent == null ? null : split("/", var.parent)[1]
}

resource "random_id" "randomizer" {
  byte_length = 2
}

data "google_project" "existing_project" {
  count      = var.create_project ? 0 : 1
  project_id = local.project_id
}

resource "google_project" "default" {
  count               = var.create_project ? 1 : 0
  org_id              = local.parent_type == "organizations" ? local.parent_id : null
  folder_id           = local.parent_type == "folders" ? local.parent_id : null
  name                = local.project_id
  project_id          = local.project_id
  billing_account     = var.billing_account_id
  auto_create_network = var.auto_create_network
  labels              = var.labels
  skip_delete         = var.skip_delete
}

resource "google_project_service" "" {
  service = ""
}
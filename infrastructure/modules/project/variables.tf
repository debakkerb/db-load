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

variable "auto_create_network" {
  description = "Create the default network in the project."
  type        = bool
  default     = false
}

variable "billing_account_id" {
  description = "Billing account to be attached to the project."
  type        = string
  default     = null
}

variable "create_project" {
  description = "Indicate whether a new project should be created or an existing one should be used."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to be added to the project."
  type        = map(string)
  default     = {}
}

variable "parent" {
  description = "Parent for the project.  Has to be either 'organizations/org_id' or 'folders/folder_id'."
  type        = string
  default     = null
}
variable "prefix" {
  description = "Prefix that will be added at the front of resource names."
  type        = bool
  default     = "tst"
}

variable "project_name" {
  description = "Name of the project to be created.  If resources are deployed in an existing project, this should match the project ID and 'create_project' has to be set to true."
  type        = string
  default     = "demo"
}

variable "skip_delete" {
  description = "Allows the underlying resources to be deleted, without destroying the project."
  type        = bool
  default     = false
}
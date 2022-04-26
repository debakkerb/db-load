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

import random
from locust import HttpUser, TaskSet, between

def get_headers():
    """ Generate HTTP headers """
    headers = {
        "Content-Type": "application/json"
    }


def get_api_payload():
    """ Generate Request Body """
    payload = {

    }
    return payload


class LocustClient(FastHttpUser):
    host = ""
    wait_time = constant(0)

    def __init__(self, environment):
       """ Constructor """
       super().__init__(environment)

    def on_start(self):
        """ on_start is called before any task is scheduled. """
        pass

    def on_stop(self):
        """ on_stop is called when TaskSet is stopping. """
        pass

    @task
    def test_blogpost_service(self):
        """ This method contains all the APIs that needs to be load tested for a service. """
        headers = get_headers()

        try:
            api_payload = json.dumps(get_api_payload())
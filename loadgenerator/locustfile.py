#!/usr/bin/python

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
import json
import logging
import random
import time

from locust import TaskSet, between

__author__ = "Bjorn De Bakker"

from locust.contrib.fasthttp import FastHttpUser

blog_paragraph = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore " \
                 "et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut " \
                 "aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse " \
                 "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in " \
                 "culpa qui officia deserunt mollit anim id est laborum."


def get_headers():
    """ Generate HTTP headers """
    headers = {
        "Content-Type": "application/json"
    }
    return headers


def get_api_payload():
    """ Generate Request Body """
    current_date_time = time.strftime("%d/%m/%Y %H:%M:%S")
    post_title = f'Blog Post {current_date_time}'

    post_intro = blog_paragraph

    post_content = ""

    for x in range(0, random.randint(1, 10)):
        post_content += blog_paragraph
        post_content += '\n\n'

    payload = {
        "title": post_title,
        "intro": post_intro,
        "content": post_content
    }

    return payload


def create_blog_post(l):
    headers = get_headers()
    try:
        l.client.post('/v1/blogposts', data=json.dumps(get_api_payload()), headers=headers)
    except Exception as e:
        logging.error(f'Exception while creating blogpost: {e}')


class UserBehavior(TaskSet):

    def on_start(self):
        """ This method is called when a Task is being started. """
        pass

    tasks = {
        create_blog_post: 1
    }


class WebsiteUser(FastHttpUser):
    tasks = [UserBehavior]
    wait_time = between(1, 10)

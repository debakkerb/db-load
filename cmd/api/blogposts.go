package main

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

import (
	"db-load/internal/data"
	"fmt"
	"net/http"
)

func (app *application) createBlogPostHandler(w http.ResponseWriter, r *http.Request) {
	var input struct {
		Title   string `json:"title"`
		Intro   string `json:"intro"`
		Content string `json:"content"`
	}

	err := app.readJSON(w, r, &input)
	if err != nil {
		app.badRequestResponse(w, r, err)
		return
	}

	blogpost := &data.BlogPost{
		Title:   input.Title,
		Intro:   input.Intro,
		Content: input.Content,
	}

	err = app.models.BlogPosts.Insert(blogpost)
	if err != nil {
		app.serverErrorResponse(w, r, err)
		return
	}

	headers := make(http.Header)
	err = app.writeJSON(w, http.StatusCreated, envelope{"blogpost": blogpost}, headers)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}

func (app *application) showBlogPostsHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Show all blogposts")
}

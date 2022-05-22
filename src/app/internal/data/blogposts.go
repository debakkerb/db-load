package data

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
	"database/sql"
	"time"
)

type BlogPost struct {
	ID        int64     `json:"id"`
	CreatedAt time.Time `json:"created_at"`
	Title     string    `json:"title"`
	Intro     string    `json:"intro"`
	Content   string    `json:"content"`
}

type BlogPostModel struct {
	DB *sql.DB
}

func (b BlogPostModel) Insert(blogpost *BlogPost) (int64, error) {
	stmt := `
		INSERT INTO blogposts(title, intro, content, created)
		VALUES (?, ?, ?, UTC_TIMESTAMP())`

	result, err := b.DB.Exec(stmt, blogpost.Title, blogpost.Intro, blogpost.Content)
	if err != nil {
		return 0, err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return 0, err
	}

	return id, nil
}

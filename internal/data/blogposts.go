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

func (b BlogPostModel) Insert(blogpost *BlogPost) error {
	query := `
		INSERT INTO blogposts(title, intro, content)
		VALUES ($1, $2, $3) 
		RETURNING id, created_at`

	args := []interface{}{blogpost.Title, blogpost.Intro, blogpost.Content}
	return b.DB.QueryRow(query, args...).Scan(&blogpost.ID, &blogpost.CreatedAt)
}

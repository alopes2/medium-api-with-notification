package main

type Request struct {
	Title  string   `json:"title"`
	Rating float64  `json:"rating"`
	Genres []string `json:"genres"`
}

type Response struct {
	ID     string   `json:"id"`
	Title  string   `json:"title"`
	Rating float64  `json:"rating"`
	Genres []string `json:"genres"`
}

type ErrorResponse struct {
	Message string `json:"message"`
}

type Movie struct {
	ID     string   `dynamodbav:",string"`
	Title  string   `dynamodbav:",string"`
	Genres []string `dynamodbav:",stringset,omitemptyelem"`
	Rating float64  `dynamodbav:",number"`
}

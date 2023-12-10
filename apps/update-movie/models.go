package main

type Request struct {
	Title  string   `json:"title"`
	Rating float64  `json:"rating"`
	Genres []string `json:"genres"`
}

type ErrorResponse struct {
	Message string `json:"message"`
}

type MovieData struct {
	Title  string   `dynamodbav:":title,string" json:"title"`
	Genres []string `dynamodbav:":genres,stringset,omitemptyelem"  json:"genres"`
	Rating float64  `dynamodbav:":rating,number"  json:"rating"`
}

package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

// Response See https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html#urls-response-payload
type Response struct {
	Body       string            `json:"body"`
	Headers    map[string]string `json:"headers"`
	Status     string            `json:"status"`
	StatusCode int               `json:"statusCode"`
}

func main() {
	lambda.Start(Handler)
}

// Handler Lambda handler function.
func Handler() (*Response, error) {
	return &Response{
		Body:       "Hello from Lambda!",
		StatusCode: 200,
		Status:     "OK!",
		Headers: map[string]string{
			"Content-Type": "text/html;charset=utf-8",
		},
	}, nil
}

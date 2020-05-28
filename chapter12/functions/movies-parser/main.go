package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"

	"github.com/PuerkitoBio/goquery"
	lambdaRegistrator "github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/aws/external"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type Movie struct {
	ID          string    `json:"id"`
	Title       string    `json:"title"`
	Poster      string    `json:"poster"`
	ReleaseDate string    `json:"releaseDate"`
	Rating      string    `json:"rating"`
	Genre       string    `json:"genre"`
	Description string    `json:"description"`
	Videos      []string  `json:"videos"`
	Similar     []Similar `json:"similar"`
	Actors      []Actor   `json:"actors"`
	Rank        string    `json:"rank"`
}

type Similar struct {
	Title  string `json:"title"`
	Poster string `json:"poster"`
}

type Actor struct {
	Picture string `json:"picture"`
	Name    string `json:"name"`
	Role    string `json:"role"`
}

type Input struct {
	Title string `json:"title"`
	Rank  string `json:"rank"`
	ID    string `json:"id"`
}

type Event struct {
	Records []Record `json:"Records"`
}

type Record struct {
	Body string `json:"Body"`
}

func ParseMovie(movieHTML string) (Movie, error) {
	movie := Movie{}

	doc, err := goquery.NewDocumentFromReader(strings.NewReader(movieHTML))
	if err != nil {
		return movie, err
	}

	movie.Title = strings.TrimSpace(doc.Find(".title_wrapper h1").Text())
	movie.Rating = strings.TrimSpace(doc.Find(".ratingValue").Text())
	movie.ReleaseDate = strings.TrimSpace(doc.Find(".title_wrapper .subtext a").Last().Text())

	img, _ := doc.Find(".poster a img").Attr("src")
	movie.Poster = strings.TrimSpace(img)

	movie.Description = strings.TrimSpace(doc.Find(".summary_text").Text())

	videos := make([]string, 0)
	doc.Find(".mediastrip_big .video-modal img").Each(func(i int, s *goquery.Selection) {
		img, _ := s.Attr("src")
		videos = append(videos, img)
	})
	movie.Videos = videos

	actors := make([]Actor, 0)
	doc.Find(".cast_list tbody tr").Each(func(i int, s *goquery.Selection) {
		img, _ := s.Find("td:nth-child(1) img").Attr("src")

		actors = append(actors, Actor{
			Name:    strings.TrimSpace(s.Find("td:nth-child(2)").Text()),
			Picture: strings.TrimSpace(img),
			Role:    strings.TrimSpace(s.Find(".character").Text()),
		})
	})
	movie.Actors = actors

	similar := make([]Similar, 0)
	doc.Find(".rec_item img.rec_poster_img").Each(func(i int, s *goquery.Selection) {
		img, _ := s.Attr("src")
		title, _ := s.Attr("title")

		similar = append(similar, Similar{
			Poster: strings.TrimSpace(img),
			Title:  strings.TrimSpace(title),
		})
	})
	movie.Similar = similar

	return movie, nil
}

func format(payload interface{}) string {
	response, _ := json.Marshal(payload)
	return string(response)
}

func handler(event Event) error {
	cfg, err := external.LoadDefaultAWSConfig()
	if err != nil {
		return err
	}

	httpClient := &http.Client{}
	dynamodbClient := dynamodb.New(cfg)

	for _, record := range event.Records {
		input := Input{}
		json.Unmarshal([]byte(record.Body), &input)

		url := fmt.Sprintf("https://www.imdb.com/title/%s", input.ID)
		reqHttp, err := http.NewRequest("GET", url, nil)
		if err != nil {
			return err
		}
		reqHttp.Header.Add("Accept-Language", "en-us")

		respHttp, err := httpClient.Do(reqHttp)
		defer respHttp.Body.Close()
		if respHttp.StatusCode != 200 {
			return errors.New(fmt.Sprintf("status code error: %d %s", respHttp.StatusCode, respHttp.Status))
		}

		data, _ := ioutil.ReadAll(respHttp.Body)

		movie, err := ParseMovie(string(data))
		if err != nil {
			return err
		}
		movie.ID = input.ID
		movie.Rank = input.Rank

		reqPutItem := dynamodbClient.PutItemRequest(&dynamodb.PutItemInput{
			TableName: aws.String(os.Getenv("TABLE_NAME")),
			Item: map[string]dynamodb.AttributeValue{
				"id": dynamodb.AttributeValue{
					S: aws.String(movie.ID),
				},
				"title": dynamodb.AttributeValue{
					S: aws.String(movie.Title),
				},
				"rating": dynamodb.AttributeValue{
					S: aws.String(movie.Rating),
				},
				"rank": dynamodb.AttributeValue{
					S: aws.String(movie.Rank),
				},
				"poster": dynamodb.AttributeValue{
					S: aws.String(movie.Poster),
				},
				"description": dynamodb.AttributeValue{
					S: aws.String(movie.Description),
				},
				"releaseDate": dynamodb.AttributeValue{
					S: aws.String(movie.ReleaseDate),
				},
				"actors": dynamodb.AttributeValue{
					S: aws.String(format(movie.Actors)),
				},
				"videos": dynamodb.AttributeValue{
					S: aws.String(format(movie.Videos)),
				},
				"similar": dynamodb.AttributeValue{
					S: aws.String(format(movie.Similar)),
				},
			},
		})
		_, err = reqPutItem.Send(context.Background())
		if err != nil {
			return err
		}
	}

	return nil
}
func main() {
	lambdaRegistrator.Start(handler)
}

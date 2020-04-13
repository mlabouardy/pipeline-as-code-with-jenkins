package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/aws/external"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Movie struct {
	ID          string    `json:"id"`
	Title       string    `json:"title"`
	Poster      string    `json:"poster"`
	ReleaseDate string    `json:"releaseDate" bson:"releaseDate"`
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

func main() {
	mongoDBClient, err := mongo.Connect(context.Background(), options.Client().ApplyURI(os.Getenv("MONGO_URI")))
	if err != nil {
		log.Fatal(err)
	}
	collection := mongoDBClient.Database(os.Getenv("MONGO_DATABASE")).Collection("movies")

	httpClient := &http.Client{}

	cfg, _ := external.LoadDefaultAWSConfig()
	sqsClient := sqs.New(cfg)

	cfg.Region = os.Getenv("AWS_REGION")

	for {
		req := sqsClient.ReceiveMessageRequest(&sqs.ReceiveMessageInput{
			QueueUrl: aws.String(os.Getenv("SQS_URL")),
		})
		respSQS, err := req.Send(context.Background())
		if err != nil {
			log.Fatal(err)
		}

		rawMovie := Movie{}
		json.Unmarshal([]byte(*respSQS.Messages[0].Body), &rawMovie)

		url := fmt.Sprintf("https://www.imdb.com/title/%s", rawMovie.ID)
		reqHttp, err := http.NewRequest("GET", url, nil)
		if err != nil {
			log.Fatal(err)
		}
		reqHttp.Header.Add("Accept-Language", "en-us")

		respHttp, err := httpClient.Do(reqHttp)
		defer respHttp.Body.Close()
		if respHttp.StatusCode != 200 {
			log.Fatalf("status code error: %d %s", respHttp.StatusCode, respHttp.Status)
		}

		data, _ := ioutil.ReadAll(respHttp.Body)

		movie, err := ParseMovie(string(data))
		if err != nil {
			log.Fatal(err)
		}
		movie.Rank = rawMovie.Rank
		movie.ID = rawMovie.ID

		log.Println(movie.Title)

		_, err = collection.InsertOne(context.Background(), movie)
		if err != nil {
			log.Fatal(err)
		}

		reqDeleteMessage := sqsClient.DeleteMessageRequest(&sqs.DeleteMessageInput{
			QueueUrl:      aws.String(os.Getenv("SQS_URL")),
			ReceiptHandle: respSQS.Messages[0].ReceiptHandle,
		})
		_, err = reqDeleteMessage.Send(context.Background())
		if err != nil {
			log.Fatal(err)
		}
		time.Sleep(6 * time.Second)
	}
}

package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

var movies []Movie

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

func respondWithJson(w http.ResponseWriter, code int, payload interface{}) {
	response, _ := json.Marshal(payload)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}

func crawlPage(m Movie) {
	httpClient := &http.Client{}
	url := fmt.Sprintf("https://www.imdb.com/title/%s", m.ID)
	reqHttp, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatal(err)
	}
	reqHttp.Header.Add("Accept-Language", "en-us")

	respHttp, err := httpClient.Do(reqHttp)
	defer respHttp.Body.Close()
	if err != nil {
		log.Fatal(err)
	}

	if respHttp.StatusCode != 200 {
		log.Fatalf("status code error: %d %s", respHttp.StatusCode, respHttp.Status)
	}

	data, _ := ioutil.ReadAll(respHttp.Body)
	movie, err := ParseMovie(string(data))
	if err != nil {
		log.Fatal(err)
	}
	movie.Rank = m.Rank
	movie.ID = m.ID

	movies = append(movies, movie)

	log.Println(movie.Title)
}

func init() {
	jsonFile, err := os.Open("movies.json")
	if err != nil {
		log.Fatal(err)
	}
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	parsedMovies := make([]Movie, 0)
	json.Unmarshal(byteValue, &parsedMovies)

	for _, m := range parsedMovies {
		go crawlPage(m)
	}
}

func MoviesHandler(w http.ResponseWriter, r *http.Request) {
	respondWithJson(w, http.StatusOK, movies)
}

func IndexHandler(w http.ResponseWriter, r *http.Request) {
	respondWithJson(w, http.StatusOK, map[string]string{"message": "up"})
}

func main() {
	http.HandleFunc("/movies", MoviesHandler)
	http.HandleFunc("/", IndexHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

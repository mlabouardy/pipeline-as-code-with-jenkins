package main

import (
	"testing"
)

const HTML = `
<div class="plot_summary ">
    <div class="summary_text">
        An ex-hit-man comes out of retirement to track down the gangsters that killed his dog and took everything from him.
    </div>
</div>
<div class="title_wrapper">
    <h1 class="">John Wick (2014)</h1>
    <div class="subtext">
        R
        <span class="ghost">|</span> <time datetime="PT101M">
            1h 41min
        </time>
        <span class="ghost">|</span>
        <a href="/search/title?genres=action&amp;explore=title_type,genres&amp;ref_=tt_ov_inf">Action</a>,
        <a href="/search/title?genres=crime&amp;explore=title_type,genres&amp;ref_=tt_ov_inf">Crime</a>,
        <a href="/search/title?genres=thriller&amp;explore=title_type,genres&amp;ref_=tt_ov_inf">Thriller</a>
        <span class="ghost">|</span>
        <a href="/title/tt2911666/releaseinfo?ref_=tt_ov_inf" title="See more release dates">24 October 2014 (USA)
        </a> </div>
</div>
`

func TestParseMovie(t *testing.T) {
	expectedMovie := Movie{
		Title:       "John Wick (2014)",
		ReleaseDate: "24 October 2014 (USA)",
		Description: "An ex-hit-man comes out of retirement to track down the gangsters that killed his dog and took everything from him.",
	}

	currentMovie, err := ParseMovie(HTML)

	if err != nil {
		t.Error("Should return nil value")
	}

	if expectedMovie.Title != currentMovie.Title {
		t.Errorf("returned wrong title: got %v want %v", currentMovie.Title, expectedMovie.Title)
	}

	if expectedMovie.ReleaseDate != currentMovie.ReleaseDate {
		t.Errorf("returned wrong release date: got %v want %v", currentMovie.ReleaseDate, expectedMovie.ReleaseDate)
	}

	if expectedMovie.Description != currentMovie.Description {
		t.Errorf("returned wrong description: got %v want %v", currentMovie.Description, expectedMovie.Description)
	}
}

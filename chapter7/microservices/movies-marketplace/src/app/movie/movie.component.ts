import { Component, OnInit } from '@angular/core';
import { ApiService } from '../api.service';
import { ActivatedRoute } from '@angular/router';

declare var $: any;

@Component({
  selector: 'app-movie',
  templateUrl: './movie.component.html',
  styleUrls: ['./movie.component.css']
})
export class MovieComponent implements OnInit {

  public movie: any = {};

  constructor(private apiService: ApiService, private activatedRoute: ActivatedRoute) {
    this.apiService.getMovie(this.activatedRoute.snapshot.params.id).subscribe(data => {
       data.actors.shift();
      this.movie = data;
    }, err => {
      this.movie = {};
    })
  }

  public addToFav(){
    this.apiService.addToFavorites(this.movie).subscribe(data => {
      $.notify({
        icon: 'la la-bell',
        title: 'Movie',
        message: 'has been added to watchlist !',
      }, {
          type: 'success',
          placement: {
            from: "bottom",
            align: "right"
          },
          time: 800000,
        });
    }, err => {
      $.notify({
        icon: 'la la-bell',
        title: 'Something',
        message: 'went wrong !',
      }, {
          type: 'danger',
          placement: {
            from: "bottom",
            align: "right"
          },
          time: 800000,
        });
    });
  }

  ngOnInit() {
  }

}

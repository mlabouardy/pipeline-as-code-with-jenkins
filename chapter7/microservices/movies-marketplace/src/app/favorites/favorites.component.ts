import { Component, OnInit } from '@angular/core';
import { ApiService } from '../api.service';

@Component({
  selector: 'app-favorites',
  templateUrl: './favorites.component.html',
  styleUrls: ['./favorites.component.css']
})
export class FavoritesComponent implements OnInit {
  private movies: Array<any> = new Array<any>();

  constructor(private apiService: ApiService) {
    this.getMovies();
  }

  private getMovies(){
    this.apiService.getFavorites().subscribe(data => {
      this.movies = data;
    }, err => {
      this.movies = [];
    });
  }

  ngOnInit() {
  }

}

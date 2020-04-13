import { Component, OnInit } from '@angular/core';
import { ApiService } from '../api.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {
  private movies: Array<any> = new Array<any>();
  public keyword: string;

  constructor(private apiService: ApiService) {
    this.getMovies();
  }

  private getMovies(){
    this.apiService.getMovies().subscribe(data => {
      this.movies = data;
    }, err => {
      this.movies = [];
    });
  }

  ngOnInit() {
  }

  public searchMovie(){
    this.apiService.getMovie(this.keyword).subscribe(data => {
      this.movies = [];
      if(Array.isArray(data))
        this.movies = data;
      else
        this.movies.push(data);
    }, err => {
      this.movies = [];
    })
  }

}
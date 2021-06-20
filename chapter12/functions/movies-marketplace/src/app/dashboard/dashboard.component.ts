/* tslint:disable */
import { Component, OnInit } from '@angular/core';
import { ApiService } from '../api.service';
import { environment } from '../../environments/environment';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {
  public movies: Array<any> = new Array<any>();
  public keyword: string;
  public runtime = environment.name;

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
      if(Array.isArray(data)){
        this.movies = data;
      } else {
        this.movies.push(data);
      }
    }, err => {
      this.movies = [];
    })
  }

}
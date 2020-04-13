import { Injectable } from '@angular/core';
import { Http, Headers } from '@angular/http';
import { map } from 'rxjs/operators';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  private BASE_URL = environment.apiURL;

  constructor(private http: Http) { }

  public addToFavorites(movie) {
    return this.http
      .post(`${this.BASE_URL}/favorites`, movie)
      .pipe(map(res => {
        return res.json()
      }))
  }

  public getFavorites() {
    return this.http
      .get(`${this.BASE_URL}/favorites`)
      .pipe(map(res => {
        return res.json()
      }))
  }

  public getMovies() {
    return this.http
      .get(`${this.BASE_URL}/movies`)
      .pipe(map(res => {
        return res.json()
      }))
  }

  public getMovie(id) {
    return this.http
      .get(`${this.BASE_URL}/movies/${id}`)
      .pipe(map(res => {
        return res.json()
      }))
  }
}
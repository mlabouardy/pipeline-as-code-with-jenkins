import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpModule } from '@angular/http';
import { FormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { FavoritesComponent } from './favorites/favorites.component';
import { MovieComponent } from './movie/movie.component';

import { ApiService } from './api.service';

@NgModule({
  declarations: [
    AppComponent,
    DashboardComponent,
    FavoritesComponent,
    MovieComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpModule,
    FormsModule
  ],
  providers: [
    ApiService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }

import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardComponent } from './dashboard/dashboard.component';
import { FavoritesComponent } from './favorites/favorites.component';
import { MovieComponent } from './movie/movie.component';

const routes: Routes = [
  { 
    path: 'dashboard',
    component: DashboardComponent,
    data: { title: 'Sign In - Komiser' }
  },
  { 
    path: 'favorites',
    component: FavoritesComponent,
    data: { title: 'Join - Komiser' }
  },
  { 
    path: 'movies/:id',
    component: MovieComponent,
    data: { title: 'Expired token - Komiser' }
  },
  { path: '**',
    redirectTo: 'dashboard'
  }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [RouterModule]
})
export class AppRoutingModule { }

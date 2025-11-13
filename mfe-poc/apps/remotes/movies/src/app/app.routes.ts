import { Route } from '@angular/router';
import { MovieListComponent } from './features/movie-list.component';

export const appRoutes: Route[] = [
  {
    path: '',
    component: MovieListComponent,
  },
];

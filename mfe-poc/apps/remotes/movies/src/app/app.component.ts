import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';

interface Movie {
  title: string;
  year: number;
  genre: string;
  rating: number;
  description: string;
}

@Component({
  imports: [RouterModule, MatCardModule, MatButtonModule, MatChipsModule],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  title = 'Movies Remote';
  movies: Movie[] = [
    {
      title: 'The Shawshank Redemption',
      year: 1994,
      genre: 'Drama',
      rating: 9.3,
      description: 'Two imprisoned men bond over years, finding solace and redemption.'
    },
    {
      title: 'The Godfather',
      year: 1972,
      genre: 'Crime',
      rating: 9.2,
      description: 'The aging patriarch of an organized crime dynasty transfers control.'
    },
    {
      title: 'The Dark Knight',
      year: 2008,
      genre: 'Action',
      rating: 9.0,
      description: 'Batman must accept one of the greatest psychological tests.'
    },
    {
      title: 'Inception',
      year: 2010,
      genre: 'Sci-Fi',
      rating: 8.8,
      description: 'A thief who steals corporate secrets through dream-sharing technology.'
    },
    {
      title: 'Pulp Fiction',
      year: 1994,
      genre: 'Crime',
      rating: 8.9,
      description: 'The lives of two mob hitmen, a boxer, and a pair of diner bandits intertwine.'
    },
    {
      title: 'The Matrix',
      year: 1999,
      genre: 'Sci-Fi',
      rating: 8.7,
      description: 'A computer hacker learns about the true nature of his reality.'
    }
  ];
}

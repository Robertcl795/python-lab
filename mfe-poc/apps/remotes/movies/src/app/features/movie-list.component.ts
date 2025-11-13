import { Component, signal } from '@angular/core';
import { ButtonComponent, CardComponent, HeaderComponent } from '@mfe-poc/ui';
import { CommonModule } from '@angular/common';

interface Movie {
  id: number;
  title: string;
  year: number;
  genre: string;
  rating: number;
}

@Component({
  selector: 'app-movie-list',
  imports: [CommonModule, ButtonComponent, CardComponent, HeaderComponent],
  templateUrl: './movie-list.component.html',
  styleUrl: './movie-list.component.scss',
})
export class MovieListComponent {
  movies = signal<Movie[]>([
    { id: 1, title: 'The Matrix', year: 1999, genre: 'Sci-Fi', rating: 8.7 },
    { id: 2, title: 'Inception', year: 2010, genre: 'Sci-Fi', rating: 8.8 },
    { id: 3, title: 'The Godfather', year: 1972, genre: 'Crime', rating: 9.2 },
    { id: 4, title: 'Pulp Fiction', year: 1994, genre: 'Crime', rating: 8.9 },
  ]);

  addMovie() {
    const newId = this.movies().length + 1;
    this.movies.update(movies => [
      ...movies,
      {
        id: newId,
        title: `Movie ${newId}`,
        year: 2024,
        genre: 'Action',
        rating: 7.5,
      },
    ]);
  }

  removeMovie(id: number) {
    this.movies.update(movies => movies.filter(m => m.id !== id));
  }
}

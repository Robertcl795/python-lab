import { Route } from '@angular/router';
import { loadRemoteModule } from '@angular-architects/native-federation';
import { Component } from '@angular/core';

@Component({
  selector: 'app-home',
  standalone: true,
  template: `
    <div style="padding: 40px; text-align: center;">
      <h1>Welcome to Micro Frontend Shell</h1>
      <p style="font-size: 18px; color: #666; margin-top: 20px;">
        Select a micro-frontend from the sidebar to get started.
      </p>
      <div style="margin-top: 40px; display: flex; gap: 20px; justify-content: center;">
        <a routerLink="/editor" style="padding: 12px 24px; background: #3f51b5; color: white; text-decoration: none; border-radius: 4px;">
          Go to Editor
        </a>
        <a routerLink="/movies" style="padding: 12px 24px; background: #3f51b5; color: white; text-decoration: none; border-radius: 4px;">
          Go to Movies
        </a>
      </div>
    </div>
  `,
})
class HomeComponent {}

export const appRoutes: Route[] = [
  {
    path: '',
    component: HomeComponent,
  },
  {
    path: 'editor',
    loadChildren: () =>
      loadRemoteModule('editor', './Routes').then((m) => m.appRoutes),
  },
  {
    path: 'movies',
    loadChildren: () =>
      loadRemoteModule('movies', './Routes').then((m) => m.appRoutes),
  },
];

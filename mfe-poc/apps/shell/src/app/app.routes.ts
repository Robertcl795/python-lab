import { Route } from '@angular/router';
import { loadRemoteModule } from '@angular-architects/native-federation';

export const appRoutes: Route[] = [
  {
    path: '',
    redirectTo: 'clients',
    pathMatch: 'full',
  },
  {
    path: 'editor',
    loadChildren: () =>
      loadRemoteModule('editor', './Routes').then((m) => m.appRoutes),
  },
  {
    path: 'clients',
    loadChildren: () =>
      loadRemoteModule('clients', './Routes').then((m) => m.appRoutes),
  },
  {
    path: 'movies',
    loadChildren: () =>
      loadRemoteModule('movies', './Routes').then((m) => m.appRoutes),
  },
];

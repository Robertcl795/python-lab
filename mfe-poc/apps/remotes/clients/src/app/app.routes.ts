import { Route } from '@angular/router';
import { ClientListComponent } from './features/client-list.component';

export const appRoutes: Route[] = [
  {
    path: '',
    component: ClientListComponent,
  },
];

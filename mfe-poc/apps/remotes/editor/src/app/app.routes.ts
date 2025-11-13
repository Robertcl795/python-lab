import { Route } from '@angular/router';
import { CodeEditorComponent } from './features/code-editor.component';

export const appRoutes: Route[] = [
  {
    path: '',
    component: CodeEditorComponent,
  },
];

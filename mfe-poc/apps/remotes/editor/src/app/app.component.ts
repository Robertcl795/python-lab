import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';

@Component({
  imports: [RouterModule, FormsModule, MatCardModule],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  title = 'Editor Remote';
  editorContent = '// Start typing your code here...\n\nfunction hello() {\n  console.log("Hello from Editor Remote!");\n}';
}

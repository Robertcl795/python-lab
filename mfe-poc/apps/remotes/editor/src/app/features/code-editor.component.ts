import { Component, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MonacoEditorModule } from 'ngx-monaco-editor-v2';
import { ButtonComponent, HeaderComponent } from '@mfe-poc/ui';

@Component({
  selector: 'app-code-editor',
  imports: [FormsModule, MonacoEditorModule, ButtonComponent, HeaderComponent],
  templateUrl: './code-editor.component.html',
  styleUrl: './code-editor.component.scss',
})
export class CodeEditorComponent {
  editorOptions = {
    theme: 'vs-dark',
    language: 'typescript',
    automaticLayout: true,
    minimap: { enabled: true },
  };

  code = signal(`import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-example',
  standalone: true,
  template: \`
    <div>
      <h1>{{ title() }}</h1>
      <button (click)="increment()">Count: {{ count() }}</button>
    </div>
  \`,
})
export class ExampleComponent {
  title = signal('Angular 19 with Signals');
  count = signal(0);

  increment() {
    this.count.update(c => c + 1);
  }
}`);

  selectedLanguage = signal('typescript');
  languages = ['typescript', 'javascript', 'json', 'html', 'css', 'scss'];

  changeLanguage(language: string) {
    this.selectedLanguage.set(language);
    this.editorOptions = { ...this.editorOptions, language };
  }

  formatCode() {
    console.log('Format code triggered');
  }

  runCode() {
    console.log('Run code triggered');
    alert('Code execution simulated!');
  }
}

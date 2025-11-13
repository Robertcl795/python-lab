import { Component, input, output } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'lib-button',
  imports: [MatButtonModule, MatIconModule],
  templateUrl: './button.component.html',
  styleUrl: './button.component.scss',
})
export class ButtonComponent {
  label = input<string>('Button');
  color = input<'primary' | 'accent' | 'warn'>('primary');
  disabled = input<boolean>(false);
  icon = input<string | undefined>();

  clicked = output<void>();

  handleClick() {
    if (!this.disabled()) {
      this.clicked.emit();
    }
  }
}

import { Component, signal } from '@angular/core';
import { ButtonComponent, CardComponent, HeaderComponent } from '@mfe-poc/ui';
import { CommonModule } from '@angular/common';

interface Client {
  id: number;
  name: string;
  email: string;
  company: string;
}

@Component({
  selector: 'app-client-list',
  imports: [CommonModule, ButtonComponent, CardComponent, HeaderComponent],
  templateUrl: './client-list.component.html',
  styleUrl: './client-list.component.scss',
})
export class ClientListComponent {
  clients = signal<Client[]>([
    { id: 1, name: 'John Doe', email: 'john@example.com', company: 'Acme Corp' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com', company: 'Tech Inc' },
    { id: 3, name: 'Bob Johnson', email: 'bob@example.com', company: 'Dev LLC' },
    { id: 4, name: 'Alice Williams', email: 'alice@example.com', company: 'Code Co' },
  ]);

  addClient() {
    const newId = this.clients().length + 1;
    this.clients.update(clients => [
      ...clients,
      {
        id: newId,
        name: `Client ${newId}`,
        email: `client${newId}@example.com`,
        company: `Company ${newId}`,
      },
    ]);
  }

  removeClient(id: number) {
    this.clients.update(clients => clients.filter(c => c.id !== id));
  }
}

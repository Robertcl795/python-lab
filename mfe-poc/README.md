# Angular 19 Micro-Frontend POC with Native Federation

A production-ready micro-frontend architecture using **NX**, **PNPM**, **Angular 19**, and **Native Federation**.

## 🏗️ Architecture Overview

```
mfe-poc/
├── apps/
│   ├── shell/              # Host application (Port 4200)
│   └── remotes/
│       ├── editor/         # Monaco Code Editor MFE (Port 4201)
│       ├── clients/        # Client Management MFE (Port 4202)
│       └── movies/         # Movie Catalog MFE (Port 4203)
└── libs/
    └── ui/                 # Shared UI component library
```

## ✨ Features

- ✅ **Angular 19 LTS** with signals and standalone components only
- ✅ **Native Federation** for micro-frontend architecture (zero webpack config)
- ✅ **NX Monorepo** with PNPM for efficient dependency management
- ✅ **Shared UI Library** with Angular Material components
- ✅ **Monaco Code Editor** in editor remote
- ✅ **Type-safe routing** and federation contracts
- ✅ **Signal-based state management**
- ✅ **Docker ready** with production configurations
- ✅ **Hot reload** for all applications

## 📋 Prerequisites

- **Node.js** >= 20.x
- **PNPM** >= 10.x
- **Docker** (optional, for containerized deployment)

## 🚀 Quick Start

### 1. Install Dependencies

\`\`\`bash
pnpm install
\`\`\`

### 2. Start Development

\`\`\`bash
# Start all remotes and shell together
pnpm dev
\`\`\`

Or start individually:

\`\`\`bash
# Start remotes first (in parallel)
pnpm dev:remotes

# Then start shell in a new terminal
pnpm dev:shell
\`\`\`

### 3. Access Applications

- **Shell (Host)**: http://localhost:4200
- **Editor Remote**: http://localhost:4201
- **Clients Remote**: http://localhost:4202
- **Movies Remote**: http://localhost:4203

## 📦 Project Structure

### Shell Application

The shell acts as the host application that dynamically loads the remote micro-frontends.

**Key Files:**
- \`apps/shell/src/app/app.routes.ts\` - Federated routing configuration
- \`apps/shell/federation.config.js\` - Host federation configuration
- \`apps/shell/public/federation.manifest.json\` - Remote entry points

### Remote Applications

Each remote application can be developed, tested, and deployed independently.

#### Editor Remote
- **Features**: Monaco code editor with syntax highlighting
- **Tech**: Monaco Editor, TypeScript/JavaScript support
- **Location**: \`apps/remotes/editor/\`

#### Clients Remote
- **Features**: Client management with CRUD operations
- **Tech**: Signal-based state, Material cards
- **Location**: \`apps/remotes/clients/\`

#### Movies Remote
- **Features**: Movie catalog with ratings
- **Tech**: Signal-based state, Material cards
- **Location**: \`apps/remotes/movies/\`

### Shared UI Library

A buildable library containing reusable UI components using Angular Material.

**Components:**
- \`ButtonComponent\` - Customizable Material button
- \`CardComponent\` - Material card with content projection
- \`HeaderComponent\` - Material toolbar header

**Location**: \`libs/ui/\`

## 🛠️ Development Commands

\`\`\`bash
# Development
pnpm dev                    # Start all applications
pnpm dev:shell              # Start only shell
pnpm dev:editor             # Start only editor remote
pnpm dev:clients            # Start only clients remote
pnpm dev:movies             # Start only movies remote
pnpm dev:remotes            # Start all remotes in parallel

# Building
pnpm build                  # Build all applications
pnpm build:shell            # Build only shell
pnpm build:editor           # Build only editor
pnpm build:clients          # Build only clients
pnpm build:movies           # Build only movies

# Testing
pnpm test                   # Run all tests
pnpm e2e                    # Run E2E tests
pnpm lint                   # Lint all projects
\`\`\`

## 🐳 Docker Deployment

### Build and Run with Docker Compose

\`\`\`bash
# Build all images and start containers
docker-compose up --build

# Run in detached mode
docker-compose up -d

# Stop all containers
docker-compose down
\`\`\`

### Individual Container Build

\`\`\`bash
# Build shell
docker build -f apps/shell/Dockerfile -t mfe-shell .

# Build editor
docker build -f apps/remotes/editor/Dockerfile -t mfe-editor .

# Build clients
docker build -f apps/remotes/clients/Dockerfile -t mfe-clients .

# Build movies
docker build -f apps/remotes/movies/Dockerfile -t mfe-movies .
\`\`\`

## 🎯 Native Federation Configuration

### Host Configuration (Shell)

\`\`\`javascript
// apps/shell/federation.config.js
const { withNativeFederation, shareAll } = require('@angular-architects/native-federation/config');

module.exports = withNativeFederation({
  shared: {
    ...shareAll({ singleton: true, strictVersion: true, requiredVersion: 'auto' }),
  },
  skip: [
    'rxjs/ajax',
    'rxjs/fetch',
    'rxjs/testing',
    'rxjs/webSocket',
  ],
});
\`\`\`

### Remote Configuration

\`\`\`javascript
// apps/remotes/*/federation.config.js
module.exports = withNativeFederation({
  name: 'editor',
  exposes: {
    './Routes': './apps/remotes/editor/src/app/app.routes.ts',
  },
  shared: {
    ...shareAll({ singleton: true, strictVersion: true, requiredVersion: 'auto' }),
  },
});
\`\`\`

### Manifest Configuration

\`\`\`json
// apps/shell/public/federation.manifest.json
{
  "clients": "http://localhost:4202/remoteEntry.json",
  "editor": "http://localhost:4201/remoteEntry.json",
  "movies": "http://localhost:4203/remoteEntry.json"
}
\`\`\`

## 🔧 Federated Routing

The shell dynamically loads remote routes using Native Federation:

\`\`\`typescript
// apps/shell/src/app/app.routes.ts
import { loadRemoteModule } from '@angular-architects/native-federation';

export const appRoutes: Route[] = [
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
\`\`\`

## 📚 Key Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| Angular | 19.x | Frontend framework |
| NX | 22.x | Monorepo management |
| PNPM | 10.x | Package manager |
| Native Federation | 20.x | Micro-frontend architecture |
| Angular Material | 19.x | UI components |
| Monaco Editor | 0.54.x | Code editor |
| TypeScript | 5.8.x | Type safety |
| esbuild | - | Build tool (via Angular) |

## 🎨 Styling

The project uses Angular Material with a custom theme defined in each application's styles.scss:

\`\`\`scss
@use '@angular/material' as mat;

$mfe-theme: mat.define-theme((
  color: (
    theme-type: light,
    primary: mat.$blue-palette,
    tertiary: mat.$pink-palette,
  ),
));

html {
  @include mat.all-component-themes($mfe-theme);
}
\`\`\`

## 🔍 Troubleshooting

### Issue: Remote modules not loading

**Solution**: Ensure all remote applications are running before starting the shell:
\`\`\`bash
pnpm dev:remotes  # Start remotes first
pnpm dev:shell    # Then start shell
\`\`\`

### Issue: Duplicate Angular instances

**Solution**: Verify that all remotes and shell share Angular as a singleton in their federation configs.

### Issue: Monaco editor not rendering

**Solution**: Ensure the Monaco editor provider is configured in the editor app's \`app.config.ts\`:
\`\`\`typescript
import { provideMonacoEditor } from 'ngx-monaco-editor-v2';

export const appConfig: ApplicationConfig = {
  providers: [
    // ... other providers
    provideMonacoEditor(),
  ],
};
\`\`\`

## 🚢 Production Deployment

### K3D/Kubernetes Deployment

1. **Build Docker images**:
\`\`\`bash
docker-compose build
\`\`\`

2. **Tag images for your registry**:
\`\`\`bash
docker tag mfe-shell:latest your-registry/mfe-shell:latest
docker tag mfe-editor:latest your-registry/mfe-editor:latest
docker tag mfe-clients:latest your-registry/mfe-clients:latest
docker tag mfe-movies:latest your-registry/mfe-movies:latest
\`\`\`

3. **Push to registry**:
\`\`\`bash
docker push your-registry/mfe-shell:latest
docker push your-registry/mfe-editor:latest
docker push your-registry/mfe-clients:latest
docker push your-registry/mfe-movies:latest
\`\`\`

4. **Deploy to K3D**:
\`\`\`bash
kubectl apply -f k8s/
\`\`\`

## 📖 Additional Resources

- [Angular Documentation](https://angular.dev)
- [NX Documentation](https://nx.dev)
- [Native Federation Guide](https://www.angulararchitects.io/en/blog/announcing-native-federation-1-0/)
- [Angular Material](https://material.angular.io)
- [Monaco Editor](https://microsoft.github.io/monaco-editor/)

## 📝 License

MIT

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

**Built with ❤️ using Angular 19, NX, and Native Federation**

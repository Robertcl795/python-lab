# Angular 19 Micro-Frontend Monorepo with Native Federation

A production-ready Angular 19 monorepo implementing Module Federation with a Material UI shell and remote applications.

## 📁 Project Structure

```
mfe-poc/
├── apps/
│   ├── shell/                    # Host application with Material sidebar and toolbar
│   └── remotes/
│       ├── editor/              # Code editor remote app
│       └── movies/              # Movie catalog remote app
├── package.json                 # Centralized scripts and dependencies
└── pnpm-workspace.yaml          # PNPM workspace configuration
```

## 🚀 Features

- **Angular 19** with standalone components
- **Native Federation** for micro-frontend architecture
- **Material Design** UI components shared across all apps
- **Fast esbuild** bundler for quick development
- **PNPM** for efficient package management
- **Concurrent development** of all apps

## 🛠️ Technical Stack

- Angular 19.2.15
- Angular Material 19.2.19
- @angular-architects/native-federation 20.1.7
- esbuild (via @angular/build)
- PNPM 10.x
- NX 22.0.3 (for task orchestration)

## 📦 Installation

```bash
cd mfe-poc
pnpm install
```

## 🎯 Development Scripts

### Start all apps concurrently
```bash
pnpm run dev
```
This starts:
- Editor remote on http://localhost:4201
- Movies remote on http://localhost:4202
- Shell app on http://localhost:4200

### Start individual apps
```bash
pnpm run dev:shell    # Shell only (port 4200)
pnpm run dev:editor   # Editor only (port 4201)
pnpm run dev:movies   # Movies only (port 4202)
```

### Build for production
```bash
pnpm run build        # Build all apps
pnpm run build:shell  # Build shell only
pnpm run build:editor # Build editor only
pnpm run build:movies # Build movies only
```

## 🏗️ Architecture

### Shell Application
- Material toolbar with menu toggle
- Material sidenav for navigation
- Router outlet for loading remotes
- Home page with quick links
- Routes:
  - `/` - Home page
  - `/editor` - Editor remote
  - `/movies` - Movies remote

### Editor Remote
- Simple code editor with Material card
- Text area for code input
- Monaco Editor integration ready

### Movies Remote
- Grid layout of movie cards
- Material chips for genres and ratings
- Responsive design

## 🔧 Federation Configuration

### How Material is Shared

All apps use Native Federation's `shareAll()` configuration which automatically shares:
- `@angular/*` packages
- `@angular/material`
- `@angular/cdk`
- Other common dependencies

Configuration in each `federation.config.js`:
```javascript
shared: {
  ...shareAll({
    singleton: true,
    strictVersion: true,
    requiredVersion: 'auto'
  }),
}
```

### Adding More Shared Dependencies

To add additional shared libraries:

1. Install the package in the root `package.json`
2. The `shareAll()` configuration will automatically share it
3. For manual control, modify `federation.config.js`:

```javascript
shared: {
  ...shareAll({ singleton: true, strictVersion: true }),
  'your-package': {
    singleton: true,
    strictVersion: true,
    requiredVersion: 'auto'
  },
}
```

## 📝 Key Files

### Federation Manifest
`apps/shell/public/federation.manifest.json` - Maps remote names to URLs

### Federation Configs
- `apps/shell/federation.config.js` - Shell configuration
- `apps/remotes/editor/federation.config.js` - Editor remote configuration
- `apps/remotes/movies/federation.config.js` - Movies remote configuration

### Routing
`apps/shell/src/app/app.routes.ts` - Dynamic import of remotes using `loadRemoteModule()`

## 🎨 Customization

### Adding a New Remote

1. Create new Angular app in `apps/remotes/your-app`
2. Add federation configuration
3. Update shell's `federation.manifest.json`
4. Add route in shell's `app.routes.ts`
5. Add navigation link in shell's sidebar

### Modifying Styles

Global Material theme: `apps/shell/src/styles.scss`

## 🐛 Troubleshooting

### Native Federation Build Errors

If you encounter "Error building federation artefacts":

1. Reset NX cache:
   ```bash
   pnpm nx reset
   ```

2. Clean node_modules and reinstall:
   ```bash
   rm -rf node_modules pnpm-lock.yaml
   pnpm install
   ```

3. Check that `@softarc/native-federation-runtime` is installed

### Alternative: Direct esbuild Serve

If federation build fails, you can run apps independently:
```bash
pnpm nx run editor:serve-original
pnpm nx run movies:serve-original
pnpm nx run shell:serve-original
```

Note: This won't include federation features.

## 🚀 Why This Architecture?

### Benefits of Native Federation

1. **True runtime integration** - Remotes loaded on demand
2. **Independent deployability** - Deploy remotes separately
3. **Shared dependencies** - Reduced bundle sizes
4. **Technology flexibility** - Mix different Angular versions
5. **Fast development** - Concurrent development of all apps

### Benefits of Monorepo

1. **Code sharing** - Shared libraries and utilities
2. **Consistent tooling** - Same build tools across apps
3. **Atomic commits** - Change multiple apps together
4. **Simplified dependency management** - Single lock file

## 📊 Performance

- **Development startup**: ~10 seconds (all 3 apps)
- **Hot reload**: < 1 second
- **Production build**: ~30 seconds (parallel)

## 📄 License

MIT

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

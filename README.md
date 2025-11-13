# Debug and Setup Resources

This directory contains resources to help you debug and run the Angular 19 Micro-Frontend POC project.

## Quick Start

### Option 1: Automated Setup (Recommended)
```bash
./quick-start.sh
```

This interactive script will:
- Check all prerequisites (Node.js, PNPM)
- Install dependencies if needed
- Clear caches
- Give you options to start the application

### Option 2: Manual Setup
```bash
cd mfe-poc
pnpm install
pnpm dev
```

### Option 3: Run Diagnostics First
```bash
./diagnose.sh
```

This will check your environment and identify any issues before you start.

---

## Available Resources

### 1. 📘 DEBUG_AND_FIX_GUIDE.md
**Comprehensive troubleshooting and setup guide**
- Project overview and architecture
- Step-by-step setup instructions
- Common issues and solutions
- Command reference
- Performance tips
- Docker deployment guide

**When to use**: Read this when you encounter specific errors or want to understand the project structure.

### 2. 🚀 quick-start.sh
**Interactive automated setup script**
- Checks prerequisites automatically
- Installs dependencies
- Clears caches
- Interactive menu to start apps, run tests, etc.

**When to use**: First time setup or when you want a guided experience.

### 3. 🔍 diagnose.sh
**Environment diagnostic tool**
- Checks system requirements
- Verifies project structure
- Validates dependencies
- Checks port availability
- Identifies running processes
- Offers automatic fixes

**When to use**: When something isn't working and you need to identify the problem.

---

## Project Structure

```
/home/user/python-lab/
├── mfe-poc/                    # Main project directory
│   ├── apps/
│   │   ├── shell/             # Host application (Port 4200)
│   │   └── remotes/
│   │       ├── editor/        # Monaco Editor MFE (Port 4201)
│   │       ├── clients/       # Client Management MFE (Port 4202)
│   │       └── movies/        # Movie Catalog MFE (Port 4203)
│   ├── libs/
│   │   └── ui/               # Shared UI components
│   └── [config files]
│
├── DEBUG_AND_FIX_GUIDE.md    # Comprehensive guide
├── quick-start.sh             # Automated setup script
├── diagnose.sh                # Diagnostic tool
└── README.md                  # This file
```

---

## Essential Commands

### Development
```bash
cd mfe-poc

# Start all applications
pnpm dev

# Start individual apps
pnpm dev:shell      # Shell only (Port 4200)
pnpm dev:editor     # Editor only (Port 4201)
pnpm dev:clients    # Clients only (Port 4202)
pnpm dev:movies     # Movies only (Port 4203)

# Start all remotes
pnpm dev:remotes
```

### Testing & Quality
```bash
# Run all tests
pnpm test

# Lint code
pnpm lint

# E2E tests
pnpm e2e
```

### Building
```bash
# Build all projects
pnpm build

# Build individual projects
pnpm build:shell
pnpm build:editor
pnpm build:clients
pnpm build:movies
```

### NX Utilities
```bash
# Clear cache
pnpm nx reset

# View project graph
pnpm nx graph

# List all projects
pnpm nx show projects

# Show affected projects
pnpm nx affected:graph
```

---

## Access Points

Once running, the applications are available at:

| Application | URL | Port |
|------------|-----|------|
| Shell (Host) | http://localhost:4200 | 4200 |
| Editor Remote | http://localhost:4201 | 4201 |
| Clients Remote | http://localhost:4202 | 4202 |
| Movies Remote | http://localhost:4203 | 4203 |

---

## Common Issues & Quick Fixes

### Dependencies Not Installed
```bash
cd mfe-poc
pnpm install
```

### Port Already in Use
```bash
# Find and kill process on port 4200
lsof -ti:4200 | xargs kill -9

# Or use a different port
pnpm nx serve shell --port=4300
```

### Build Errors
```bash
# Clear all caches
pnpm nx reset
rm -rf .angular/cache

# Fresh install
rm -rf node_modules
pnpm install
```

### Remote Module Not Loading
```bash
# Ensure remotes are running first
pnpm dev:remotes

# Then start shell in a new terminal
pnpm dev:shell
```

---

## Prerequisites

- **Node.js**: >= 20.x
- **PNPM**: >= 10.x
- **Disk Space**: ~2GB for dependencies
- **Memory**: 4GB+ recommended

### Check Prerequisites
```bash
node --version    # Should be >= 20.x
pnpm --version    # Should be >= 10.x
```

### Install PNPM if Missing
```bash
npm install -g pnpm
```

---

## Technology Stack

- **Framework**: Angular 19.2.15
- **Monorepo**: NX 22.x
- **Package Manager**: PNPM 10+
- **Micro-Frontend**: Native Federation 20.x
- **Build Tool**: esbuild (Angular native)
- **Styling**: SCSS + Angular Material 19
- **Testing**: Jest + Playwright
- **Language**: TypeScript 5.8

---

## Next Steps

1. **First Time Setup**:
   ```bash
   ./quick-start.sh
   ```

2. **If Issues Occur**:
   ```bash
   ./diagnose.sh
   ```

3. **For Detailed Help**:
   - Read `DEBUG_AND_FIX_GUIDE.md`
   - Check the NX documentation: https://nx.dev
   - Check Angular docs: https://angular.dev

4. **Start Development**:
   ```bash
   cd mfe-poc
   pnpm dev
   ```
   Then open http://localhost:4200

---

## Getting Help

### Run Diagnostics
```bash
./diagnose.sh
```

### Check Logs
- Browser Console: F12 → Console tab
- Terminal: Look for error messages during `pnpm dev`
- NX output: Check `.nx/cache/` directory

### Common Commands for Debugging
```bash
# Check project health
pnpm nx show projects

# Validate configuration
pnpm nx show project shell --web

# Check for TypeScript errors
pnpm nx run shell:typecheck

# Verbose output
pnpm nx serve shell --verbose
```

---

## Docker Deployment

### Build and Run with Docker
```bash
cd mfe-poc
docker-compose up --build
```

### Stop Services
```bash
docker-compose down
```

---

## Success Checklist

Your environment is ready when:

- ✅ `node --version` shows >= 20.x
- ✅ `pnpm --version` shows >= 10.x
- ✅ `cd mfe-poc && pnpm install` completes successfully
- ✅ `pnpm dev` starts all applications
- ✅ http://localhost:4200 loads the shell
- ✅ Navigating to `/editor`, `/clients`, `/movies` works
- ✅ No console errors in browser

---

## Support

- **Project Issues**: Check `DEBUG_AND_FIX_GUIDE.md`
- **NX Documentation**: https://nx.dev
- **Angular Documentation**: https://angular.dev
- **Native Federation**: https://www.npmjs.com/package/@angular-architects/native-federation

---

**Last Updated**: 2025-11-13
**Project**: Angular 19 Micro-Frontend POC
**Version**: 0.0.0

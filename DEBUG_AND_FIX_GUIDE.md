# Debug and Fix Guide - Angular 19 Micro-Frontend POC

## Project Overview
This is an Angular 19 micro-frontend application using:
- **Framework**: Angular 19.2.15 with standalone components
- **Monorepo**: NX 22.x
- **Package Manager**: PNPM 10+
- **Architecture**: Micro-frontend with Native Federation
- **Build Tool**: esbuild (via Angular 19)

## Project Structure
```
mfe-poc/
├── apps/
│   ├── shell/           # Host application (Port 4200)
│   └── remotes/
│       ├── editor/      # Monaco Editor MFE (Port 4201)
│       ├── clients/     # Client Management MFE (Port 4202)
│       └── movies/      # Movie Catalog MFE (Port 4203)
├── libs/
│   └── ui/             # Shared UI library
└── Configuration files
```

---

## Current Status & Issues

### ❌ CRITICAL ISSUE: Dependencies Not Installed
**Problem**: `node_modules` directory is missing
**Impact**: Cannot run any commands or start the application

---

## Step-by-Step Fix Guide

### Step 1: Navigate to Project Directory
```bash
cd /home/user/python-lab/mfe-poc
```

### Step 2: Verify Prerequisites
```bash
# Check Node.js version (should be >= 20.x)
node --version

# Check PNPM version (should be >= 10.x)
pnpm --version

# If PNPM is not installed:
npm install -g pnpm
```

### Step 3: Install Dependencies
```bash
# Install all dependencies (this may take 5-10 minutes)
pnpm install
```

**Expected Output**:
- Should install ~1000+ packages
- Creates `node_modules/` directory
- No major errors (warnings are usually okay)

**Common Installation Issues**:

| Issue | Solution |
|-------|----------|
| `EACCES` permission error | Run with sudo: `sudo pnpm install` or fix npm permissions |
| Network timeout | Increase timeout: `pnpm install --network-timeout 100000` |
| Lock file out of sync | Delete lock file: `rm pnpm-lock.yaml` then `pnpm install` |
| Disk space error | Free up space: `docker system prune -a` |

### Step 4: Verify Installation
```bash
# Check if node_modules exists
ls -la node_modules

# Verify NX is available
pnpm nx --version

# List all available projects
pnpm nx show projects
```

**Expected Projects**:
- shell
- editor
- clients
- movies
- ui (library)
- *-e2e (test projects)

---

## Running the Application

### Option 1: Start All Applications (Recommended)
```bash
# Starts all 3 remotes + shell in correct order
pnpm dev
```

**What This Does**:
1. Starts `editor`, `clients`, `movies` in parallel
2. Waits for remotes to be ready
3. Starts `shell` host application

**Access Points**:
- Shell (Host): http://localhost:4200
- Editor Remote: http://localhost:4201
- Clients Remote: http://localhost:4202
- Movies Remote: http://localhost:4203

### Option 2: Manual Start (For Debugging)
```bash
# Terminal 1: Start all remotes
pnpm dev:remotes

# Wait for message: "Application bundle generation complete"
# You should see 3 apps running on ports 4201, 4202, 4203

# Terminal 2: Start shell
pnpm dev:shell
```

### Option 3: Individual Applications
```bash
# Start one at a time
pnpm dev:shell      # Port 4200
pnpm dev:editor     # Port 4201
pnpm dev:clients    # Port 4202
pnpm dev:movies     # Port 4203
```

**Note**: For full micro-frontend functionality, you need the shell + at least one remote running.

---

## Verification & Testing

### 1. Check Application is Running
```bash
# Shell should respond
curl http://localhost:4200

# Editor remote should respond
curl http://localhost:4201

# Check federation manifest is accessible
curl http://localhost:4200/federation.manifest.json
```

### 2. Test in Browser
1. Open http://localhost:4200
2. You should see the Angular welcome page
3. Navigate to `/editor`, `/clients`, or `/movies`
4. Each route should load the respective remote module

### 3. Run Linting
```bash
pnpm lint
```

### 4. Run Unit Tests
```bash
# All tests
pnpm test

# Specific app
pnpm nx test shell
pnpm nx test editor
```

### 5. Run E2E Tests
```bash
# All E2E tests
pnpm e2e

# Specific app
pnpm nx e2e shell-e2e
pnpm nx e2e editor-e2e
```

---

## Common Development Issues & Solutions

### Issue: Port Already in Use
```
Error: Port 4200 is already in use
```

**Solution**:
```bash
# Find process using port
lsof -i :4200

# Kill the process
kill -9 <PID>

# Or use different port
pnpm nx serve shell --port=4300
```

### Issue: Remote Module Not Loading
```
Error: Could not load remote module 'editor'
```

**Checklist**:
1. ✅ Is the remote application running? Check http://localhost:4201
2. ✅ Is `remoteEntry.json` accessible? Check http://localhost:4201/remoteEntry.json
3. ✅ Is `federation.manifest.json` correct? Check `/apps/shell/public/federation.manifest.json`
4. ✅ Are ports matching in manifest?

**Solution**:
```bash
# Restart remotes first
pnpm dev:remotes

# Wait for "Application bundle generation complete"

# Then restart shell
pnpm dev:shell
```

### Issue: TypeScript Errors
```
Error: Cannot find module '@mfe-poc/ui'
```

**Solution**:
```bash
# Rebuild the UI library
pnpm nx build ui

# Clear NX cache
pnpm nx reset

# Restart dev server
pnpm dev
```

### Issue: Build Errors
```
Error: Module not found or compilation errors
```

**Debugging Steps**:
```bash
# 1. Clear NX cache
pnpm nx reset

# 2. Delete node_modules and reinstall
rm -rf node_modules
pnpm install

# 3. Build with verbose output
pnpm nx build shell --verbose

# 4. Check for TypeScript errors
pnpm nx run shell:typecheck
```

### Issue: Monaco Editor Not Loading
```
Editor remote loads but Monaco editor doesn't appear
```

**Solution**:
```bash
# Verify Monaco dependencies
pnpm list monaco-editor
pnpm list ngx-monaco-editor-v2

# Rebuild editor with cleared cache
pnpm nx reset
pnpm nx build editor
pnpm dev:editor
```

### Issue: Slow Build Times
**Solutions**:
```bash
# Enable NX caching (should be default)
# Check nx.json for "cacheableOperations"

# Use NX Cloud (optional)
pnpm nx connect-to-nx-cloud

# Build only affected projects
pnpm nx affected:build

# Parallel execution (default: 3)
pnpm nx run-many --target=build --all --parallel=3
```

---

## Build for Production

### Local Production Build
```bash
# Build all applications
pnpm build

# Or build individually
pnpm build:shell
pnpm build:editor
pnpm build:clients
pnpm build:movies
```

**Output Location**: `/dist/apps/<app-name>/browser/`

### Docker Build
```bash
# Build and run all services
docker-compose up --build

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

**Docker Ports**:
- Shell: http://localhost:4200
- Editor: http://localhost:4201
- Clients: http://localhost:4202
- Movies: http://localhost:4203

---

## Debugging Tools & Commands

### NX Commands
```bash
# Show project graph
pnpm nx graph

# Show affected projects
pnpm nx affected:graph

# Run specific target
pnpm nx run <project>:<target>

# Example: Run shell with production config
pnpm nx run shell:build:production

# Clear cache
pnpm nx reset

# Show project details
pnpm nx show project shell --web
```

### PNPM Commands
```bash
# List installed packages
pnpm list

# Check for outdated packages
pnpm outdated

# Update dependencies
pnpm update

# Prune unused packages
pnpm prune

# Check workspace structure
pnpm -r list --depth 0
```

### Troubleshooting Checklist
```bash
# 1. Check Node/PNPM versions
node --version    # Should be >= 20.x
pnpm --version    # Should be >= 10.x

# 2. Verify dependencies installed
ls -la node_modules

# 3. Check NX is working
pnpm nx --version

# 4. List all projects
pnpm nx show projects

# 5. Check for TypeScript errors
pnpm nx run shell:typecheck

# 6. Verify build works
pnpm nx build shell --configuration=development

# 7. Clear all caches
pnpm nx reset
rm -rf .angular/cache
rm -rf dist

# 8. Fresh install if needed
rm -rf node_modules
rm pnpm-lock.yaml
pnpm install
```

---

## Performance Optimization

### Development
```bash
# Use watch mode for faster rebuilds
pnpm nx serve shell --watch

# Disable source maps if too slow
# Edit angular.json: "sourceMap": false

# Use NX cache
pnpm nx affected:serve
```

### Production
```bash
# Build with optimization
pnpm nx build shell --configuration=production

# Analyze bundle size
pnpm nx build shell --stats-json
# Then use webpack-bundle-analyzer

# Enable compression in nginx (already in nginx.conf)
```

---

## Quick Reference

### Essential Commands
| Command | Description |
|---------|-------------|
| `pnpm install` | Install dependencies |
| `pnpm dev` | Start all apps |
| `pnpm dev:shell` | Start shell only |
| `pnpm dev:remotes` | Start all remotes |
| `pnpm build` | Build all projects |
| `pnpm test` | Run all tests |
| `pnpm lint` | Lint all projects |
| `pnpm nx reset` | Clear NX cache |
| `pnpm nx graph` | Show project graph |

### Ports
| Application | Port | URL |
|------------|------|-----|
| Shell | 4200 | http://localhost:4200 |
| Editor | 4201 | http://localhost:4201 |
| Clients | 4202 | http://localhost:4202 |
| Movies | 4203 | http://localhost:4203 |

### Key Files
| File | Purpose |
|------|---------|
| `package.json` | Scripts and dependencies |
| `nx.json` | NX configuration |
| `tsconfig.base.json` | TypeScript base config |
| `federation.manifest.json` | Remote entry points |
| `apps/*/federation.config.js` | Federation configs |
| `docker-compose.yml` | Docker orchestration |

---

## Getting Help

### Logs Location
- NX cache: `.nx/cache/`
- Angular cache: `.angular/cache/`
- Build output: `dist/`
- Test results: `coverage/`

### Debug Modes
```bash
# Verbose output
pnpm nx serve shell --verbose

# Show configuration
pnpm nx show project shell --web

# Dry run
pnpm nx build shell --dry-run
```

### Check Application Health
```bash
# Create a simple health check script
cat > check-health.sh << 'EOF'
#!/bin/bash
echo "Checking application health..."
curl -f http://localhost:4200 && echo "✅ Shell OK" || echo "❌ Shell FAIL"
curl -f http://localhost:4201 && echo "✅ Editor OK" || echo "❌ Editor FAIL"
curl -f http://localhost:4202 && echo "✅ Clients OK" || echo "❌ Clients FAIL"
curl -f http://localhost:4203 && echo "✅ Movies OK" || echo "❌ Movies FAIL"
EOF

chmod +x check-health.sh
./check-health.sh
```

---

## Success Criteria

Your development environment is ready when:

✅ `pnpm install` completes without errors
✅ `pnpm nx --version` shows NX version
✅ `pnpm dev` starts all applications
✅ http://localhost:4200 shows the shell application
✅ Navigating to `/editor` loads the editor remote
✅ No console errors in browser developer tools
✅ `pnpm test` runs without failures
✅ `pnpm lint` shows no errors

---

## Next Steps After Setup

1. **Explore the Code**
   - Check `apps/shell/src/app/app.routes.ts` for routing
   - Review `federation.config.js` files for micro-frontend setup
   - Look at `libs/ui` for shared components

2. **Make Changes**
   - Add new routes to remotes
   - Create shared components in `libs/ui`
   - Configure new remotes in `federation.manifest.json`

3. **Test Changes**
   - Run `pnpm test` for unit tests
   - Run `pnpm e2e` for E2E tests
   - Use `pnpm nx affected:test` for affected tests only

4. **Deploy**
   - Build with `pnpm build`
   - Test Docker build with `docker-compose up --build`
   - Deploy to your infrastructure

---

## Additional Resources

- **NX Documentation**: https://nx.dev
- **Angular Documentation**: https://angular.dev
- **Native Federation**: https://www.npmjs.com/package/@angular-architects/native-federation
- **PNPM Documentation**: https://pnpm.io

---

**Last Updated**: 2025-11-13
**Project Version**: 0.0.0
**Angular Version**: 19.2.15
**NX Version**: 22.0.3

#!/bin/bash

# Diagnostic Script for Angular 19 Micro-Frontend POC
# This script checks your environment and diagnoses common issues

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PROJECT_DIR="/home/user/python-lab/mfe-poc"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Micro-Frontend POC - Diagnostic Tool${NC}"
echo -e "${BLUE}========================================${NC}\n"

ERRORS=0
WARNINGS=0

# Function to check and report
check() {
    local status=$1
    local success_msg=$2
    local error_msg=$3

    if [ $status -eq 0 ]; then
        echo -e "${GREEN}✅ $success_msg${NC}"
        return 0
    else
        echo -e "${RED}❌ $error_msg${NC}"
        ((ERRORS++))
        return 1
    fi
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Section 1: System Requirements
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}1. System Requirements${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | cut -d'v' -f2)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1)

    if [ $NODE_MAJOR -ge 20 ]; then
        check 0 "Node.js v$NODE_VERSION (>= 20.x required)" ""
    else
        check 1 "" "Node.js v$NODE_VERSION is too old (>= 20.x required)"
        info "Install from: https://nodejs.org"
    fi
else
    check 1 "" "Node.js is not installed"
    info "Install from: https://nodejs.org"
fi

# Check PNPM
if command -v pnpm &> /dev/null; then
    PNPM_VERSION=$(pnpm --version)
    check 0 "PNPM v$PNPM_VERSION" ""
else
    check 1 "" "PNPM is not installed"
    info "Install: npm install -g pnpm"
fi

# Check disk space
DISK_SPACE=$(df -h "$PROJECT_DIR" 2>/dev/null | awk 'NR==2 {print $4}' || echo "Unknown")
echo -e "${GREEN}✅ Disk space available: $DISK_SPACE${NC}"

# Check memory
if command -v free &> /dev/null; then
    MEMORY=$(free -h | awk 'NR==2 {print $7}')
    echo -e "${GREEN}✅ Available memory: $MEMORY${NC}"
fi

echo ""

# Section 2: Project Structure
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}2. Project Structure${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check project directory
if [ -d "$PROJECT_DIR" ]; then
    check 0 "Project directory exists: $PROJECT_DIR" ""
    cd "$PROJECT_DIR"
else
    check 1 "" "Project directory not found: $PROJECT_DIR"
    exit 1
fi

# Check package.json
[ -f "package.json" ] && check 0 "package.json exists" "" || check 1 "" "package.json not found"

# Check nx.json
[ -f "nx.json" ] && check 0 "nx.json exists" "" || check 1 "" "nx.json not found"

# Check pnpm-workspace.yaml
[ -f "pnpm-workspace.yaml" ] && check 0 "pnpm-workspace.yaml exists" "" || check 1 "" "pnpm-workspace.yaml not found"

# Check key directories
[ -d "apps" ] && check 0 "apps/ directory exists" "" || check 1 "" "apps/ directory not found"
[ -d "libs" ] && check 0 "libs/ directory exists" "" || check 1 "" "libs/ directory not found"

echo ""

# Section 3: Dependencies
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}3. Dependencies${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check node_modules
if [ -d "node_modules" ]; then
    check 0 "node_modules/ directory exists" ""

    # Check size
    NODE_MODULES_SIZE=$(du -sh node_modules 2>/dev/null | cut -f1)
    info "node_modules size: $NODE_MODULES_SIZE"

    # Count packages
    if [ -d "node_modules" ]; then
        PKG_COUNT=$(find node_modules -maxdepth 2 -type d -name "node_modules" -prune -o -type d -maxdepth 1 | wc -l)
        info "Approximate package count: $PKG_COUNT"
    fi
else
    check 1 "" "node_modules/ directory not found"
    info "Run: pnpm install"
fi

# Check lock file
if [ -f "pnpm-lock.yaml" ]; then
    LOCK_SIZE=$(du -sh pnpm-lock.yaml | cut -f1)
    check 0 "pnpm-lock.yaml exists ($LOCK_SIZE)" ""
else
    warn "pnpm-lock.yaml not found"
fi

# Check if NX is available
if [ -d "node_modules" ]; then
    if pnpm nx --version &> /dev/null; then
        NX_VERSION=$(pnpm nx --version 2>/dev/null)
        check 0 "NX CLI available (v$NX_VERSION)" ""
    else
        check 1 "" "NX CLI not available"
        info "Try: pnpm install"
    fi
fi

echo ""

# Section 4: Applications
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}4. Applications${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check shell app
[ -d "apps/shell" ] && check 0 "Shell app exists" "" || check 1 "" "Shell app not found"
[ -f "apps/shell/project.json" ] && check 0 "Shell project.json exists" "" || check 1 "" "Shell project.json not found"

# Check remotes
[ -d "apps/remotes/editor" ] && check 0 "Editor remote exists" "" || check 1 "" "Editor remote not found"
[ -d "apps/remotes/clients" ] && check 0 "Clients remote exists" "" || check 1 "" "Clients remote not found"
[ -d "apps/remotes/movies" ] && check 0 "Movies remote exists" "" || check 1 "" "Movies remote not found"

# Check shared library
[ -d "libs/ui" ] && check 0 "Shared UI library exists" "" || check 1 "" "Shared UI library not found"

echo ""

# Section 5: Configuration Files
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}5. Configuration Files${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check TypeScript configs
[ -f "tsconfig.base.json" ] && check 0 "tsconfig.base.json exists" "" || check 1 "" "tsconfig.base.json not found"

# Check federation configs
[ -f "apps/shell/federation.config.js" ] && check 0 "Shell federation config exists" "" || check 1 "" "Shell federation config not found"
[ -f "apps/shell/public/federation.manifest.json" ] && check 0 "Federation manifest exists" "" || warn "Federation manifest not found"

# Check Docker files
[ -f "docker-compose.yml" ] && check 0 "docker-compose.yml exists" "" || warn "docker-compose.yml not found"
[ -f "apps/shell/Dockerfile" ] && check 0 "Shell Dockerfile exists" "" || warn "Shell Dockerfile not found"

echo ""

# Section 6: Port Availability
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}6. Port Availability${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_port() {
    local port=$1
    local app=$2

    if command -v lsof &> /dev/null; then
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 ; then
            PID=$(lsof -ti:$port)
            warn "Port $port ($app) is in use by PID $PID"
            return 1
        else
            check 0 "Port $port ($app) is available" ""
            return 0
        fi
    else
        info "lsof not available, skipping port check"
        return 0
    fi
}

check_port 4200 "Shell"
check_port 4201 "Editor"
check_port 4202 "Clients"
check_port 4203 "Movies"

echo ""

# Section 7: Build Cache
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}7. Build Cache & Output${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check NX cache
if [ -d ".nx/cache" ]; then
    NX_CACHE_SIZE=$(du -sh .nx/cache 2>/dev/null | cut -f1)
    info "NX cache exists ($NX_CACHE_SIZE)"
else
    info "NX cache not found (will be created on first build)"
fi

# Check Angular cache
if [ -d ".angular/cache" ]; then
    NG_CACHE_SIZE=$(du -sh .angular/cache 2>/dev/null | cut -f1)
    info "Angular cache exists ($NG_CACHE_SIZE)"
else
    info "Angular cache not found (will be created on first build)"
fi

# Check dist directory
if [ -d "dist" ]; then
    DIST_SIZE=$(du -sh dist 2>/dev/null | cut -f1)
    info "Build output exists (dist/ - $DIST_SIZE)"
else
    info "No build output found (dist/ - will be created on build)"
fi

echo ""

# Section 8: Running Processes
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}8. Running Processes${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v pgrep &> /dev/null; then
    NODE_PROCESSES=$(pgrep -f "nx serve" | wc -l)

    if [ $NODE_PROCESSES -gt 0 ]; then
        info "Found $NODE_PROCESSES NX serve process(es) running"
        pgrep -f "nx serve" -a | head -5
    else
        info "No NX serve processes currently running"
    fi
else
    info "pgrep not available, skipping process check"
fi

echo ""

# Section 9: Quick Health Check
if [ -d "node_modules" ] && command -v pnpm &> /dev/null; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}9. NX Workspace Health${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # List projects
    echo -e "${CYAN}Available projects:${NC}"
    pnpm nx show projects 2>/dev/null || warn "Could not list projects"
    echo ""
fi

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Your environment is ready.${NC}"
    echo -e "\n${CYAN}You can start development with:${NC}"
    echo -e "  ${YELLOW}cd $PROJECT_DIR${NC}"
    echo -e "  ${YELLOW}pnpm dev${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found, but environment should work.${NC}"
    echo -e "\n${CYAN}You can start development with:${NC}"
    echo -e "  ${YELLOW}cd $PROJECT_DIR${NC}"
    echo -e "  ${YELLOW}pnpm dev${NC}"
else
    echo -e "${RED}❌ $ERRORS error(s) and $WARNINGS warning(s) found.${NC}"
    echo -e "\n${CYAN}Common fixes:${NC}"
    echo -e "  ${YELLOW}1. Install dependencies: cd $PROJECT_DIR && pnpm install${NC}"
    echo -e "  ${YELLOW}2. Clear cache: pnpm nx reset${NC}"
    echo -e "  ${YELLOW}3. Check DEBUG_AND_FIX_GUIDE.md for detailed help${NC}"
fi

echo ""

# Offer to fix common issues
if [ $ERRORS -gt 0 ]; then
    echo -e "${YELLOW}Would you like to try automatic fixes? (y/n)${NC}"
    read -r response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "\n${CYAN}Attempting automatic fixes...${NC}\n"

        # Fix 1: Install dependencies if missing
        if [ ! -d "node_modules" ]; then
            echo -e "${YELLOW}Installing dependencies...${NC}"
            pnpm install
        fi

        # Fix 2: Clear cache
        if command -v pnpm &> /dev/null && [ -d "node_modules" ]; then
            echo -e "${YELLOW}Clearing NX cache...${NC}"
            pnpm nx reset
        fi

        echo -e "\n${GREEN}Fixes applied. Please run the diagnostic again.${NC}"
    fi
fi

echo -e "\n${BLUE}Diagnostic complete.${NC}"
echo -e "${CYAN}For detailed help, see: DEBUG_AND_FIX_GUIDE.md${NC}\n"

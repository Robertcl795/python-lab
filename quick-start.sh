#!/bin/bash

# Quick Start Script for Angular 19 Micro-Frontend POC
# This script automates the setup and startup process

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="/home/user/python-lab/mfe-poc"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Angular 19 Micro-Frontend POC - Quick Start${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Step 1: Check prerequisites
echo -e "${YELLOW}Step 1: Checking prerequisites...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo -e "Please install Node.js >= 20.x from https://nodejs.org"
    exit 1
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js: $NODE_VERSION${NC}"

if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}⚠️  PNPM is not installed. Installing...${NC}"
    npm install -g pnpm
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install PNPM${NC}"
        echo -e "Please install manually: npm install -g pnpm"
        exit 1
    fi
fi

PNPM_VERSION=$(pnpm --version)
echo -e "${GREEN}✅ PNPM: $PNPM_VERSION${NC}\n"

# Step 2: Navigate to project directory
echo -e "${YELLOW}Step 2: Navigating to project directory...${NC}"

if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Project directory not found: $PROJECT_DIR${NC}"
    exit 1
fi

cd "$PROJECT_DIR"
echo -e "${GREEN}✅ Current directory: $(pwd)${NC}\n"

# Step 3: Check if dependencies are installed
echo -e "${YELLOW}Step 3: Checking dependencies...${NC}"

if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}⚠️  node_modules not found. Installing dependencies...${NC}"
    echo -e "${BLUE}This may take 5-10 minutes. Please wait...${NC}\n"

    pnpm install

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install dependencies${NC}"
        echo -e "Try running manually: cd $PROJECT_DIR && pnpm install"
        exit 1
    fi

    echo -e "\n${GREEN}✅ Dependencies installed successfully${NC}\n"
else
    echo -e "${GREEN}✅ Dependencies already installed${NC}\n"
fi

# Step 4: Verify NX is available
echo -e "${YELLOW}Step 4: Verifying NX installation...${NC}"

if ! pnpm nx --version &> /dev/null; then
    echo -e "${RED}❌ NX is not available${NC}"
    echo -e "Try reinstalling: rm -rf node_modules && pnpm install"
    exit 1
fi

NX_VERSION=$(pnpm nx --version)
echo -e "${GREEN}✅ NX: $NX_VERSION${NC}\n"

# Step 5: List available projects
echo -e "${YELLOW}Step 5: Available projects:${NC}"
pnpm nx show projects
echo ""

# Step 6: Clear any existing cache
echo -e "${YELLOW}Step 6: Clearing NX cache...${NC}"
pnpm nx reset
echo -e "${GREEN}✅ Cache cleared${NC}\n"

# Step 7: Check for port availability
echo -e "${YELLOW}Step 7: Checking port availability...${NC}"

check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo -e "${YELLOW}⚠️  Port $port is already in use${NC}"
        return 1
    else
        echo -e "${GREEN}✅ Port $port is available${NC}"
        return 0
    fi
}

PORTS_OK=true
check_port 4200 || PORTS_OK=false
check_port 4201 || PORTS_OK=false
check_port 4202 || PORTS_OK=false
check_port 4203 || PORTS_OK=false

if [ "$PORTS_OK" = false ]; then
    echo -e "\n${YELLOW}Some ports are in use. Would you like to kill the processes? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        for port in 4200 4201 4202 4203; do
            PID=$(lsof -ti:$port)
            if [ ! -z "$PID" ]; then
                echo -e "${YELLOW}Killing process on port $port (PID: $PID)${NC}"
                kill -9 $PID 2>/dev/null || true
            fi
        done
        echo -e "${GREEN}✅ Ports cleared${NC}"
    else
        echo -e "${YELLOW}⚠️  Please manually free up the ports before starting${NC}"
    fi
fi
echo ""

# Step 8: Ask user what to do
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Setup Complete! What would you like to do?${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "1) Start all applications (shell + remotes)"
echo -e "2) Start only remotes (for testing)"
echo -e "3) Start only shell"
echo -e "4) Run tests"
echo -e "5) Run linting"
echo -e "6) Build all projects"
echo -e "7) Open project graph"
echo -e "8) Exit (I'll start manually)"
echo ""
echo -e "${YELLOW}Enter your choice (1-8):${NC} "

read -r choice

case $choice in
    1)
        echo -e "\n${GREEN}Starting all applications...${NC}"
        echo -e "${BLUE}Shell: http://localhost:4200${NC}"
        echo -e "${BLUE}Editor: http://localhost:4201${NC}"
        echo -e "${BLUE}Clients: http://localhost:4202${NC}"
        echo -e "${BLUE}Movies: http://localhost:4203${NC}\n"
        echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
        pnpm dev
        ;;
    2)
        echo -e "\n${GREEN}Starting remotes only...${NC}"
        echo -e "${BLUE}Editor: http://localhost:4201${NC}"
        echo -e "${BLUE}Clients: http://localhost:4202${NC}"
        echo -e "${BLUE}Movies: http://localhost:4203${NC}\n"
        echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
        pnpm dev:remotes
        ;;
    3)
        echo -e "\n${GREEN}Starting shell only...${NC}"
        echo -e "${BLUE}Shell: http://localhost:4200${NC}\n"
        echo -e "${YELLOW}Note: Remotes must be running for full functionality${NC}"
        echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
        pnpm dev:shell
        ;;
    4)
        echo -e "\n${GREEN}Running all tests...${NC}\n"
        pnpm test
        ;;
    5)
        echo -e "\n${GREEN}Running linting...${NC}\n"
        pnpm lint
        ;;
    6)
        echo -e "\n${GREEN}Building all projects...${NC}\n"
        pnpm build
        ;;
    7)
        echo -e "\n${GREEN}Opening project graph in browser...${NC}\n"
        pnpm nx graph
        ;;
    8)
        echo -e "\n${GREEN}Setup complete!${NC}"
        echo -e "\n${BLUE}Quick commands:${NC}"
        echo -e "  Start all: ${YELLOW}pnpm dev${NC}"
        echo -e "  Start remotes: ${YELLOW}pnpm dev:remotes${NC}"
        echo -e "  Start shell: ${YELLOW}pnpm dev:shell${NC}"
        echo -e "  Run tests: ${YELLOW}pnpm test${NC}"
        echo -e "  Build: ${YELLOW}pnpm build${NC}"
        echo -e "\n${BLUE}See DEBUG_AND_FIX_GUIDE.md for detailed instructions${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}Done!${NC}"

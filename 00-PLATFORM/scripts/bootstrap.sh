#!/usr/bin/env bash
# =============================================================================
# rmsecurity CCOS — Bootstrap Script
# Run this once on a new machine to set up the full operational environment.
# Usage: bash 00-PLATFORM/scripts/bootstrap.sh
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

echo ""
echo -e "${BOLD}rmsecurity — CCOS Bootstrap${NC}"
echo "============================================"
echo ""

# --- Detect OS ---------------------------------------------------------------
OS="$(uname -s)"
case "$OS" in
  Linux*)   PLATFORM=linux ;;
  Darwin*)  PLATFORM=macos ;;
  CYGWIN*|MINGW*|MSYS*) PLATFORM=windows ;;
  *)        error "Unsupported OS: $OS" ;;
esac
info "Platform detected: $PLATFORM"

# --- Check required tools ----------------------------------------------------
info "Checking required tools..."

check_tool() {
  if command -v "$1" &>/dev/null; then
    success "$1 found ($(command -v "$1"))"
  else
    warn "$1 not found — install it before proceeding: $2"
    MISSING_TOOLS=true
  fi
}

MISSING_TOOLS=false
check_tool git       "https://git-scm.com"
check_tool python3   "https://python.org"
check_tool pip3      "comes with Python"
check_tool docker    "https://docs.docker.com/get-docker/"
check_tool docker-compose "https://docs.docker.com/compose/"

if [ "$MISSING_TOOLS" = true ]; then
  warn "Some tools are missing. Install them and re-run this script."
fi

# --- Python environment ------------------------------------------------------
info "Setting up Python environment..."

if [ ! -d ".venv" ]; then
  python3 -m venv .venv
  success "Virtual environment created at .venv"
else
  success "Virtual environment already exists"
fi

source .venv/bin/activate

pip install --quiet --upgrade pip
pip install --quiet pre-commit ruff gitleaks 2>/dev/null || true

success "Python dependencies installed"

# --- Pre-commit hooks --------------------------------------------------------
info "Installing pre-commit hooks..."

if pre-commit install; then
  success "Pre-commit hooks installed"
else
  warn "pre-commit install failed — run manually after fixing above issues"
fi

# --- Environment file --------------------------------------------------------
info "Setting up environment configuration..."

if [ ! -f "00-PLATFORM/config/.env" ]; then
  cp 00-PLATFORM/config/.env.example 00-PLATFORM/config/.env
  success ".env created from template — edit it with your actual values"
  warn "IMPORTANT: Fill in 00-PLATFORM/config/.env before running any automation"
else
  success ".env already exists"
fi

# --- Engagement store --------------------------------------------------------
info "Checking engagement store..."

ENGAGEMENT_STORE="${HOME}/rmsecurity-engagements"
if [ ! -d "$ENGAGEMENT_STORE" ]; then
  warn "Engagement store not found at $ENGAGEMENT_STORE"
  warn "Create an encrypted VeraCrypt volume and mount it there."
  warn "See: 00-PLATFORM/docs/client-data-architecture.md"
else
  success "Engagement store found at $ENGAGEMENT_STORE"
fi

# --- Git configuration -------------------------------------------------------
info "Verifying git configuration..."

GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")

if [ -z "$GIT_EMAIL" ] || [ -z "$GIT_NAME" ]; then
  warn "Git identity not fully configured. Run:"
  warn "  git config --global user.name 'Your Name'"
  warn "  git config --global user.email 'your@email.com'"
else
  success "Git identity: $GIT_NAME <$GIT_EMAIL>"
fi

# --- Summary -----------------------------------------------------------------
echo ""
echo -e "${BOLD}Bootstrap complete.${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit 00-PLATFORM/config/.env with your API keys and configuration"
echo "  2. Set up your encrypted engagement store (see client-data-architecture.md)"
echo "  3. Pull the Docker images: docker compose -f 00-PLATFORM/docker/compose/docker-compose.yml pull"
echo "  4. Read 00-PLATFORM/docs/onboarding.md"
echo ""

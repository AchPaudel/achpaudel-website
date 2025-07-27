#!/bin/bash

# Git Setup Script for Achyut Dev Site
# This script configures Git for the project

set -e

echo "🚀 Setting up Git configuration for Achyut Dev Site..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the project root
if [ ! -f "README.md" ] || [ ! -f ".gitmessage" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Set up commit message template
print_status "Setting up commit message template..."
if [ -f ".gitmessage" ]; then
    git config commit.template .gitmessage
    print_success "Commit message template configured"
else
    print_error "Commit message template not found"
    exit 1
fi

# Set up Git hooks
print_status "Setting up Git hooks..."
if [ -f ".git/hooks/pre-commit" ]; then
    chmod +x .git/hooks/pre-commit
    print_success "Pre-commit hook configured"
else
    print_warning "Pre-commit hook not found"
fi

if [ -f ".git/hooks/commit-msg" ]; then
    chmod +x .git/hooks/commit-msg
    print_success "Commit-msg hook configured"
else
    print_warning "Commit-msg hook not found"
fi

# Configure line ending handling
print_status "Configuring line ending handling..."
git config core.autocrlf input
git config core.eol lf
print_success "Line ending configuration set"

# Set up aliases
print_status "Setting up useful Git aliases..."
git config alias.st status
git config alias.co checkout
git config alias.br branch
git config alias.ci commit
git config alias.ca "commit -a"
git config alias.cm "commit -m"
git config alias.unstage "reset HEAD --"
git config alias.last "log -1 HEAD"
git config alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
print_success "Git aliases configured"

# Configure color output
print_status "Configuring colored output..."
git config color.ui auto
git config color.branch auto
git config color.diff auto
git config color.status auto
print_success "Color configuration set"

# Set up push behavior
print_status "Configuring push behavior..."
git config push.default simple
git config push.autoSetupRemote true
print_success "Push behavior configured"

# Check if user identity is set
print_status "Checking Git user configuration..."
if [ -z "$(git config user.name)" ] || [ -z "$(git config user.email)" ]; then
    print_warning "Git user identity not configured"
    echo "Please configure your Git identity:"
    echo "  git config user.name \"Your Name\""
    echo "  git config user.email \"your.email@example.com\""
else
    print_success "Git user identity is configured"
    echo "  Name: $(git config user.name)"
    echo "  Email: $(git config user.email)"
fi

# Display current branch
print_status "Current branch: $(git branch --show-current)"

# Check if remote is configured
if git remote get-url origin > /dev/null 2>&1; then
    print_success "Remote origin is configured"
    echo "  URL: $(git remote get-url origin)"
else
    print_warning "Remote origin not configured"
    echo "Please add your remote repository:"
    echo "  git remote add origin <repository-url>"
fi

# Display helpful information
echo ""
print_success "Git configuration complete!"
echo ""
echo "📝 Useful commands:"
echo "  git st                    # Check status"
echo "  git co <branch>           # Checkout branch"
echo "  git br                    # List branches"
echo "  git ci                    # Commit"
echo "  git lg                    # Show commit history with graph"
echo ""
echo "📋 Commit message format:"
echo "  <type>(<scope>): <subject>"
echo "  Example: feat(backend): add project CRUD operations"
echo ""
echo "🔄 Branch naming:"
echo "  feature/description       # New features"
echo "  bugfix/description        # Bug fixes"
echo "  hotfix/description        # Critical fixes"
echo ""
echo "📚 For more information, see GIT_WORKFLOW.md"
echo ""
print_success "Happy coding! 🚀" 
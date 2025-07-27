# Git Workflow Guide

This document outlines the Git workflow and best practices for the Achyut Dev Site project.

## 🚀 Quick Start

### 1. Initial Setup

```bash
# Clone the repository
git clone https://github.com/achpaudel/achpaudel-website.git
cd achpaudel-website

# Set up the commit message template
git config commit.template .gitmessage

# Install Git hooks (if not already installed)
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg
```

### 2. Configure Your Identity

```bash
# Set your name and email (if not already configured globally)
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

## 📝 Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Revert previous commit

### Scopes
- `backend`: Spring Boot backend changes
- `frontend`: Angular frontend changes
- `docker`: Docker configuration changes
- `docs`: Documentation changes
- `config`: Configuration file changes
- `deps`: Dependency updates

### Examples
```bash
# Good commit messages
git commit -m "feat(backend): add project CRUD operations"
git commit -m "fix(frontend): resolve navigation issue in mobile view"
git commit -m "docs: update quick start guide"
git commit -m "style(backend): format code according to style guide"
git commit -m "refactor(frontend): extract reusable components"
git commit -m "test(backend): add unit tests for ProjectService"
git commit -m "chore: update dependencies"
git commit -m "perf(frontend): optimize bundle size"
git commit -m "ci: add GitHub Actions workflow"
git commit -m "build: update Maven configuration"
git commit -m "revert: revert to previous stable version"

# Bad commit messages
git commit -m "fixed bug"
git commit -m "updated stuff"
git commit -m "WIP"
```

## 🔄 Branching Strategy

### Main Branches
- `main`: Production-ready code
- `develop`: Integration branch for features

### Feature Branches
- `feature/description`: New features
- `bugfix/description`: Bug fixes
- `hotfix/description`: Critical production fixes
- `release/version`: Release preparation

### Branch Naming Convention
```bash
# Feature branches
git checkout -b feature/add-user-authentication
git checkout -b feature/implement-payment-gateway

# Bug fix branches
git checkout -b bugfix/fix-login-issue
git checkout -b bugfix/resolve-api-timeout

# Hotfix branches
git checkout -b hotfix/security-patch
git checkout -b hotfix/critical-database-fix

# Release branches
git checkout -b release/v1.2.0
git checkout -b release/v2.0.0
```

## 🔧 Development Workflow

### 1. Starting a New Feature

```bash
# Update develop branch
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Make your changes
# ... code changes ...

# Stage and commit
git add .
git commit -m "feat(scope): add your feature description"

# Push to remote
git push origin feature/your-feature-name
```

### 2. Making Changes

```bash
# Check status
git status

# Stage specific files
git add backend/src/main/java/com/achpaudel/website/controller/ProjectController.java
git add frontend/src/app/app.component.ts

# Or stage all changes
git add .

# Commit with proper message
git commit -m "feat(backend): add project search functionality"

# Push changes
git push origin feature/your-feature-name
```

### 3. Updating Your Branch

```bash
# Fetch latest changes
git fetch origin

# Rebase on develop (recommended)
git checkout develop
git pull origin develop
git checkout feature/your-feature-name
git rebase develop

# Or merge develop (alternative)
git checkout feature/your-feature-name
git merge develop
```

### 4. Completing a Feature

```bash
# Ensure your branch is up to date
git checkout develop
git pull origin develop
git checkout feature/your-feature-name
git rebase develop

# Push final changes
git push origin feature/your-feature-name

# Create pull request on GitHub
# ... create PR on GitHub ...

# After PR is merged, clean up
git checkout develop
git pull origin develop
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

## 🔍 Useful Git Commands

### Status and Information
```bash
# Check status
git status

# Show commit history
git log --oneline -10

# Show commit history with graph
git log --graph --oneline --all

# Show changes in last commit
git show

# Show changes in specific commit
git show <commit-hash>
```

### Staging and Committing
```bash
# Stage specific files
git add <filename>

# Stage all changes
git add .

# Unstage files
git reset HEAD <filename>

# Commit with message
git commit -m "type(scope): description"

# Amend last commit
git commit --amend
```

### Branching
```bash
# List branches
git branch

# List all branches (including remote)
git branch -a

# Create and switch to new branch
git checkout -b <branch-name>

# Switch to existing branch
git checkout <branch-name>

# Delete local branch
git branch -d <branch-name>

# Delete remote branch
git push origin --delete <branch-name>
```

### Merging and Rebasing
```bash
# Merge branch into current branch
git merge <branch-name>

# Rebase current branch on another branch
git rebase <branch-name>

# Abort rebase
git rebase --abort

# Continue rebase after resolving conflicts
git rebase --continue
```

### Remote Operations
```bash
# Fetch latest changes
git fetch origin

# Pull changes
git pull origin <branch-name>

# Push changes
git push origin <branch-name>

# Set upstream for tracking
git push -u origin <branch-name>
```

### Stashing
```bash
# Stash changes
git stash

# Stash with message
git stash push -m "WIP: working on feature"

# List stashes
git stash list

# Apply latest stash
git stash pop

# Apply specific stash
git stash apply stash@{n}

# Drop stash
git stash drop stash@{n}
```

### Resetting and Reverting
```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1

# Mixed reset (unstage changes)
git reset HEAD~1

# Hard reset (discard changes)
git reset --hard HEAD~1

# Revert commit
git revert <commit-hash>
```

## 🚨 Git Hooks

The project includes Git hooks to ensure code quality:

### Pre-commit Hook
- Runs Maven tests for backend changes
- Runs Angular linting for frontend changes
- Prevents commits if tests fail

### Commit-msg Hook
- Validates commit message format
- Ensures conventional commit format
- Provides helpful error messages

## 🔧 Configuration

### Global Git Configuration
```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"

# Set default merge tool
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait $MERGED"
```

### Project-specific Configuration
```bash
# Use commit template
git config commit.template .gitmessage

# Set line ending handling
git config core.autocrlf input
git config core.eol lf
```

## 📋 Best Practices

### 1. Commit Frequently
- Make small, focused commits
- Commit when a logical unit of work is complete
- Use descriptive commit messages

### 2. Keep Branches Clean
- Delete merged branches
- Keep feature branches short-lived
- Regularly sync with develop

### 3. Review Before Committing
- Use `git diff` to review changes
- Run tests before committing
- Check for sensitive information

### 4. Use Meaningful Branch Names
- Use descriptive names
- Include issue numbers when applicable
- Follow the naming convention

### 5. Write Good Commit Messages
- Use the conventional format
- Be descriptive but concise
- Reference issues when applicable

## 🆘 Troubleshooting

### Common Issues

#### 1. Merge Conflicts
```bash
# Abort merge
git merge --abort

# Resolve conflicts manually
# Edit conflicted files
git add .
git commit -m "fix: resolve merge conflicts"
```

#### 2. Wrong Branch
```bash
# Stash changes
git stash

# Switch to correct branch
git checkout correct-branch

# Apply stashed changes
git stash pop
```

#### 3. Wrong Commit Message
```bash
# Amend last commit
git commit --amend -m "correct message"
```

#### 4. Accidentally Committed to Wrong Branch
```bash
# Create new branch with changes
git checkout -b feature/correct-branch

# Reset original branch
git checkout original-branch
git reset --hard HEAD~1
```

## 📚 Additional Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

---

**Happy Coding! 🚀**

Remember: Good Git practices lead to better collaboration and code quality. 
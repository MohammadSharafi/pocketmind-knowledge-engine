# CI/CD Workflows

This directory contains GitHub Actions workflows for continuous integration and deployment.

## Workflows

### 1. `ci.yml` - Main CI Pipeline
- Runs on push/PR to main/develop branches
- Lints and formats code
- Runs tests for all services (Flutter, Backend, Python)
- Builds artifacts on main branch

### 2. `flutter_test.yml` - Flutter Tests
- Runs Flutter unit tests
- Generates code coverage
- Uploads coverage to Codecov

### 3. `backend_test.yml` - Backend Tests
- Runs Spring Boot tests
- Uses PostgreSQL service container
- Uploads test results

### 4. `docker_build.yml` - Docker Builds
- Builds Docker images for backend and ai-worker
- Pushes to Docker Hub (on main branch)
- Uses build cache for faster builds

### 5. `cd.yml` - Continuous Deployment
- Deploys to staging on main branch
- Deploys to production on version tags (v*)

## Secrets Required

For Docker builds, add these secrets to GitHub:
- `DOCKER_USERNAME` - Docker Hub username
- `DOCKER_PASSWORD` - Docker Hub password/token

## Usage

Workflows run automatically on:
- Push to main/develop branches
- Pull requests to main/develop
- Manual trigger via workflow_dispatch

To trigger manually:
1. Go to Actions tab in GitHub
2. Select the workflow
3. Click "Run workflow"


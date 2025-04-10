# John Burbridge - Personal Website

## Overview
This repository contains the personal website for John Burbridge, a DevEx Engineering Consultant and founder of Spiral House.

## Project Structure
```
johnburbridge_com/
├── .github/workflows/     # GitHub Actions workflows
├── config/                # Configuration files
│   └── nginx.conf         # Nginx web server configuration
├── site/                  # Website content
│   ├── index.html         # Main HTML content
│   ├── profile.jpeg       # Profile picture
│   ├── script.js          # JavaScript for interactivity
│   └── styles.css         # CSS styling
├── .dockerignore          # Files to exclude from Docker build
├── .eslintrc.json         # JavaScript linting configuration
├── .htmlvalidate.json     # HTML validation configuration
├── .stylelintrc.json      # CSS linting configuration
├── Dockerfile             # Docker configuration for building container
├── package.json           # Node.js dependencies and scripts
└── version.txt            # Current version of the website
```

## Development

### Prerequisites
- Node.js 16+
- Docker (for local container testing)
- Git

### Local Development
1. Install dependencies:
   ```
   npm install
   ```

2. Lint code:
   ```
   npm run lint
   ```
   
3. Validate workflows (requires Homebrew):
   ```
   ./validate-workflows.sh
   ```

## Deployment Options

### CI/CD Pipeline
This project uses GitHub Actions for CI/CD with semantic versioning:

1. **Pull Request Workflow**:
   - Lints code and reports issues
   - Builds a container image with tag format: `MAJOR.MINOR.PATCH-dev.prN` 
   - Pushes to GitHub Container Registry
   - Comments on PR with image details and version

2. **Main Branch Workflow**:
   - Triggered after PR is merged to main
   - Takes the dev container from PR
   - Retags it as a release with format: `MAJOR.MINOR.PATCH`
   - Also tags as `latest`
   - Creates a GitHub release

3. **Versioning Workflow**:
   - Manually triggered to bump version (major, minor, patch)
   - Updates version.txt file
   - Creates a new git tag in format `vMAJOR.MINOR.PATCH`
   - Pushes tag and version changes
   
4. **Validation Workflow**:
   - Validates workflow files with actionlint
   - Runs automatically when workflow files change
   - Catches syntax errors and best practice issues

### Running Locally with Docker

1. Build the Docker image:
   ```
   docker build -t johnburbridge-site .
   ```

2. Run the container:
   ```
   docker run -d -p 8080:8080 johnburbridge-site
   ```

3. Access the website at http://localhost:8080

### Production Deployment
The container is published to GitHub Container Registry with semantic versioning (following SemVer principles) and can be deployed to any container platform:

```bash
# Using the stable latest version
docker pull ghcr.io/johnburbridge/johnburbridge-site:latest
docker run -d -p 8080:8080 ghcr.io/johnburbridge/johnburbridge-site:latest

# Using a specific semantic version (recommended for production)
docker pull ghcr.io/johnburbridge/johnburbridge-site:1.2.3
docker run -d -p 8080:8080 ghcr.io/johnburbridge/johnburbridge-site:1.2.3

# Using a development version from a PR
docker pull ghcr.io/johnburbridge/johnburbridge-site:1.2.3-dev.pr42
docker run -d -p 8080:8080 ghcr.io/johnburbridge/johnburbridge-site:1.2.3-dev.pr42
```

The versioning scheme follows standard semantic versioning:
- `MAJOR.MINOR.PATCH` for production releases (e.g., `1.2.3`)
- `MAJOR.MINOR.PATCH-dev.prNUMBER` for PR builds (e.g., `1.2.3-dev.pr42`)

The version is controlled via git tags, which can be created using the "Tag New Version" GitHub workflow.
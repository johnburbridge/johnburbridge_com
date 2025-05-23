# John Burbridge - Personal Website

[![Release Workflow Status](https://github.com/johnburbridge/johnburbridge_com/actions/workflows/main-workflow.yml/badge.svg?branch=main)](https://github.com/johnburbridge/johnburbridge_com/actions/workflows/main-workflow.yml)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/johnburbridge/johnburbridge_com?sort=semver)](https://github.com/johnburbridge/johnburbridge_com/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

## Overview

This repository contains the personal website for John Burbridge, a DevEx Engineering Consultant and founder of Spiral House.

## Project Structure

```
johnburbridge_com/
├── .devcontainer/         # VS Code Dev Container configuration
├── .github/workflows/     # GitHub Actions workflows
├── .husky/                # Husky Git hooks configuration
├── config/                # Configuration files (e.g., Nginx)
├── public/                # Static assets served by Astro
├── src/                   # Astro source files (pages, layouts, components, content)
│   ├── content/           # Markdown content (e.g., blog posts)
│   ├── layouts/           # Astro layout components
│   └── pages/             # Astro page components
├── .dockerignore          # Files to exclude from Docker build
├── .eslintrc.json         # JavaScript linting configuration
├── .gitignore             # Files ignored by Git
├── .htmlvalidate.json     # HTML validation configuration (if applicable)
├── .markdownlint.json     # Markdown linting configuration
├── .releaserc.json        # Semantic Release configuration
├── .stylelintrc.json      # CSS linting configuration
├── astro.config.mjs       # Astro configuration file
├── CHANGELOG.md           # Automatically generated release notes
├── Dockerfile             # Docker configuration for building container
├── package.json           # Node.js dependencies and scripts
├── package-lock.json      # Node.js locked dependencies
├── README.md              # This file
└── TODO.md                # Pending tasks
```

## Development

### Prerequisites

- Node.js 20+
- Docker (for local container testing)
- Git

### Local Development

1.  **Install dependencies:**

    ```bash
    npm ci
    ```

2.  **Run Astro dev server:**

    ```bash
    npm run dev
    ```
    This starts the development server, usually at `http://localhost:4321`.

3.  **Lint code:** See [Linting & Formatting](#linting--formatting) section.

4.  **Validate workflows (requires Homebrew and act):**
    ```bash
    # brew install act actionlint
    ./validate-workflows.sh
    # Test individual workflows locally (see .github/event_samples/)
    # act pull_request -e .github/event_samples/pull_request_event.json | cat
    ```

### Dev Container

This project includes a Dev Container configuration (`.devcontainer/`) for a consistent development environment using VS Code/Cursor Remote Containers or GitHub Codespaces.

**Key Features & Tools:**

- **Base OS:** Ubuntu 22.04
- **CLI Tools:**
  - `git`
  - `node` (v20.x) & `npm`
  - `docker` CLI (connects to host daemon via mounted socket)
  - `helm` v3
  - `gh` (GitHub CLI)
  - `shellcheck`
  - `actionlint` (for GitHub Actions workflow validation)
  - `markdownlint-cli2` (for Markdown linting)
  - `curl`, `gnupg`, `jq`
- **VS Code Extensions:**
  - Docker (`ms-azuretools.vscode-docker`)
  - GitHub Actions (`github.vscode-github-actions`)
  - Prettier (`esbenp.prettier-vscode`)
  - ESLint (`dbaeumer.vscode-eslint`)
  - Stylelint (`stylelint.vscode-stylelint`)
  - Markdownlint (`DavidAnson.vscode-markdownlint`)
  - YAML (`redhat.vscode-yaml`)
  - Kubernetes (`ms-kubernetes-tools.vscode-kubernetes-tools`)
  - ShellCheck (`timonwong.shellcheck`)
- **Key Configurations:**
  - Ports `8080` (built container) and `4321` (Astro dev) forwarded.
  - Host's Docker socket mounted (allows controlling host Docker from container).
  - Host's `.gitconfig` and `.ssh` directory mounted (shares Git/SSH configuration).
  - Runs as non-root user `vscode` with `sudo` privileges.
  - Installs `markdownlint-cli2` globally on container creation.

To use the Dev Container:

1.  Ensure you have Docker Desktop running.
2.  Open this project folder in VS Code/Cursor.
3.  When prompted, click "Reopen in Container". Alternatively, open the Command Palette (`Cmd/Ctrl+Shift+P`) and select "Remote-Containers: Reopen in Container".

## Linting & Formatting

This project uses several linters to maintain code quality and consistency:

- **ESLint (`.eslintrc.json`):** For JavaScript code.
- **Stylelint (`.stylelintrc.json`):** For CSS code.
- **Markdownlint (`.markdownlint.json`):** For Markdown files (like this README and blog posts).
  - Uses `markdownlint-cli2`.
  - Configured with default rules.
  - Integrated with a **pre-push Git hook** via Husky and lint-staged. Markdown files staged for commit will be linted automatically before you can push.

**Run linters manually:**

```bash
# Lint CSS & JS
npm run lint

# Lint all Markdown files
npx markdownlint-cli2 "**/*.md" "#node_modules"

# Lint specific Markdown file
npx markdownlint-cli2 src/content/blog/001-about-this-blog.md
```

(Note: Prettier is included as a VS Code extension but not currently enforced via CLI script).

## Development Workflow & Conventional Commits

This project uses an automated release process powered by [Semantic Release](https://semantic-release.gitbook.io/) and [Conventional Commits](https://www.conventionalcommits.org/).

1.  **Feature Development:** Create a new branch for your feature or fix (`git checkout -b feature/my-new-feature`).
2.  **Make Changes:** Implement your changes.
3.  **Commit Changes:** Commit your work using the **Conventional Commits** format. This is crucial for automated versioning.
    - Examples:
      - `feat: Add dark mode toggle` (Results in a MINOR release)
      - `fix: Correct alignment issue on mobile` (Results in a PATCH release)
      - `perf: Optimize image loading` (Results in a PATCH release)
      - `docs: Update README with deployment instructions` (No release)
      - `chore: Update dependencies` (No release)
      - `feat!: Add user authentication` (Note the `!`. Results in a MAJOR release)
      - `fix: Solve login bug
BREAKING CHANGE: User session format changed.` (Results in a MAJOR release)
4.  **Create Pull Request:** Open a Pull Request against the `main` branch.
5.  **CI Checks:** The PR workflow will automatically:
    - Run linters (CSS, JS - Markdown is checked by pre-push hook).
    - Build a Docker image tagged as `pr-{PR_NUMBER}`.
    - Push the image to GitHub Container Registry (ghcr.io).
    - Comments on PR with instructions to pull the test image.
6.  **Code Review & Merge:** Once the PR is approved and merged into `main`...
7.  **Automated Release:** The Main workflow triggers:
    - `semantic-release` analyzes the conventional commit messages merged since the last release.
    - If release-worthy commits (`feat`, `fix`, `perf`, `!` or `BREAKING CHANGE`) are found:
      - Calculates the next semantic version (e.g., `1.2.3`).
      - Updates `package.json` version.
      - Updates `CHANGELOG.md`.
      - Commits these changes with `[skip ci]`.
      - Creates a Git tag (e.g., `v1.2.3`).
      - Creates a GitHub Release with generated notes.
      - Pulls the `pr-{PR_NUMBER}` image associated with the merge commit.
      - Retags the image with the new version (`1.2.3`) and `latest`.
      - Pushes the release tags to ghcr.io.
    - If no release-worthy commits are found, no release occurs.

**Key Takeaway:** Use Conventional Commit messages when committing code that will be merged into `main`. This drives the entire automated release process.

## CI/CD Pipeline (Summary)

This project uses GitHub Actions for CI/CD with semantic versioning automated by Semantic Release:

1.  **PR Workflow (`pr-workflow.yml`)**: Triggered on Pull Requests to `main`.

    - Lints code (CSS, JS).
    - Builds a container image tagged `pr-{PR_NUMBER}`.
    - Pushes to GitHub Container Registry.
    - Comments on PR with image details.

2.  **Release Workflow (`main-workflow.yml`)**: Triggered on pushes to `main`.

    - Runs `semantic-release` to analyze commits, bump version, generate changelog, commit changes, create Git tag, and create GitHub Release (if applicable).
    - If a new release was created, retags the corresponding `pr-{PR_NUMBER}` image as the new semantic version (e.g., `1.2.3`) and `latest`, pushing them to GitHub Container Registry.

3.  **Validation Workflow (`validate.yml`)**: Triggered on pushes affecting `.github/workflows/**` (except on `main`).
    - Validates workflow files with `actionlint`.

## Running Locally with Docker

1.  Build the Docker image:

    ```bash
    docker build -t johnburbridge-site .
    ```

2.  Run the container:

    ```bash
    docker run -d -p 8080:8080 johnburbridge-site
    ```

3.  Access the website at `http://localhost:8080`

## Production Deployment

The container is published to GitHub Container Registry (`ghcr.io/johnburbridge/johnburbridge-site`) with semantic version tags created automatically by the CI/CD pipeline. Use these tags for deployment:

```bash
# Using the stable latest version (points to the most recent release)
docker pull ghcr.io/johnburbridge/johnburbridge-site:latest
docker run -d -p 8080:8080 ghcr.io/johnburbridge/johnburbridge-site:latest

# Using a specific semantic version (RECOMMENDED for production stability)
docker pull ghcr.io/johnburbridge/johnburbridge-site:1.2.3
docker run -d -p 8080:8080 ghcr.io/johnburbridge/johnburbridge-site:1.2.3

# Using a development version from a PR (for testing)
docker pull ghcr.io/johnburbridge/johnburbridge-site:pr-42
docker run -d -p 8080:8080 ghcr.io/johnburbridge/johnburbridge-site:pr-42
```

Releases and versioning are handled automatically based on Conventional Commits merged into the `main` branch.

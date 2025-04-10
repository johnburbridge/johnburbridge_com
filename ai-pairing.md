# AI Pairing Guidelines for johnburbridge_com

This document provides guidelines and context for AI assistants collaborating on the `johnburbridge/johnburbridge_com` repository. Please refer to this document to understand the project's structure, tools, and workflows.

## Project Overview

This repository contains the source code for the personal website of John Burbridge ([johnburbridge.com](https://johnburbridge.com)). It's a static site served via Nginx within a Docker container.

For a detailed project structure and file overview, please see the main [README.md](./README.md).

## Key Technologies & Tools

- **Frontend:** HTML5, CSS3, JavaScript
- **Web Server:** Nginx (via Docker container)
- **Build/Linting:** Node.js/npm scripts
- **Containerization:** Docker
- **CI/CD:** GitHub Actions
- **Versioning:** Semantic Release

## Development Environment: Dev Container

The primary development environment is the configured **Dev Container** (`.devcontainer/`). Always prefer working _inside_ the Dev Container for consistency.

**Key Features & Tools Inside Container:**

- **Base OS:** Ubuntu 22.04
- **Shell:** `zsh` with `oh-my-zsh` (provides Git branch in prompt, history, and completions). Default plugins: `git`, `history`, `kubectl`.
- **Core Tools:** `git`, `node` (v20.x), `npm`, `docker` CLI, `helm` v3, `gh` (GitHub CLI), `kubectl`, `curl`, `jq`, `sudo`.
- **Linters/Formatters:** `shellcheck`, `actionlint`. (JS/CSS/HTML linters run via npm, see Code Quality section).
- **VS Code Extensions (Pre-installed):** Docker, GitHub Actions, Prettier, ESLint, Stylelint, YAML, Kubernetes, ShellCheck.

**Important Configurations:**

- **Host Mounts:**
  - `/var/run/docker.sock`: Allows controlling the host Docker daemon from within the container.
  - `~/.gitconfig`: Shares host Git configuration. **Important:** See Git Signing note below.
  - `~/.ssh`: Shares host SSH keys for Git authentication.
- **User:** Runs as non-root `vscode` user with passwordless `sudo`.
- **Port Forwarding:** Port `8080` is forwarded from the container.

**Git Signing Inside Container:**

- Commit signing is enabled via the mounted host `.gitconfig`.
- Because the host path for the SSH key (`~/.ssh/...`) differs from the container path (`/home/vscode/.ssh/...`), you **must** set the repository-local Git config:
  ```bash
  git config --local user.signingkey /home/vscode/.ssh/your_key_name.pub
  ```
  _Replace `your_key_name.pub` with the actual public key filename._

## Git Workflow & Versioning

This project uses **Semantic Release** driven by **Conventional Commits**. Adhering to this is crucial.

1.  **Branching:** Create feature or fix branches from `main` (e.g., `feat/add-contact-form`, `fix/css-alignment`).
2.  **Committing:** Use Conventional Commit messages. Examples:
    - `feat: Add new portfolio section` (Minor release)
    - `fix: Correct navigation link error` (Patch release)
    - `perf: Optimize image loading speed` (Patch release)
    - `docs: Update README with deployment steps` (No release)
    - `style: Format code according to Prettier rules` (No release)
    - `refactor: Improve JavaScript structure` (No release)
    - `test: Add unit tests for script.js` (No release)
    - `chore: Update npm dependencies` (No release)
    - `feat!: Implement user login system` (**Breaking Change** -> Major release)
    - `fix: Resolve critical rendering bug\n\nBREAKING CHANGE: Requires updated browser version.` (**Breaking Change** -> Major release)
3.  **Pull Requests:** Open PRs against the `main` branch. PRs trigger CI checks.
4.  **Merging:** Merging to `main` triggers the release workflow.

## CI/CD Overview (GitHub Actions)

- **PR Workflow (`pr-workflow.yml`):** Runs linters, builds a Docker image tagged `pr-{PR_NUM}`, pushes to GHCR.
- \*\*Main Workflow (`main-workflow.yml`):
  - Runs Semantic Release on merge to `main`.
  - If release-worthy commits are found: bumps version, updates `package.json`/`CHANGELOG.md`, creates Git tag & GitHub Release.
  - Pulls the corresponding `pr-{PR_NUM}` image, retags it with the new version (e.g., `1.2.3`) and `latest`, pushes tags to GHCR.
- **Validation Workflow (`validate.yml`):** Validates workflow syntax using `actionlint`.

## Code Quality & Linting

- **Tools:** Prettier, ESLint, Stylelint, HTMLValidate, ShellCheck, Actionlint.
- **Command:** Run all relevant linters using `npm run lint`.
- Please ensure code passes linting checks before committing.

## Common Tasks

- **Install Dependencies:** `npm ci`
- **Run Linters:** `npm run lint`
- **Build Docker Image Locally:** `docker build -t johnburbridge-site .`
- **Run Docker Container Locally:** `docker run -d -p 8080:8080 johnburbridge-site` (Access at `http://localhost:8080`)

## AI Collaboration Guidelines

- **Check this doc first:** Refer to this document for project conventions.
- **Use Tools:** Prefer making file edits using the available tools (`edit_file`).
- **Explain Changes:** Clearly state the reason for proposed code changes or tool usage.
- **Conventional Commits:** When suggesting commit messages or creating PRs, please use the Conventional Commit format described above.
- **Use Container Tools:** Leverage the tools installed within the Dev Container (linters, `gh`, `git`, etc.) when appropriate.
- **Mind the Context:** Remember you are operating within the Dev Container. Be mindful of file paths and configurations specific to this environment (e.g., the Git signing key path).
- **File Path Handling Note:** There appears to be an inconsistency in path handling between different file system tools in this environment.
  - When _writing_ files (`mcp_filesystem_write_file`), specifying the full host path (e.g., `/Users/jburbridge/Projects/johnburbridge_com/filename.md`) seems necessary.
  - When _reading_ files (`read_file`), using a simple relative path (e.g., `filename.md`) appears to work correctly. Please be aware of this when interacting with files.

---

_This document helps ensure smooth collaboration. Please suggest updates if workflows or tools change!_

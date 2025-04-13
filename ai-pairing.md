# AI Pairing Guidelines for johnburbridge_com

This document provides guidelines and context for AI assistants collaborating on the `johnburbridge/johnburbridge_com`
repository. Please refer to this document to understand the project's structure, tools, and workflows.

## Project Overview

This repository contains the source code for the personal website of John Burbridge
([johnburbridge.com](https://johnburbridge.com)). It's a static site served via Nginx within a Docker container.

For a detailed project structure and file overview, please see the main [README.md](./README.md).

## Key Technologies & Tools

- **Frontend:** HTML5, CSS3, JavaScript
- **Web Server:** Nginx (via Docker container)
- **Build/Linting:** Node.js/npm scripts
- **Containerization:** Docker
- **CI/CD:** GitHub Actions
- **Versioning:** Semantic Release

## Development Environment: Dev Container

The primary development environment is the configured **Dev Container** (`.devcontainer/`). Always prefer working
_inside_ the Dev Container for consistency.

**Key Features & Tools Inside Container:**

- **Base OS:** Ubuntu 22.04
- **Shell:** `zsh` with `oh-my-zsh` (provides Git branch in prompt, history, and completions). Default plugins: `git`,
  `history`, `kubectl`.
- **Core Tools:** `git`, `node` (v20.x), `npm`, `docker` CLI, `helm` v3, `gh` (GitHub CLI), `kubectl`, `curl`, `jq`,
  `sudo`.
- **Linters/Formatters:** `shellcheck`, `actionlint`. (JS/CSS/HTML linters run via npm, see Code Quality section).
- **VS Code Extensions (Pre-installed):** Docker, GitHub Actions, Prettier, ESLint, Stylelint, YAML, Kubernetes,
  ShellCheck.

**Important Configurations:**

- **Host Mounts:**
  - `/var/run/docker.sock`: Allows controlling the host Docker daemon from within the container.
  - `~/.gitconfig`: Shares host Git configuration. **Important:** See Git Signing note below.
  - `~/.ssh`: Shares host SSH keys for Git authentication.
- **User:** Runs as non-root `vscode` user with passwordless `sudo`.
- **Port Forwarding:** Port `8080` is forwarded from the container.

**Git Signing Inside Container:**

- Commit signing is enabled via the mounted host `.gitconfig`.
- Because the host path for the SSH key (`~/.ssh/...`) differs from the container path (`/home/vscode/.ssh/...`), you
  **must** set the repository-local Git config:

  ```bash
  git config --local user.signingkey /home/vscode/.ssh/your_key_name.pub
  ```

  _Replace `your_key_name.pub` with the actual public key filename._

## Git Workflow & Versioning

This project uses **Semantic Release** driven by **Conventional Commits**. Adhering to this is crucial.

**The standard workflow is:**

1. **Sync `main`:** Ensure your local `main` branch is up-to-date with the remote `origin/main`
   (`git checkout main && git pull origin main`).
2. **Create Branch:** Create a new feature or fix branch from `main` (e.g., `git checkout -b feat/add-contact-form` or
   `git checkout -b fix/css-alignment`). **Do not commit directly to `main`.**
3. **Make Changes:** Implement your changes on the branch.
4. **Commit Changes:** Commit your work using the **Conventional Commits** format. Examples:
   - `feat: Add new portfolio section` (Minor release)
   - `fix: Correct navigation link error` (Patch release)
   - `build: Update Dockerfile build stage`
   - `ci: Skip docker push when running act`
   - `docs: Update AI pairing guidelines`
   - `refactor: Simplify JavaScript logic`
   - `test: Add unit tests for script.js`
   - `chore: Update npm dependencies`
   - `feat!: Implement user login system` (**Breaking Change** -> Major release)
   - `fix!: Resolve critical rendering bug4` (**Breaking Change** -> Major release)
5. **Push Branch:** Push your local branch to the remote (`git push origin your-branch-name`).
6. **Create Pull Request:** Use the GitHub UI or the`gh pr create` command tos open a Pull Request from your branch
   against the `main` branch. Provide a descriptive title and body.
7. **CI Checks:** The PR workflow will automatically run linters and build/validate the Docker image. 8. **Code Review &
   Merge:** Once the PR passes CI checks and is approved, merge it into `main` using the GitHub UI (typically using a
   **Squash and Merge** or **Rebase and Merge** strategy). 9. **Automated Release:** Merging to `main` triggers the
   release workflow, which handles version bumping, changelog generation, tagging, and publishing based on the
   Conventional Commits in the merged PR.

## CI/CD Overview (GitHub Actions)

- **PR Workflow (`pr-workflow.yml`):** Runs linters, builds a Docker image tagged `pr-{PR_NUM}`, pushes to GHCR.
- \*\*Main Workflow (`main-workflow.yml`):
  - Runs Semantic Release on merge to `main`.
  - If release-worthy commits are found: bumps version, updates `package.json`/`CHANGELOG.md`, creates Git tag & GitHub
    Release.
  - Pulls the corresponding `pr-{PR_NUM}` image, retags it with the new version (e.g., `1.2.3`) and `latest`, pushes
    tags to GHCR.
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
- **Conventional Commits:** When suggesting commit messages or creating PRs, please use the Conventional Commit format
  described above.
- **Use Container Tools:** Leverage the tools installed within the Dev Container (linters, `gh`, `git`, etc.) when
  appropriate.
- **Mind the Context:** Remember you are operating within the Dev Container. Be mindful of file paths and configurations
  specific to this environment (e.g., the Git signing key path).
- **File Path Handling Note:** There appears to be an inconsistency in path handling between different file system tools
  in this environment.

  - When _writing_ files (`mcp_filesystem_write_file`), specifying the full host path (e.g.,
    `/Users/jburbridge/Projects/johnburbridge_com/filename.md`) seems necessary.
  - When _reading_ files (`read_file`), using a simple relative path (e.g., `filename.md`) appears to work correctly.
    Please be aware of this when interacting with files.

- **Git Workflow:** Always follow the standard Git workflow described above:
  1. Ensure `main` is up-to-date.
  2. Create a new branch for changes.
  3. Commit changes to the branch using Conventional Commits.
  4. Push the branch.
  5. Open a descriptive Pull Request against `main`. _Do not suggest committing or pushing directly to the `main`
     branch._ Ask the user to merge approved PRs.

---

_This document helps ensure smooth collaboration. Please suggest updates if workflows or tools change!_

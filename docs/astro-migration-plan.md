# Astro Migration Plan for johnburbridge.com

This document outlines the steps required to migrate the existing static HTML site to use the Astro Static Site Generator (SSG) to enable blog functionality.

**Goal:** Re-architect the site using Astro while preserving existing content and appearance, setting the stage for adding a blog.

**Branch:** `feat/blog` (or a dedicated migration branch)

## Phase 1: Astro Setup & Basic Content Migration

**Objective:** Get the existing homepage rendering correctly using Astro's structure and build process.

1. **Install Astro Dependency:**

   - [x] Add `astro` to `devDependencies` in `package.json`.
   - [ ] Run `npm install` within the dev container.

2. **Create Astro Configuration (`astro.config.mjs`):**

   - [ ] Create `astro.config.mjs` in the project root.
   - [ ] Add basic configuration (ensures static output, which is default):

     ```javascript
     import { defineConfig } from 'astro/config';

     // https://astro.build/config
     export default defineConfig({});
     ```

3. **Establish Astro Directory Structure:**

   - [ ] Create `src/` directory.
   - [ ] Create `src/pages/` (for page routes).
   - [ ] Create `src/layouts/` (for page structure templates).
   - [ ] Create `src/styles/` (for CSS).
   - [ ] Create `src/scripts/` (for JS, if needed).
   - [ ] Create `public/` (for static assets like images, favicons).

4. **Create Base Layout (`src/layouts/BaseLayout.astro`):**

   - [ ] Create `src/layouts/BaseLayout.astro`.
   - [ ] Move the core HTML structure ( `<html>`, `<head>`, `<body>` tags, links to CSS/JS, meta tags) from `site/index.html` into this layout.
   - [ ] Use Astro's `<slot />` element where the main page content should go.
   - [ ] Import and reference `global.css` (see Step 6).
   - Example structure:

     ```astro
     ---
     // Component Script (JavaScript/TypeScript)
     import '../styles/global.css'; // Import styles
     // Potentially import scripts or define props
     ---
     <html lang="en">
     <head>
         <meta charset="UTF-8">
         <meta name="viewport" content="width=device-width, initial-scale=1.0">
         <title>John Burbridge</title> <!-- TODO: Make title dynamic via props -->
         <!-- Add other meta tags, favicons, etc. -->
         <link rel="stylesheet" href="/styles/global.css"> <!-- Or let Astro handle bundling -->
     </head>
     <body>
         <slot /> <!-- Page content will be injected here -->
         <script src="/scripts/script.js"></script> <!-- Or let Astro handle bundling -->
     </body>
     </html>
     ```

5. **Migrate Homepage (`src/pages/index.astro`):**

   - [ ] Create `src/pages/index.astro`.
   - [ ] Use the `BaseLayout` created in Step 4.
   - [ ] Move the content _within_ the `<body>` tag from `site/index.html` into this file, wrapping it with the layout component.
   - Example:

     ```astro
     ---
     import BaseLayout from '../layouts/BaseLayout.astro';
     ---
     <BaseLayout>
         <!-- All content previously inside <body> of index.html goes here -->
         <header>...</header>
         <main>...</main>
         <footer>...</footer>
     </BaseLayout>
     ```

6. **Migrate CSS (`src/styles/global.css`):**

   - [ ] Create `src/styles/global.css`.
   - [ ] Move the content from `site/styles.css` into this file.
   - [ ] Ensure `BaseLayout.astro` imports or links to this CSS correctly. Astro can handle CSS bundling/processing if imported.

7. **Migrate JavaScript (`src/scripts/script.js` or `public/script.js`):**

   - [ ] Move `site/script.js`.
   - [ ] **Option A (If needs bundling/processing):** Move to `src/scripts/script.js`. Import it within `<script>` tags in `BaseLayout.astro`.
   - [ ] **Option B (If plain JS, no processing needed):** Move to `public/script.js`. Link to it via `<script src="/script.js"></script>` in `BaseLayout.astro`. (Let's start with Option B for simplicity unless bundling becomes necessary).

8. **Migrate Static Assets (`public/`):**

   - [ ] Move `site/profile.jpeg` to `public/profile.jpeg`.
   - [ ] Update the `<img>` tag src in `src/pages/index.astro` to point to `/profile.jpeg` (paths in `public` are served from the root).
   - [ ] Move any other static assets (favicons, etc.) from `site/` to `public/`.

9. **Update `package.json` Scripts:**

   - [ ] Add `"dev": "astro dev"` script for the local development server.
   - [ ] Add `"build": "astro build"` script for generating the static site.
   - [ ] Modify `"lint"` script:
     - Remove `lint:html` (Astro handles HTML generation).
     - Update `lint:css` path to `src/**/*.css`.
     - Update `lint:js` path to `src/**/*.js` (or adjust if JS is in `public`). Consider adding Astro ESLint integration later.

10. **Clean Up Old Structure:**

    - [ ] Delete the `site/` directory.

11. **Local Testing:**
    - [ ] Run `npm run dev`.
    - [ ] Access the site via the local URL provided (usually `http://localhost:4321`).
    - [ ] Verify the homepage looks and functions identically to the original. Check console for errors.

## Phase 2: Build Process & CI/CD Integration

**Objective:** Ensure the Astro site builds correctly and integrates with the existing Docker and GitHub Actions setup.

1. **Test Build:**

   - [ ] Run `npm run build`.
   - [ ] Verify static files are generated in the `dist/` directory. Inspect `dist/index.html` to ensure it contains the expected content.

2. **Update `Dockerfile`:**

   - [ ] Add `RUN npm run build` _after_ `npm ci` and _before_ any `COPY` commands that expect the final site files.
   - [ ] Update the Nginx configuration (`config/nginx.conf`) or `COPY` command in `Dockerfile` to serve files from the `./dist` directory instead of `./site`. (Requires analyzing the current `Dockerfile` and `nginx.conf`).

3. **Update GitHub Actions (`.github/workflows/*.yml`):**

   - [ ] In `pr-workflow.yml`, add `npm run build` before the `docker build` step.
   - [ ] In `main-workflow.yml`, add `npm run build` before the `docker build` step (or before the step where the image is pulled/retagged if relying on PR build artifact).

4. **Testing CI/CD:**
   - [ ] Push changes to the branch.
   - [ ] Create a draft PR to test `pr-workflow.yml`. Verify the build step runs and the Docker image is built using the `dist/` content.
   - [ ] (Later) Merge to test `main-workflow.yml`.

## Phase 3: Blog Implementation (High-Level)

**Objective:** Set up the core structure for the blog.

1. **Configure Content Collections:**
   - [ ] Define a "blog" collection in `src/content/config.ts` (requires installing `@astrojs/markdown-remark` or similar). Define schema (title, description, pubDate, body, links).
2. **Create Blog Posts:**
   - [ ] Create `src/content/blog/` directory.
   - [ ] Add sample blog posts as Markdown files (`.md`) with frontmatter matching the schema.
3. **Create Blog Layout (`src/layouts/BlogPostLayout.astro`):**
   - [ ] Design a layout specifically for rendering individual blog posts.
4. **Create Dynamic Blog Post Pages (`src/pages/blog/[...slug].astro`):**
   - [ ] Create a dynamic route file.
   - [ ] Use `getStaticPaths` to query all blog posts from the collection.
   - [ ] Render each post using the `BlogPostLayout`.
5. **Create Blog Index Page (`src/pages/blog/index.astro`):**
   - [ ] Create the main blog listing page.
   - [ ] Query all blog posts, sort by date (newest first).
   - [ ] List posts with titles, dates, descriptions, and links to the full post.
6. **Update Homepage Sidebar:**
   - [ ] Modify `src/pages/index.astro`.
   - [ ] Query the latest N blog posts.
   - [ ] Render the list of titles/dates in the sidebar area.
7. **Add Navigation:**
   - [ ] Update `BaseLayout.astro` (or a dedicated navigation component) to include a link to `/blog`.

---

_This plan provides a structured approach. Details within each step may need refinement as implementation proceeds._

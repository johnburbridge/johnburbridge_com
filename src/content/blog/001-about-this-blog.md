---
title: "About This Blog: Why, What, and How"
description: "An introductory post explaining the motivation behind starting this blog, the topics it will cover, and the technology choices powering it."
pubDate: 2024-07-26 # Consider updating this date
# heroImage: '/placeholder-hero.jpg' # Optional: Add a hero image path later
tags: ["meta", "introduction", "tech", "astro", "docker", "ci/cd"]
---

## Why Start This Blog?

Welcome! I've been wanting a space to share my thoughts, learnings, and
experiments in the tech world for a while now. This blog serves several purposes:

1. **Knowledge Sharing:** Documenting what I learn helps solidify my
    understanding and might be useful to others facing similar challenges.
    I had a VP at Salesforce.com who often said "Clear writing is clear
    thinking", which I firmly agree with.
2. **Personal Project:** Building and maintaining this site is a project in
    itself, allowing me to experiment with new tech and stay sharp.
3. **Portfolio Expansion:** It's a living extension of my professional profile,
    showcasing my interests and technical abilities beyond a static resume.

## What to Expect?

This blog will mostly be a collection of my notes and experiences navigating the
tech landscape. Expect explorations into areas like:

- **DevOps & Home Lab Adventures:** Journey with me into the (sometimes complex,
  often self-inflicted) world of self-hosting and automation. We'll touch on
  Docker, Kubernetes distributions, CI/CD pipelines using GitHub Actions
  (and maybe grumbling about `act` inconsistencies), managing storage, GitOps
  workflows, and the surprisingly deep rabbit hole of home network setups
  (OpnSense, Unifi, DNS debates...).
- **Software Engineering Practices:** Practical takes on improving the development
  process, often learned the hard way. This includes thoughts on versioning
  strategies that _mostly_ prevent chaos (SemVer, Conventional Commits,
  Semantic Release), experiences with AI pair programming tools (the good,
  the bad, and the 'what were you thinking?'), testing approaches that ideally
  don't require therapy afterwards, and general code quality considerations.
- **Web Development:** Primarily focusing on the technologies used to build this
  site, like the Astro framework (because who doesn't love adding another
  framework to the pile?).
- **Tech Comparisons & Musings:** Occasional comparisons between tools or
  platforms (because everyone needs more opinions on LLMs or editor setups),
  thoughts on industry trends, wrestling with licensing models, and hardware
  choices (e.g., Mini PCs vs. Raspberry Pis - the answer is probably
  'it depends').

Essentially, if it's a technology or practice I'm actively using, learning,
 or currently losing sleep over, there's a good chance it'll show up here.

## The Tech Stack "How"

As a tech enthusiast, the "how" is often as interesting as the "what". This site
is built with:

- **[Astro](https://astro.build/):** A modern static site generator known for
  performance and its component-based architecture. It allows mixing UI
  frameworks, but I'm starting simple.
- **HTML/CSS/JavaScript:** The fundamental building blocks.
- **[Docker](https://www.docker.com/):** The entire site, including the Nginx web
  server, runs inside a container for consistency across environments.
- **[GitHub Actions](https://github.com/features/actions):** For continuous
  integration and deployment (CI/CD). Pull requests are automatically linted
  and built, and merges to `main` trigger releases.
- **[Semantic Release](https://semantic-release.gitbook.io/):** Automates
  versioning and changelog generation based on Conventional Commit messages.
- **[Dev Container](https://containers.dev/):** The development environment is
  standardized within a VS Code Dev Container, ensuring all tools and
  configurations are consistent.

This setup allows for a robust, maintainable, and automated workflow. I doubt it
will look the same a year from now, but isn't that exactly the point?

Stay tuned for more posts! Next up, I'm planning on doing a deep dive into
SemVer, Conventional Commits, Semantic Releases and exploring their benefits and
drawbacks. I may even dip into monorepos vs polyrepos.

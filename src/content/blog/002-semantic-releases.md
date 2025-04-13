---
title: 'Semantic Versioning & Releases: Taming the Release Chaos (Mostly)'
description:
  'An exploration of why your version numbers might resemble random number generation, and how Semantic Versioning,
  Conventional Commits, and Semantic Release can bring a semblance of order.'
pubDate: 2024-07-28 # Update this date before publishing
tags: ['versioning', 'semver', 'conventional commits', 'semantic release', 'ci/cd', 'automation', 'devops']
---

## The Pre-Enlightenment Era: Versioning by Gut Feel

Let's be honest. Before structured versioning strategies became more widespread, how did we version our software? Was it
based on the date? The number of features crammed in since the last release? A complex astrological calculation? Or,
more likely, was it just incrementing whatever number felt right after a late-night merge session, often resulting in
gems like `v1.2-final`, `v1.2-final-hotfix`, or the ever-popular `v1.3-maybe-works`?

This approach, while charmingly chaotic, comes at a cost.

## 1. The Cost of Versioning Anarchy

Without a sane, predictable versioning strategy, you're signing up for a world of pain, including:

- **Dependency Hell:** If you consume libraries or services, how do you know if upgrading from `v1.7.2-beta-rc1` to
  `v1.7.3-final-patch` will subtly break everything or just fix a typo? It becomes a lottery.
- **Communication Breakdown:** How do you communicate the _nature_ of changes between releases? Users (internal or
  external) rely on version numbers to understand impact. "We released a new version!" isn't helpful. "We released
  `v2.0.0` which includes breaking changes" is.
- **Integration Nightmares:** Trying to integrate multiple services or libraries that all use whimsical versioning is...
  an exercise in debugging, patience, and possibly questioning your life choices.
- **Manual Toil:** Figuring out what changed, writing release notes, deciding on the next version number – it's tedious,
  error-prone work that developers generally despise (speaking from experience).

Essentially, inconsistent versioning introduces friction, risk, and wasted time. There must be a better way, right?
(Spoiler: Yes, mostly.)

## 2. Semantic Versioning (SemVer): A Glimmer of Hope

Enter [Semantic Versioning (SemVer)](https://semver.org/), a simple set of rules designed to convey meaning through
version numbers. It's structured as `MAJOR.MINOR.PATCH` (e.g., `v1.4.2`):

- **MAJOR (`1`):** Incremented when you make **incompatible API changes** (breaking changes). Consumers know upgrading
  this might require code changes on their end.
- **MINOR (`4`):** Incremented when you add **functionality in a backward-compatible manner**. New features! Upgrading
  should be safe.
- **PATCH (`2`):** Incremented when you make **backward-compatible bug fixes**. Fixes! Definitely safe to upgrade
  (usually...).

The core idea is that the version number itself signals the _type_ of changes included, based on a declared "public
API". This brings predictability and allows for more intelligent dependency management (e.g., package managers can
safely update patch versions using `~1.4.0` or minor versions using `^1.4.0`).

It's almost like... a standard! Revolutionary, I know.

## 3. Conventional Commits: Making Humans Do the Work (for Robots)

SemVer is great, but how do you _know_ whether the changes since the last release warrant a MAJOR, MINOR, or PATCH bump?
You could manually review every commit... or you could enforce a structure on your commit messages that _tells_ you.

This is where [Conventional Commits](https://www.conventionalcommits.org/) come in. It's a specification for commit
message formats that allows tools to parse them automatically. The basic structure is:

```text
<type>[optional scope]: <description>
[optional body]
[optional footer(s)]
```

The key parts for SemVer automation are:

- **`type`:** Indicates the kind of change. Crucially:
  - `fix:` maps to a `PATCH` release in SemVer.
  - `feat:` maps to a `MINOR` release in SemVer.
- **`!` (after type/scope):** Appending `!` (e.g., `feat!: drop support for Node 12`) indicates a **BREAKING CHANGE**,
  mapping to a `MAJOR` release.
- **Footer `BREAKING CHANGE:`:** Alternatively, adding this footer also signifies a MAJOR bump.

By enforcing this format (usually via linters or commit hooks), your Git history becomes machine-readable, directly
linking code changes to their semantic impact.

**Criticisms & Drawbacks:** Yes, you have to _think_ about your commit messages now. The horror. Common criticisms
include:

- **Rigidity:** It can feel overly prescriptive.
- **History Noise:** Some find the `chore:` or `docs:` commits clutter the log (though they are essential for
  filtering).
- **Adoption Friction:** Getting a whole team to consistently follow the spec requires discipline and tooling.
- **Subjectivity:** Deciding between `fix:` and `feat:` isn't always clear-cut.

Are the criticisms valid? Sure. Is the potential payoff in automation worth the effort? Often, yes. But like any
convention, it requires buy-in.

## 4. Semantic Release: The Automation Engine

So, you have SemVer rules and machine-readable Conventional Commits. Now what? Now you bring in the magic: **Semantic
Release**.

[Semantic Release](https://semantic-release.gitbook.io/) (often used via the `semantic-release` CLI tool) is an
automation tool that takes these pieces and automates your entire release workflow. Typically run in a CI/CD pipeline
(like GitHub Actions) on your main branch, it does the following:

1. **Analyzes Commits:** Reads all commits since the last Git tag that matches a version number.
2. **Determines Next Version:** Based on the Conventional Commit types (`fix:`, `feat:`, `BREAKING CHANGE:`), it
   calculates the _next_ SemVer version number (or determines no release is needed).
3. **Generates Changelog:** Creates release notes based on the commit messages.
4. **Updates `package.json` (optional):** Bumps the version number in your project file.
5. **Commits Changes:** Commits the updated `package.json`, `CHANGELOG.md`, etc.
6. **Creates Git Tag:** Tags the release commit with the new version (e.g., `v1.5.0`).
7. **Creates GitHub/GitLab Release:** Publishes a release on your Git platform with the tag and generated notes.
8. **Publishes Package (optional):** Can publish to npm, Docker registries, etc.

Essentially, it automates the tedious, error-prone release dance, driven entirely by your commit history. No more manual
version bumping or changelog writing!

## 5. Common Mistakes (Yes, I've Made Some)

Adopting this trifecta isn't without its pitfalls. Here are common mistakes I've definitely never made. Nope.

- **Misunderstanding "Public API":** SemVer applies to your defined public API. Refactoring internals without changing
  the public API _shouldn't_ trigger MINOR or MAJOR bumps, regardless of how extensive the changes are.
- **Ignoring BREAKING CHANGE:** Developers sometimes shy away from marking breaking changes correctly, leading to
  unexpected pain for consumers when they upgrade a MINOR version that actually breaks things. Just use the `!` or the
  footer!
- **Inconsistent Conventional Commits:** A messy commit history defeats the purpose. If commits aren't consistently
  formatted, `semantic-release` can't determine the correct version bump. Garbage in, garbage out.
- **CI/CD Misconfiguration:** Forgetting `[skip ci]` in the release commit message can cause infinite release loops.
  Configuring the release branch incorrectly can lead to premature or missed releases.
- **Applying to Pre-`1.0.0` Carelessly:** SemVer treats `0.x.y` releases differently (MINOR bumps can be breaking). Be
  mindful of this during initial development.

## 6. The Monorepo Question: Does SemVer/SR Still Apply?

Semantic Release shines in polyrepo environments where multiple packages depend on each other. Knowing that `library-a`
bumping from `v1.2.3` to `v1.3.0` adds features but isn't breaking is crucial for `service-b` that consumes it.

But what about **monorepos**, especially those practicing **trunk-based development (TBD)** where `main` _is_ the
releasable artifact? It gets... complicated.

- **Single Version vs. Independent:** Do all packages in the monorepo share one version, or are they versioned
  independently?
  - If it's a single version, a `fix:` in one package bumps the _whole_ monorepo's PATCH version. This might be fine, or
    it might feel wrong if unrelated packages get new versions.
  - If versioned independently, `semantic-release` _can_ be configured (using tools like Lerna or its own workspace
    support) to manage per-package releases based on commits affecting specific paths.
- **Trunk-Based Development:** In TBD, every merge to `main` should ideally be releasable. Does semantic versioning
  based on commits since the _last tag_ make sense if you deploy multiple times a day? Maybe not in the traditional
  sense. The focus shifts from tagged releases to continuous delivery off the main branch.
- **Bazel & Build Systems:** Tools like Bazel manage dependencies within the monorepo at the build graph level. They
  often care less about published SemVer artifacts _within_ the repo and more about the integrity of the codebase at a
  specific commit hash on `main`.

**The Verdict?** It depends (the answer developers love!). Applying `semantic-release` to a TBD monorepo _can_ work,
especially for independent package versioning or generating changelogs, but its traditional role might be less critical
compared to polyrepos or monorepos with tagged releases. The specific release strategy (continuous delivery vs. tagged
releases) and the build system heavily influence whether it's the right fit or requires significant adaptation. Bazel
definitely changes the dependency game.

## Conclusion: Worth the Effort?

Semantic Versioning, Conventional Commits, and Semantic Release offer a powerful combination for bringing consistency,
predictability, and automation to your release process. They reduce manual toil, improve communication, and make
dependency management less of a nightmare.

Is it a silver bullet? No. It requires discipline, team buy-in, and careful configuration. You _will_ argue about
whether something is a `fix` or `feat`. You _will_ mess up the commit format occasionally. But is it generally better
than versioning by whim and manually writing changelogs at 2 AM? In my slightly sarcastic, self-deprecating opinion,
absolutely. It tames the chaos, mostly.

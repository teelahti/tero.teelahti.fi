# AGENTS.md

This file provides guidance for AI coding agents working in this repository.

## Project Overview

Personal blog for Tero Teelahti at `https://tero.teelahti.fi`. Built with
**Hugo** using the **PaperMod** theme (git submodule). Deployed to **Google
Firebase Hosting** via GitHub Actions CI/CD.

This is an archive blog with 40 posts from 2011-2016. Content is in Markdown.

## Repository Structure

```
├── hugo.yaml             # Hugo site configuration
├── flake.nix             # Nix flake (dev environment)
├── flake.lock            # Pinned Nix dependencies
├── .envrc                # direnv integration (use flake)
├── content/
│   ├── _index.md         # Home page
│   ├── about.md          # About page
│   ├── archives.md       # Archive listing page
│   ├── search.md         # Search page
│   └── posts/            # Blog posts (40 Markdown files)
├── static/
│   ├── images/           # Blog post images and site assets
│   ├── attachments/      # Downloadable files
│   └── favicon.ico
├── themes/PaperMod/      # Theme (git submodule, do not edit)
├── .github/workflows/
│   └── build-and-deploy.yml  # CI/CD pipeline
├── firebase.json         # Firebase hosting config with redirects
├── .firebaserc           # Firebase project binding
├── Makefile              # Build/run/deploy commands
├── .editorconfig         # Editor formatting rules
└── README.md
```

## Build / Run / Deploy Commands

Requires [Nix](https://nixos.org/) with flakes enabled. Hugo is provided via
the Nix flake -- no manual installation needed.

```sh
# Enter dev shell (or use direnv: `direnv allow`)
nix develop

# Local development server (http://localhost:1313)
make run
# equivalent to: hugo server -D

# Build the site (output to _site/)
make build
# equivalent to: hugo --minify

# Build and deploy to Firebase
make deploy
# equivalent to: hugo --minify && firebase deploy --only hosting
```

### Testing

There is **no test suite**. The only validation is that `hugo --minify` succeeds
without errors. CI runs `nix develop --command hugo --minify` as the sole
quality gate.

To verify changes locally, run `make build` and check for errors. Run
`make run` and inspect the site at `http://localhost:1313`.

## CI/CD Pipeline

GitHub Actions workflow at `.github/workflows/build-and-deploy.yml`:

- **Trigger**: Push to `master` branch
- **Nix**: Installed via `DeterminateSystems/nix-installer-action`,
  cached with `magic-nix-cache-action`
- **Build**: `nix develop --command hugo --minify`
- **Deploy**: Firebase Hosting via `w9jds/firebase-action` using `GCP_SA_KEY`
  secret

## Content Conventions

### Blog Posts

Posts live in `content/posts/` named by their URL slug:

```
content/posts/my-post-slug.md
```

Every post requires this front matter:

```yaml
---
title: "Human-Readable Title"
date: 2016-01-15T00:00:00+00:00
description: "Short description of the post."
tags: [tag1, tag2]
slug: my-post-slug
---
```

- `title`: The display title
- `date`: ISO 8601 format with timezone
- `description`: Quoted string, used for SEO/meta
- `tags`: Array of tags in brackets
- `slug`: URL slug -- **must match the filename** (without `.md`)

### Pages

Pages use front matter with a `url` field:

```yaml
---
title: "About me"
url: /about/
---
```

Special PaperMod layouts: `archives` (year-grouped listing), `search`
(client-side full-text search).

### Content Formatting

- Write in **Markdown** (Goldmark / CommonMark)
- Code blocks: Fenced triple-backtick with language identifier
  (e.g., ` ```csharp `, ` ```yaml `, ` ```sh `)
- Images: Reference via `/images/filename.ext` (files in `static/images/`)
- Image captions: Use HTML `<figure>` and `<figcaption>` tags
- Raw HTML is allowed (`markup.goldmark.renderer.unsafe: true` in config)
- Internal links: Use relative paths (e.g., `/about/`, `/my-post-slug/`)
- External links: Use full URLs with `https://`

## Code Style

### EditorConfig (enforced via `.editorconfig`)

- **Indentation**: 2 spaces (tabs only in Makefile)
- **Line endings**: LF (`\n`)
- **Charset**: UTF-8
- **Trailing whitespace**: Trim (except `.md` and `.svg` files)
- **Final newline**: Required in all files

### YAML Files

- 2-space indentation
- Use lowercase keys
- Quote string values containing special characters

### Markdown

- Lines can be any length (no hard wrapping enforced)
- Trailing whitespace is preserved (`.editorconfig` exemption for `.md`)
- Use blank lines between paragraphs and before/after code blocks
- Use `##` (h2) as the top heading level within post content (h1 is the title)

## Configuration Reference

### `hugo.yaml` Key Settings

- `theme: PaperMod` -- git submodule at `themes/PaperMod/`
- `permalinks.posts: /:slug/` -- URL structure based on slug front matter
- `publishDir: _site` -- output directory (matches Firebase config)
- `params.defaultTheme: dark` -- dark mode by default
- `params.env: production` -- enables SEO meta tags (OpenGraph, Twitter
  Cards, JSON-LD)
- `markup.goldmark.renderer.unsafe: true` -- allows raw HTML in Markdown
- `markup.highlight.style: monokai` -- syntax highlighting theme (Chroma)
- Highlight.js is disabled; Chroma (server-side) is used instead

### `firebase.json`

- Serves from `_site/` directory
- Contains redirect rules for old URL patterns (`/blog/*`, mixed-case slugs)
- Security headers: `X-Content-Type-Options`, `X-Frame-Options`,
  `Referrer-Policy`

## Important Notes for Agents

1. **No JavaScript/TypeScript tooling** -- This is a Hugo project. There is no
   `package.json`, `node_modules`, or JS build step.
2. **No tests to run** -- Validate changes by running `make build` successfully.
3. **Branch**: The default branch is `master` (not `main`).
4. **Deploy trigger**: Any push to `master` triggers automatic build and deploy.
5. **Theme is a git submodule** -- Do not edit files under `themes/PaperMod/`.
   To override, create matching files in `layouts/` or `assets/` directories.
6. **Images** go in `static/images/` (served at `/images/`).
7. **URL slugs matter** -- Every post has an explicit `slug` in front matter
   that must match its filename. Changing slugs breaks existing links and SEO.
8. **Firebase redirects** in `firebase.json` handle old URL patterns; add new
   redirects there if renaming or moving content.
9. **Nix flake** provides the dev environment. Run `nix develop` or use direnv.
   No need to install Hugo manually.

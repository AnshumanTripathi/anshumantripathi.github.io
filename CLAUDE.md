# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal blog ([anshumantripathi.com](https://anshumantripathi.com)) built with [Hugo](https://gohugo.io/) using the `hugo-coder` theme (git submodule). Deployed via Netlify on push to `main`. Comments powered by Utterances (GitHub issues). Search powered by Pagefind.

## Key Commands

```bash
make init              # Initialize git submodules (required after fresh clone)
make serve-local       # Build and serve with local config (no analytics/comments)
make serve-production  # Build and serve with production config
make build-production  # Production build (what Netlify runs)
make clean             # Remove public/ and resources/
```

The build pipeline runs `hugo --gc --minify` then `npx pagefind --site "public"` for search indexing.

## Content Architecture

Content lives in `content/` with these sections:
- `blog/` — main posts (most content lives here)
- `series/` — grouped post series (e.g., `samyak`, `devops`, `career advice`)
- `projects/` — project showcases
- `about.md` — about page

**Post frontmatter fields:**
```yaml
title: ""
date: 2024-01-01T00:00:00-07:00
draft: false          # must be false to publish
categories: []        # e.g., concepts, tutorials, networking
series: []            # ties post to a series
tags: []
math: true            # enables KaTeX math rendering (optional)
```

New posts default to `draft: true` — set to `false` before merging.

## Configuration Layout

Config is split by environment under `config/`:
- `_default/` — base config (applies always): `config.yaml` (site config), no `params.yaml` here
- `local/` — local dev overrides
- `production/` — production params (`params.yaml` has analytics, utterances comments, social links)

The theme is `hugo-coder` (pinned as a git submodule in `themes/hugo-coder/`).

## Custom Layouts and Shortcodes

Overrides to the theme live in `layouts/`:
- `shortcodes/img.html` — image with caption, use `{{< img src="..." caption="..." >}}`
- `shortcodes/sub.html` — subscript text
- `shortcodes/caption.html` — standalone caption
- `partials/footer.html` — custom footer
- `scss/_footer.scss` — footer styles (referenced in `config.yaml` as `customSCSS`)

Static assets (images, diagrams) go in `static/`. Diagrams have their own `static/diagrams/` subdirectory.

## PR Checklist (from `.github/pull_request_template.md`)

- Grammar check
- SEO check
- Tested manually by running production environment (`make serve-production`)
- `draft` set to `false`

## Content Review Criteria

These criteria apply when reviewing PRs that change content under `content/`. Non-content changes (config, layouts, theme, CI) do not require a content review. Format review feedback with one section per criterion below; write "No issues found." for any section that is clean. Be specific: quote the problematic text and explain what needs to change.

### 1. Credit and Attribution (CRITICAL)

**Absolutely no credit misattribution.** This is the most important check.

- Flag any language that implies a concept, discovery, algorithm, or system was invented or first found by the author when it was actually created by others.
- Red-flag phrases: "I discovered", "I found that X works by", "I came up with" — unless the author is genuinely claiming original work.
- Named things (algorithms, papers, systems, protocols) must never be presented as the author's original work. Examples: Bloom filters, Zanzibar, Kubernetes, TCP/IP.
- Every external concept, paper, system, or technique discussed must have a visible attribution — either an inline link, a footnote, or a References section.

### 2. Grammar and Language

- Flag grammatical errors and typos.
- Flag sentence-level semantic issues: sentences that are grammatically correct but say something different from what was intended, or are ambiguous or misleading.

### 3. References and Citations

- Flag factual claims, statistics, quotes, or descriptions of external systems that have no citation.
- Check that inline links and footnotes are present where needed. You cannot fetch URLs, but flag any that look obviously malformed or missing.
- Images must use the `{{</* img src="..." caption="..." */>}}` shortcode with a descriptive caption. Flag images missing captions.

### 4. Hugo Metadata

- `draft` must be `false` for posts being merged to `main`.
- `categories` must be present and use values consistent with the blog (e.g. `concepts`, `tutorials`, `networking`, `my story`).
- `tags` must be present and relevant to the post content.
- `series` should be set if the post belongs to an existing series (`samyak`, `devops`, `career advice`).
- `math: true` must be set if the post contains LaTeX/KaTeX expressions (`$$...$$` or `$...$`).
- Flag missing or likely-incorrect metadata.

---
name: new-post
description: This skill should be used when the user wants to "create a new blog post", "write a new post", "start a new article", "draft a new post", or says "/new-post". Scaffolds a Hugo blog post with full frontmatter.
version: 1.0.0
disable-model-invocation: true
---

# New Blog Post

Scaffold a new blog post for anshumantripathi.com with all required frontmatter.

## Dynamic Context

- Existing series: !`ls content/series/`
- Existing blog posts: !`ls content/blog/`

## Steps

### 1. Gather Post Details

Ask the user the following questions (you can batch them in a single message):

**a. Post title** — what is the post about?

**b. Archetype** — which type fits best? Present these options with brief descriptions:

| Archetype | Best for |
|-----------|----------|
| `concept` | Explaining a technical concept, system, or idea (e.g. Bloom filters, DNS) |
| `tutorial` | Step-by-step how-to guides |
| `story` | Personal narrative, career advice, "my story" posts |
| `project` | Project showcases or open-source writeups |
| `default` | Anything that doesn't fit the above |

**c. Series** — does this post belong to a series? Show the existing series from the dynamic context above and let the user pick one or more, or none. Series options: `samyak`, `devops`, `career advice`.

**d. Categories** — which categories apply? Let the user pick one or more:
- `concepts` — technical concepts
- `tutorials` — how-to guides
- `networking` — networking/infrastructure topics
- `my story` — personal narrative

Suggest the most likely category based on the chosen archetype:
- `concept` → `concepts`
- `tutorial` → `tutorials`
- `story` → `my story`
- `project` → no default, ask

**e. Tags** — suggest 2–4 relevant tags based on the title and archetype, then let the user confirm or adjust. Common tags in use: `theory`, `tools`, `advise`, `devops`, `kubernetes`, `networking`, `career`.

**f. Description** — a one-sentence description/subtitle for the post (used in SEO and as subtitle). Can be left blank for now.

### 2. Derive the Slug

Derive a kebab-case filename from the title:
- Lowercase all words
- Replace spaces with hyphens
- Remove special characters
- Keep it short (3–6 words max)

Example: "How Does DNS Work" → `how-does-dns-work`

### 3. Create the Post

Run:

```
hugo new --kind <archetype> content/blog/<slug>.md
```

From the project root (`/Users/anshumantripathi/anshumantripathi.github.io`).

### 4. Update the Frontmatter

After `hugo new` creates the file, read it and replace its frontmatter with the complete set of fields below. Preserve the `date` field that Hugo injected; do not change it.

The target frontmatter depends on the archetype:

**concept / tutorial:**
```yaml
---
title: "<User's title>"
subtitle: "<description/subtitle from step 1f, or empty string>"
description: "<description from step 1f, or empty string>"
date: <hugo-generated date>
draft: true
series:
- <series if chosen, else omit this field entirely>
categories:
- <chosen categories>
tags:
- <confirmed tags>
featuredImage: "images/<slug>.jpg"
featuredImageCaption: ""
pagefindWeight: "0.1"
aliases:
- /blog/<slug>/
slug: <slug>
---
```

**story:**
```yaml
---
title: "<User's title>"
subtitle: "<description/subtitle from step 1f, or empty string>"
description: "<description from step 1f, or empty string>"
date: <hugo-generated date>
draft: true
series:
- <series if chosen, else omit this field entirely>
categories:
- my story
tags:
- <confirmed tags>
featuredImage: "images/<slug>.jpg"
featuredImageCaption: ""
pagefindWeight: "0.1"
aliases:
- /blog/<slug>/
slug: <slug>
---
```

**project:**
```yaml
---
title: "<User's title>"
description: "<description from step 1f, or empty string>"
date: <hugo-generated date>
draft: true
series:
- <series if chosen, else omit this field entirely>
categories:
- <chosen categories>
tags:
- tools
type: blog
disableDiffblog: true
pagefindWeight: "0.1"
aliases:
- /blog/<slug>/
slug: <slug>
---
```

**default:**
```yaml
---
title: "<User's title>"
description: "<description from step 1f, or empty string>"
date: <hugo-generated date>
draft: true
series:
- <series if chosen, else omit this field entirely>
categories:
- <chosen categories>
tags:
- <confirmed tags>
featuredImage: "images/<slug>.jpg"
featuredImageCaption: ""
pagefindWeight: "0.1"
aliases:
- /blog/<slug>/
slug: <slug>
---
```

Rules:
- If no series was chosen, omit the `series` field entirely.
- If `subtitle` or `description` was left blank, use an empty string `""`.
- `featuredImage` is a placeholder path — the user will fill it in later.
- `aliases` provides a clean URL slug for redirects.
- `draft: true` always — never publish on creation.

### 5. Confirm

Report back to the user:
- The file path created (relative to repo root)
- A summary of the frontmatter that was applied
- Remind them to set `draft: false` before merging to main

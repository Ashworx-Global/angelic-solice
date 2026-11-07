# Solace Creations Static Website — Design

**Date:** 2026-11-07  
**Status:** Draft (pending partner approval)  
**Approach:** Eleventy (11ty) static site + GitHub Actions deploy to GitHub Pages

## Intent and why

Restart this repository’s public presence as a **static website** for **Solace Creations**, published on **GitHub Pages**. The site is a clean, professional, attractive showcase for soaps and soap products to maximize interest in the collection. The owner does not have the final product listing yet, so the site must include a **clear template/process** for adding and updating products, with **mock products** that can be edited/replaced later.

The owner is building a separate ordering site that can be connected later. For now the website is **informational only**: visitors can browse products and learn about the brand, with obvious placeholders/hooks to add ordering links in the future.

## Goals

- Publish a static Solace Creations website to GitHub Pages.
- Use the **Warm Boutique** visual direction (cream/earthy palette, elegant headings, handcrafted feel, product-focused cards).
- Use `Solace creations logo.psd` (repo root) as the branding source by exporting a web-ready logo asset for the site.
- Provide a **data-driven product catalog** (template + mock products) so products can be updated by editing a data file and committing/pushing.
- Keep the implementation simple to maintain (11ty templates + data).
- Build and deploy automatically with **GitHub Actions**.

## Non-goals

- Building checkout, cart, payments, accounts, or order management (handled by the future ordering site).
- Migrating, deleting, or continuing development of the existing Flutter app in `src/angelic_solace/` as part of this change (leave it in place).
- Building a CMS/admin UI. Product updates are file-based in the repo.
- Final copywriting, final photography, or final pricing (mock/placeholder content is acceptable).

## Anti-goals (failure modes)

- Requiring a backend/database to publish or update the catalog.
- Hardcoding mock products in ways that make future updates tedious or error-prone.
- A design that feels cluttered, generic, or untrustworthy, reducing interest in the soaps.
- Adding fake “Buy now” behavior that implies ordering works when it does not.

## Constraints

- **Hosting:** GitHub Pages, static assets only. Target repository: `Ashworx-Global/angelic-solice` (private, confirmed) — expected project site URL `https://ashworx-global.github.io/angelic-solice/` (requires a plan/org setting that supports Pages for private repos, or making the repo public when ready). Deployment method: GitHub Actions.
- **Repository context:** Currently a git repo containing a Flutter app (`src/angelic_solace/`) and `Solace creations logo.psd` at the repo root.
- **Logo source:** PSD is not browser-usable; export to PNG/SVG/WebP (and/or favicon sizes) for the web.
- **Ordering:** Informational for now; future connection via optional per-product or global `order_url`/CTA placeholders.

## Approaches considered

1. **Plain static site (HTML/CSS/JS + `products.json`) — not chosen.** No build step and easy GH Pages publishing, but templates/partials and future growth are more manual. Recommended earlier for simplicity; user chose a generator.
2. **Static site generator with GitHub Actions — chosen (Eleventy/11ty).** Templates + data files, built in CI and deployed to Pages. Fits the “drop/update product info” workflow via a data file while keeping structure maintainable. Adds Node tooling/build workflow.
3. **Minimal split static pages — not chosen.** Still manual structure; less benefit than #2 for a catalog template.

**Decision:** Approach 2 with **Eleventy (11ty)**. 11ty is lightweight, works well with JSON/Markdown/data files and simple templates, and keeps the update process straightforward.

## How it gets made (decided)

- **Brand name:** Solace Creations (matches the logo filename), unless corrected before implementation.
- **Generator:** Eleventy (11ty), Node-based.
- **Site source location (proposed):** `site/` (or `web/`) at repo root for 11ty source, with build output to a gitignored directory such as `_site/`. The existing Flutter app remains under `src/angelic_solace/`.
- **Data template:** `site/_data/products.json` (or equivalent 11ty global data file) containing an array of mock soap/soap-product entries. Templates render product cards/grid from this data.
- **Product fields (template):** `id`/`slug`, `name`, `category` (e.g., bar soap, liquid soap, gift set), `short_description`, `description` or `highlights`/`ingredients` notes (text), `size`, `price` (display string or number), `image` (path/placeholder), `status` (`available` | `coming_soon` | `seasonal`), optional `order_url` (null/empty until ordering site is connected), optional `featured` flag.
- **Pages/sections (initial):** Home (hero, brand intro, featured/mock products, future-ordering note), Collection/Products (all items from data), About (short brand/story placeholder), Contact/Connect area (placeholder links; no working form required for MVP unless trivial static `mailto:`). Navigation consistent with Warm Boutique.
- **Visual direction:** Warm Boutique — cream/earthy palette, elegant serif accent for headings, clean sans-serif body, rounded product cards, generous whitespace, lifestyle/hero image placeholder, “Ordering coming soon / connect later” placeholders (not fake checkout).
- **Logo/assets:** Export `Solace creations logo.psd` to web assets (e.g., `site/assets/images/solace-creations-logo.png` or `.svg` if feasible) and add a favicon/app icon as practical. If automated PSD conversion is unavailable in the environment, document the export step for the owner.
- **Deployment:** `.github/workflows/deploy-pages.yml` (name flexible) that checks out, sets up Node, installs dependencies, runs `npm run build` (11ty), uploads the Pages artifact from the build output, and deploys via `actions/deploy-pages`. Repository Pages source configured for **GitHub Actions**.
- **Repo hygiene:** Update `.gitignore` for `node_modules/`, build output, and local env files. Add `.superpowers/` to `.gitignore` if using the visual companion locally (optional, low risk).

## What’s left to the builder

- Exact 11ty config, template language choice (Nunjucks/Liquid/etc.), and file/folder naming conventions within the chosen source directory.
- Final CSS architecture (single stylesheet vs. modular), responsive breakpoints, and accessibility details (semantic HTML, contrast, focus states, alt text patterns).
- Exact GitHub Actions versions/pinning and Pages permissions configuration details, validated against current GitHub Pages Actions guidance.
- Whether to generate individual product detail pages now or render a single collection view first; either is acceptable if the data template remains easy to update.
- PSD-to-web export method: use available tooling if present; otherwise provide a clear manual export path and leave a non-blocking placeholder asset only if necessary.
- Polishing mock copy/images (placeholders) without changing the template’s editability.
- Any small, sensible additions that improve professionalism (meta tags, Open Graph basics, 404 page) if low effort.

## Risks / notes

- **PSD conversion:** May require manual export by the owner if no converter is installed. The plan should handle this explicitly.
- **GitHub Pages base path:** Project site at `/angelic-solace/` — Eleventy/build config must set the correct base path/prefix so assets and navigation work on GitHub Pages.
- **Private repo Pages availability:** The repo was created as private; the GitHub API reported that the current plan does not support Pages for this private repository. Pages/Actions deploy configuration may need the repo made public or an eligible plan before the site is live.
- **Future ordering integration:** Keep `order_url` and CTA rendering simple so the ordering site can be linked later without redesign.
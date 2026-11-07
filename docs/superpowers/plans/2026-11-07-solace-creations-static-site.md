# Solace Creations Static Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish-ready a static Eleventy (11ty) website for Solace Creations on GitHub Pages, with a Warm Boutique design and a data-file product catalog template populated with mock soaps/products.

**Architecture:** An 11ty site in `site/` (input) builds to gitignored `_site/` (output). Product/catalog content comes from `site/_data/products.json` (mock data, editable template) and brand/contact config from `site/_data/site.json`. Nunjucks templates render an informational home/collection/about/404 experience with `pathPrefix` `/angelic-solice/` for the Ashworx-Global project Pages URL; a GitHub Actions workflow builds and deploys via GitHub Pages Actions.

**Tech Stack:** Node.js + npm, `@11ty/eleventy` (v3), Nunjucks templates, static HTML/CSS, GitHub Actions (`actions/checkout`, `actions/setup-node`, `actions/configure-pages`, `actions/upload-pages-artifact`, `actions/deploy-pages`).

**Spec:** `docs/superpowers/specs/2026-11-07-solace-creations-static-site-design.md` (approved 2026-11-07)

## Global Constraints

- Hosting is GitHub Pages (static assets only), deployed by GitHub Actions; target repo `Ashworx-Global/angelic-solice`, project site URL `https://ashworx-global.github.io/angelic-solice/`.
- **11ty `pathPrefix` must be `/angelic-solice/`** (project-site base path). All internal links/assets must work under that prefix.
- Brand name: **Solace Creations**. Visual direction: **Warm Boutique** (cream/earthy palette, elegant serif headings, clean sans-serif body, rounded product cards, generous whitespace, informational/professional).
- Site is **informational only** now (no checkout/cart/payment). Do **not** add fake “Buy now” behavior. Use “Ordering coming soon” / future-ordering placeholders and optional `order_url` hooks.
- Product catalog must be **data-driven and easy to update**: mock products in an editable data file, not hardcoded across templates.
- Leave existing Flutter app at `src/angelic_solace/` unchanged. PSD source logo remains `Solace creations logo.psd` at repo root; web uses an exported/placeholder web asset.
- `.superpowers/` remains gitignored (local artifacts).

## Review Focus

1. **Project Pages base path:** A page loaded at `/angelic-solice/` with CSS/images/nav links resolving to `/...` instead of `/angelic-solice/...` (or missing 11ty URL filter usage) breaks styling/navigation on GitHub Pages. Expect built HTML to reference assets/links correctly for the configured path prefix.
2. **Fake ordering CTA:** Buttons/links labeled or behaving as live purchasing (cart/checkout/“Buy now” completing an order) on a static informational site mislead visitors. Expect “Ordering coming soon”/placeholder behavior unless `order_url` is explicitly set.
3. **Hardcoded products:** Mock products duplicated in templates instead of sourced from `site/_data/products.json` make future updates error-prone. Expect templates to loop over the data file.
4. **Missing/fragile mock-data fields:** A template that throws or renders blank when `order_url` is null/empty, `featured` absent, or optional text missing makes the update template brittle. Expect safe defaults/guards.
5. **PSD-only logo assumption:** Treating `Solace creations logo.psd` as a browser image or failing when it isn’t converted blocks rendering. Expect a committed web-ready placeholder/logo asset plus a documented manual export path for the PSD.

---

## File Structure

Create/modify (web site only; do not touch `src/angelic_solace/`):

- Create: `package.json` — npm scripts (`build`, `start`/`serve`) and 11ty dependency.
- Create: `eleventy.config.js` — 11ty config: input `site`, output `_site`, includes/data dirs, `pathPrefix: "/angelic-solice/"`, passthrough for assets.
- Modify: `.gitignore` — add `node_modules/`, `_site/`, npm logs/env-local entries (preserve existing `.superpowers/`).
- Create: `site/_data/site.json` — brand name, tagline, navigation, contact placeholders, `orderingNote`.
- Create: `site/_data/products.json` — array of mock products matching the template fields.
- Create: `site/_includes/layouts/base.njk` — shared HTML shell, meta, nav, footer, CSS include.
- Create: `site/_includes/partials/product-card.njk` (optional but recommended) — reusable card rendering with safe `order_url` handling.
- Create: `site/assets/css/styles.css` — Warm Boutique theme + responsive layout.
- Create: `site/assets/images/solace-creations-logo.svg` — web-ready placeholder logo asset (replace with export from `Solace creations logo.psd`).
- Create: `site/assets/images/product-placeholder.svg` — simple placeholder product image.
- Create: `site/index.njk` — home/hero/featured products/future-ordering note.
- Create: `site/collection.njk` — full catalog from `products.json`.
- Create: `site/about.njk` — short brand placeholder.
- Create: `site/404.njk` — simple not-found page.
- Create: `.github/workflows/deploy-pages.yml` — GitHub Actions build + deploy-pages workflow.
- Create: `site/README.md` (or `docs/website-content-template.md`) — how to update `products.json` and export the PSD logo.

## Data Contracts (exact)

`site/_data/site.json` fields: `name` ("Solace Creations"), `tagline`, `description`, `url` ("https://ashworx-global.github.io/angelic-solice/"), `orderingNote` ("Ordering will be available through our ordering site soon."), `nav` array of `{ "label","url" }`, `contact` object with editable placeholders `{ "email","instagram","facebook","note" }` (values may be empty strings/TODO placeholders).

`site/_data/products.json` array entries: `id`, `slug`, `name`, `category`, `short_description`, `description` (or `highlights`), `size`, `price`, `image` (path under site assets or placeholder), `status` (`available`|`coming_soon`|`seasonal`), `order_url` (`null` or URL string), `featured` (boolean). Include at least **3 mock products** across soap categories; keep realistic placeholder text.

---

### Task 1: Scaffold 11ty project and repo hygiene

**Files:**
- Create: `package.json`
- Create: `eleventy.config.js`
- Modify: `.gitignore`

**Interfaces:**
- Produces: `npm run build` runs Eleventy with input `site` -> output `_site` and `pathPrefix` `/angelic-solice/`; `npm run start` runs Eleventy dev server. Git ignores `node_modules/` and `_site/`.

- [ ] **Step 1: Write a failing build expectation (no site yet)**

Run: `npm run build` in `C:\Dev\angelic-solice`
Expected: FAIL because `package.json`/scripts or 11ty config/site do not exist yet (missing script or missing config/input). Record the actual error.

- [ ] **Step 2: Create `package.json`**

Create `package.json` with at least:
```json
{
  "name": "angelic-solace-site",
  "private": true,
  "scripts": {
    "build": "eleventy",
    "start": "eleventy --serve"
  },
  "devDependencies": {
    "@11ty/eleventy": "^3.0.0"
  }
}
```

- [ ] **Step 3: Create minimal `eleventy.config.js` and `site/index.njk` placeholder**

`eleventy.config.js` must export a config that sets:
```js
export default function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("site/assets");
  return { pathPrefix: "/angelic-solice/", dir: { input: "site", output: "_site", includes: "_includes", data: "_data" } };
}
```
Create `site/index.njk` with minimal HTML containing `Solace Creations` so a build can succeed.

- [ ] **Step 4: Install dependencies and run build to verify it passes**

Run: `npm install` then `npm run build`
Expected: PASS; `_site/index.html` generated and contains `Solace Creations`. Verify prefix-aware behavior is configurable (inspect generated links later tasks).

- [ ] **Step 5: Update `.gitignore` and verify ignored outputs**

Append entries: `node_modules/`, `_site/`, `npm-debug.log*`, `.env`, `.env.*` (do not remove existing entries including `.superpowers/`). Run: `git -C C:\Dev\angelic-solice status --short`
Expected: `node_modules/` and `_site/` do not appear as untracked (or are ignored).

- [ ] **Step 6: Commit**

```bash
git add package.json package-lock.json eleventy.config.js site/index.njk .gitignore
git commit -m "chore: scaffold eleventy site for Solace Creations"
```

### Task 2: Product and site data templates (mock catalog)

**Files:**
- Create: `site/_data/site.json`
- Create: `site/_data/products.json`
- Create: `site/_data/README-products-template-check.md` (optional) — or skip; verification is the build/output check.
- Modify: `site/index.njk` (temporary data-render check)

**Interfaces:**
- Consumes: 11ty global data loading from `site/_data/`.
- Produces: `products` array and `site` data available to templates. Mock catalog includes >=3 items and fields: `id, slug, name, category, short_description, description/highlights, size, price, image, status, order_url, featured`.

- [ ] **Step 1: Write the failing data-render check**

Update `site/index.njk` temporarily to render `{{ site.name }}` and loop `products` printing each `name`. Run: `npm run build`
Expected: FAIL or output missing mock names because `site/_data/site.json`/`products.json` do not exist or are empty.

- [ ] **Step 2: Create `site/_data/site.json` with exact brand/config fields**

Include: `name: "Solace Creations"`, `tagline`, `description`, `url: "https://ashworx-global.github.io/angelic-solice/"`, `orderingNote: "Ordering will be available through our ordering site soon."`, `nav` (`Home` `/`, `Collection` `/collection/`, `About` `/about/`, `Contact` `/#contact` or `/about/#contact`), `contact` placeholders (`email`, `instagram`, `facebook`, `note` with TODO text).

- [ ] **Step 3: Create `site/_data/products.json` with >=3 mock products**

Provide realistic mock entries (examples): a bar soap, a specialty bar, a soap product/gift item. Every entry has all template fields; set `order_url` to `null`; mix `featured` true/false and valid `status` values. Use `image` paths like `/assets/images/product-placeholder.svg` (or placeholder path to be added in Task 3).

- [ ] **Step 4: Run build and verify data appears in output**

Run: `npm run build`
Then verify: `Select-String -Path C:\Dev\angelic-solice\_site\index.html -Pattern 'Solace Creations','Ordering will be available','Lavender'` (or the actual mock names you used)
Expected: PASS; all patterns found.

- [ ] **Step 5: Commit**

```bash
git add site/_data/site.json site/_data/products.json site/index.njk
git commit -m "feat: add editable site config and mock product catalog data"
```

### Task 3: Warm Boutique base layout, styles, and web assets

**Files:**
- Create: `site/_includes/layouts/base.njk`
- Create: `site/_includes/partials/product-card.njk`
- Create: `site/assets/css/styles.css`
- Create: `site/assets/images/solace-creations-logo.svg`
- Create: `site/assets/images/product-placeholder.svg`
- Modify: `site/index.njk` (use layout)

**Interfaces:**
- Consumes: `site` and `products` global data.
- Produces: shared layout with semantic header/nav/main/footer, accessible structure, responsive Warm Boutique styling, and web-ready logo/product placeholders. Product card renders `order_url` only as a future/connect placeholder or external link when explicitly non-empty and safe to show; default informational state shows no fake buy action.

- [ ] **Step 1: Write failing layout/style checks**

Expect `_site/index.html` to include a stylesheet link containing `assets/css/styles.css` (path-prefix compatible) and a header/nav with `Solace Creations`. Run build after changing `site/index.njk` to use `layout: layouts/base.njk` before creating layout.
Expected: FAIL (layout not found / missing CSS link).

- [ ] **Step 2: Implement `base.njk` layout**

Include `<!doctype html>`, `<html lang="en">`, meta charset/viewport, `<title>` using page title + `site.name`, meta description from page or `site.description`, stylesheet link using `{{ '/assets/css/styles.css' | url }}` (11ty `url` filter respects `pathPrefix`), header with logo image + nav from `site.nav` (`{{ item.url | url }}`), `<main>{{ content | safe }}</main>`, footer/contact area using `site.contact` placeholders and `site.orderingNote`.

- [ ] **Step 3: Implement `product-card.njk` partial and Warm Boutique `styles.css`**

Card shows image, name, category/status (optional), `short_description`, size/price, and informational CTA: if `product.order_url` is truthy, render a clearly labeled external “Order / View ordering” link placeholder behavior only as a normal link (no cart); else render non-interactive/placeholder “Ordering coming soon”. Apply Warm Boutique tokens (cream/earthy background, serif headings, sans body, rounded cards, focus states, responsive grid/stack, sufficient contrast).

- [ ] **Step 4: Add SVG logo and product placeholders**

Create a simple, professional SVG placeholder logo reading **Solace Creations** in `solace-creations-logo.svg` (web-ready, committed). Create `product-placeholder.svg`. Add a short note in `site/README.md` or root note: export `Solace creations logo.psd` manually to replace `site/assets/images/solace-creations-logo.svg`/PNG as desired.

- [ ] **Step 5: Run build and verify base output**

Run: `npm run build`
Verify: `Select-String -Path _site\index.html -Pattern 'styles.css','Solace Creations','/angelic-solace/'`
Expected: PASS (path prefix present in generated asset/nav references as appropriate).

- [ ] **Step 6: Commit**

```bash
git add site/_includes site/assets site/index.njk site/README.md
git commit -m "feat: add Warm Boutique layout, styles, and placeholder assets"
```

### Task 4: Pages and catalog rendering

**Files:**
- Modify: `site/index.njk`
- Create: `site/collection.njk`
- Create: `site/about.njk`
- Create: `site/404.njk`

**Interfaces:**
- Consumes: layout, `site` data, `products` array, product partial.
- Produces: Home with hero + featured/mock products + ordering note; Collection listing all products from data; About/contact placeholder; 404. No hardcoded product catalog entries in page bodies except structural copy.

- [ ] **Step 1: Write failing page/build checks**

Before creating pages, check they don’t exist in output: `_site/collection/index.html` absent. Expected: absent/fail check.

- [ ] **Step 2: Implement `index.njk` (home)**

Use base layout. Render hero (brand intro + `site.orderingNote`), featured products (`products | where featured` or equivalent filter/loop guard) falling back to first items, and CTA links to collection. Use `| url` for internal links.

- [ ] **Step 3: Implement `collection.njk`**

Front matter: `layout`, `title: Collection` (or “Soap Collection”), permalink/path as desired. Loop all `products` and render `product-card` partial for each. Add intro copy explaining products can be updated in `site/_data/products.json` (brief, owner-facing visible copy optional; at minimum maintain data-driven rendering).

- [ ] **Step 4: Implement `about.njk` and `404.njk`**

About includes brand/story placeholder and contact placeholders from `site.contact` with clear TODO/edit guidance; no fake form submission required. 404 is friendly, links home via `{{ '/' | url }}`.

- [ ] **Step 5: Run build and verify all pages/data rendering**

Run: `npm run build`
Verify patterns:
```powershell
Select-String -Path _site\index.html,_site\collection\index.html,_site\about\index.html -Pattern 'Solace Creations'
Select-String -Path _site\collection\index.html -Pattern '<mock product name 1>','<mock product name 2>','Ordering coming soon'
```
Expected: PASS; collection contains all mock names sourced from data; no “Buy now”/cart text.

- [ ] **Step 6: Commit**

```bash
git add site/index.njk site/collection.njk site/about.njk site/404.njk
git commit -m "feat: add home, collection, about, and 404 pages"
```

### Task 5: GitHub Actions Pages deployment workflow and update docs

**Files:**
- Create: `.github/workflows/deploy-pages.yml`
- Modify: `site/README.md` (or create `docs/website-content-template.md`)
- Modify: `docs/superpowers/specs/2026-11-07-solace-creations-static-site-design.md` status line only if desired (optional: mark Approved)

**Interfaces:**
- Produces: workflow that triggers on push to `master` (and optionally `workflow_dispatch`), sets Pages permissions (`contents: read`, `pages: write`, `id-token: write`), uses concurrency group `pages`, builds with Node, uploads `_site` artifact, deploys with `deploy-pages`. Docs explain: edit `site/_data/products.json`, replace logo export, and private-repo Pages plan limitation.

- [ ] **Step 1: Write failing workflow check**

Verify `.github/workflows/deploy-pages.yml` does not exist. Expected: absent.

- [ ] **Step 2: Create `deploy-pages.yml`**

Use current standard Pages Actions pattern (pin major versions, e.g. `actions/checkout@v4`, `actions/setup-node@v4`, `actions/configure-pages@v5`, `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4` unless repo conventions require different; adjust only if needed). Build steps: `npm ci` (requires lockfile committed) and `npm run build`. Upload path: `_site`. Ensure `configure-pages` is included if using its recommended setup.

- [ ] **Step 3: Document the update template process**

In `site/README.md` document: where to edit products (`site/_data/products.json`), required/optional fields, how to add images, how to set `order_url` later, and how to export `Solace creations logo.psd` to replace `site/assets/images/solace-creations-logo.svg`. Mention GitHub Pages private-repo availability caveat.

- [ ] **Step 4: Run build and validate workflow file parses as YAML (basic)**

Run: `npm run build` (must still pass). Basic YAML sanity: `node -e "require('fs').readFileSync('.github/workflows/deploy-pages.yml','utf8')"` (presence/readable) or `Get-Content` check; full YAML lint only if tool available.
Expected: build PASS; workflow file present.

- [ ] **Step 5: Commit**

```bash
git add .github/workflows/deploy-pages.yml site/README.md package-lock.json
git commit -m "ci: add GitHub Pages workflow and content update guide"
```

### Task 6: Final verification and handoff

**Files:**
- Modify: none expected (fixups only)

**Interfaces:**
- Consumes: all prior tasks.
- Produces: clean build, verified catalog rendering and path prefix, committed site on `master` ready to push.

- [ ] **Step 1: Run full clean-ish verification**

Run:
```powershell
npm run build
if (!(Test-Path _site\index.html)) { throw "missing build output" }
Select-String -Path _site\index.html -Pattern 'Solace Creations','Warm|styles.css' -SimpleMatch:$false
Select-String -Path _site\collection\index.html -Pattern 'Ordering coming soon'
```
Expected: PASS.

- [ ] **Step 2: Review git status for unintended files**

Run: `git status --short`
Expected: no `node_modules/`, no `_site/`, no `.superpowers/`; only intentional source/docs files if any remain.

- [ ] **Step 3: Push if approved by user context**

Run: `git push origin master`
Expected: remote updated. If push/auth fails, report clearly.

- [ ] **Step 4: Report completion**

Report: what was built, how to run locally (`npm install`, `npm run start`), how to update products (`site/_data/products.json`), logo export note (`Solace creations logo.psd`), Pages caveat for private repo, and next step (connect `order_url` values when ordering site is ready).

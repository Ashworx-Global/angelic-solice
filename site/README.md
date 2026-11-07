# Solace Creations Website (content template)

This folder contains the Eleventy (11ty) source for the Solace Creations static site.

## Update products (template process)

Edit **`site/_data/products.json`** to add or update soaps and soap products. Each item is a JSON object in the array.

Recommended fields:
- `id` / `slug`: stable unique identifier (used for future links/keys)
- `name`: product name
- `category`: e.g. `Bar soap`, `Liquid soap`, `Gift set`
- `short_description`: short card text
- `description`: longer details/highlights/ingredients notes (optional but supported)
- `size`: display size/weight/count (e.g. `4.5 oz`, `Set of 3`)
- `price`: display price (e.g. `$8.00`)
- `image`: image path (e.g. `/assets/images/my-soap.jpg`; place files in `site/assets/images/`)
- `status`: `available`, `coming_soon`, or `seasonal`
- `order_url`: `null` for now; set to a full URL when your ordering site is ready
- `featured`: `true` to show on the home page

The site is **informational**. When `order_url` is `null`, the UI shows **“Ordering coming soon”** (no fake checkout). When you connect the ordering site later, set `order_url` per product.

## Update site/contact info

Edit **`site/_data/site.json`** for brand text, navigation, the global ordering note, and contact placeholders (email/Instagram/Facebook/TODO values).

## Logo (from PSD)

The branding source file is **`Solace creations logo.psd`** in the repository root. Web browsers cannot use PSD files directly. Export the PSD to a web format (SVG preferred if available, otherwise PNG/WebP) and replace:
- `site/assets/images/solace-creations-logo.svg` (or update the layout to point to your exported file).

## Local development

```bash
npm install
npm run start   # local dev server
npm run build   # builds static output to _site/
```

## GitHub Pages

The repo includes `.github/workflows/deploy-pages.yml` to build and deploy `_site/` via GitHub Actions. The expected project site URL is `https://ashworx-global.github.io/angelic-solice/` (Eleventy `pathPrefix` is set to `/angelic-solice/`). If the repository is private, GitHub Pages may require an eligible plan or making the repository public.

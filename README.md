# wwkong.github.io

Personal academic & engineering website for Weiwei "William" Kong, built with [Astro](https://astro.build), Tailwind CSS, MDX, and build-time KaTeX math rendering.

## Local Development

Requires Node.js 20+.

```bash
npm install
npm run dev      # local dev server at http://localhost:4321
npm run build    # production build to dist/
npm run preview  # preview built site locally
```

## Content Locations

- **Publications**: `src/data/publist.yml` + PDFs in `public/files/publications/`
- **Blog posts**: `src/content/posts/` (`.md` / `.mdx`)
- **Software**: `src/content/software/`
- **Course notes**: `src/data/notes.yml` + PDFs in `public/files/notes/`
- **Resume**: `public/files/resume_williamkong.pdf`
- **Homepage / Bio / News / Giscus**: `src/data/site.ts`

## Deployment

Deployed automatically to GitHub Pages via `.github/workflows/deploy.yml` on push to `master`.

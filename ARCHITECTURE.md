# Tech Learning Hub

Educational platform for Technology and Programming resources.

## Architecture

- `src/app`: routing and page composition
- `src/modules`: feature modules
- `src/content`: local educational content
- `src/shared`: reusable UI, hooks, utilities and types
- `src/infrastructure`: repositories, storage and future Supabase adapters
- `public/guides`: legacy/static HTML guides during migration
- `public/images`: static images

## Current grades

6th through 11th Grade.

## Commands

```bash
npm run dev
npm run build
npm run lint
```

## Data strategy

Phase 1 uses local TypeScript content.
A later phase will replace local repositories with Supabase repositories
without coupling UI components directly to the database.

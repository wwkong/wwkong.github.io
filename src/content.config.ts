import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const posts = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/posts' }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    slug: z.string(),
    description: z.string().optional(),
    difficulty: z.string().optional(),
    tags: z.array(z.string()).default([]),
    series: z.string().optional(),
    seriesOrder: z.number().optional(),
  }),
});

const software = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/software' }),
  schema: z.object({
    title: z.string(),
    order: z.number(),
    software_url: z.string().url(),
    repo_url: z.string().url().optional(),
    language: z.string().optional(),
    role: z.string().optional(),
    tags: z.array(z.string()).default([]),
    description: z.string(),
    snippet: z.string().optional(),
  }),
});

export const collections = { posts, software };

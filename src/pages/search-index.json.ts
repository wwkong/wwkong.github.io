import fs from 'node:fs';
import path from 'node:path';
import yaml from 'js-yaml';
import { getCollection } from 'astro:content';
import type { APIRoute } from 'astro';
import type { Publication } from '../components/PublicationList.astro';

export const GET: APIRoute = async () => {
  const posts = await getCollection('posts');
  const software = await getCollection('software');

  const pubRaw = fs.readFileSync(path.join(process.cwd(), 'src/data/publist.yml'), 'utf-8');
  const publications = yaml.load(pubRaw) as Publication[];

  const notesRaw = fs.readFileSync(path.join(process.cwd(), 'src/data/notes.yml'), 'utf-8');
  const notesData = yaml.load(notesRaw) as {
    institutions: Array<{
      name: string;
      departments: Array<{
        name: string;
        courses: Array<{ term: string; code: string; title: string; notes?: string }>;
      }>;
    }>;
  };

  const index = [
    ...posts.map((p) => ({
      title: p.data.title,
      url: `/${p.data.slug}/`,
      kind: 'Blog',
      meta: p.data.description || p.data.tags.join(', '),
      keywords: `${p.data.tags.join(' ')} ${p.data.series ?? ''} ${p.data.difficulty ?? ''}`,
    })),
    ...publications.map((p) => ({
      title: p.title,
      url: `/publications/#${p.url || p.id || ''}`,
      kind: 'Paper',
      meta: `${p.authors} (${p.year})`,
      keywords: `${p.display.replace(/<[^>]+>/g, '')} ${(p.tags ?? []).join(' ')} ${p.arxiv ?? ''}`,
    })),
    ...software.map((s) => ({
      title: s.data.title,
      url: '/software/',
      kind: 'Software',
      meta: `${s.data.language ?? ''} — ${s.data.description.slice(0, 120)}`,
      keywords: s.data.tags.join(' '),
    })),
    ...notesData.institutions.flatMap((inst) =>
      inst.departments.flatMap((dept) =>
        dept.courses.map((c) => ({
          title: `${c.code}: ${c.title}`,
          url: c.notes || '/notes/',
          kind: 'Notes',
          meta: `${inst.name} · ${dept.name} (${c.term})`,
          keywords: `${c.code} ${dept.name} ${inst.name}`,
        }))
      )
    ),
  ];

  return new Response(JSON.stringify(index), {
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
  });
};

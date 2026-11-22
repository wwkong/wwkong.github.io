export const SITE = {
  name: 'William Kong',
  fullName: 'Weiwei "William" Kong',
  title: 'William Kong — Research Software Engineer',
  description:
    'Personal homepage of Weiwei "William" Kong, Research Software Engineer at Google Research (NYC). Research in differential privacy, synthetic data & LLMs, and nonconvex composite optimization.',
  url: 'https://wwkong.github.io',
  role: 'Research Software Engineer',
  affiliation: 'Google Research (NYC)',
  team: 'Athena',
  location: 'New York City, NY',
  avatar: '/images/profile.jpg',
  email: 'wwkong92@gmail.com',
  gaMeasurementId: 'G-RLJHNSFB7P',
  giscus: {
    repo: 'wwkong/wwkong.github.io',
    repoId: 'MDEwOlJlcG9zaXRvcnkxOTI4MzQxNw==',
    category: 'Announcements',
    categoryId: 'DIC_kwDOASY92c4DLvis',
  },
  socials: [
    {
      label: 'Google Scholar',
      href: 'https://scholar.google.com/citations?user=2YtN42MAAAAJ',
      icon: 'scholar',
    },
    {
      label: 'GitHub',
      href: 'https://github.com/wwkong',
      icon: 'github',
    },
    {
      label: 'ORCID',
      href: 'https://orcid.org/0000-0002-4700-619X',
      icon: 'orcid',
    },
    {
      label: 'Email',
      href: 'mailto:wwkong92@gmail.com',
      icon: 'email',
    },
  ],
  nav: [
    { label: 'About', href: '/' },
    { label: 'Blog Posts', href: '/year-archive/' },
    { label: 'Publications', href: '/publications/' },
    { label: 'Software', href: '/software/' },
    { label: 'Course Notes', href: '/notes/' },
    { label: 'Resume', href: '/resume/' },
  ],
} as const;

export const RESEARCH_PILLARS = [
  {
    title: 'Differential Privacy & Scalable DP-ML',
    tag: 'Differential Privacy',
    summary:
      'Fast per-example gradient clipping, privacy auditing (DP-Auditorium), non-decomposable DP optimization, and production DP libraries in JAX (JAX-Privacy).',
    links: [
      { label: 'Filter Papers', href: '/publications/?tag=Differential+Privacy' },
    ],
  },
  {
    title: 'Synthetic Data & LLM Training',
    tag: 'Synthetic Data & LLMs',
    summary:
      'Escaping model collapse with weak data, limitations of ERM on synthetic corpora, private prediction for synthetic text, and ContinuousBench.',
    links: [
      { label: 'Filter Papers', href: '/publications/?tag=Synthetic+Data+%26+LLMs' },
    ],
  },
  {
    title: 'Nonconvex Composite Optimization',
    tag: 'Nonconvex Optimization',
    summary:
      'Accelerated proximal, penalty, spectral, and augmented Lagrangian solvers with certified stationarity bounds—implemented in Proxax (JAX) and NC-OPT.',
    links: [
      { label: 'Filter Papers', href: '/publications/?tag=Nonconvex+Optimization' },
      { label: 'Explore Proxax', href: 'https://proxax.readthedocs.io/en/latest/' },
    ],
  },
] as const;

export const RECENT_NEWS = [
  {
    date: 'Nov 2026',
    text: 'Released Proxax — a library of certified composite optimization solvers in JAX and Optax.',
    href: '/software/',
  },
  {
    date: 'Aug 2026',
    text: 'New preprint: A Mini-Batch Counterexample to Last-Iterate Convergence in Definable Optimization.',
    href: '/publications/#minibatch_counterexample',
  },
  {
    date: 'Jul 2026',
    text: 'ContinuousBench accepted to the ICML 2026 Workshop on Memorization in Trustworthy Foundation Models.',
    href: '/publications/#continuous_bench',
  },
  {
    date: 'Feb 2026',
    text: 'Released preprints on JAX-Privacy and Coarse-to-Fine Wavelet Modeling for Private Image Generation.',
    href: '/publications/#jax_privacy',
  },
  {
    date: 'Jan 2026',
    text: 'Escaping Collapse: The Strength of Weak Data for Large Language Model Training published at NeurIPS 38.',
    href: '/publications/#escaping_collapse',
  },
  {
    date: 'Apr 2025',
    text: 'Differentially Private Optimization for Non-Decomposable Objective Functions accepted to ICLR 2025.',
    href: '/publications/#dp_nondecomposable',
  },
] as const;

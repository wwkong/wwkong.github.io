---
title: Proxax
order: 1
software_url: https://proxax.readthedocs.io/en/latest/
repo_url: https://github.com/wwkong/proxax
language: Python / JAX
role: Author
tags:
- JAX
- Optax
- Nonconvex Optimization
- Certified Solvers
description: A library of certified first-order proximal, spectral, penalty, and augmented Lagrangian solvers for smooth, nonsmooth, and constrained optimization in JAX and Optax, covering both convex and nonconvex objectives. Key features include PyTree-native support, end-to-end compilation and differentiation (`jax.jit`, `jax.vmap`, `px.implicit_solve`), exact stationarity and KKT residual certificates, and first-class Optax interoperability.
snippet: "import jax.numpy as jnp\nfrom proxax import px\n\ndef smooth_fn(x):\n  return 0.5 * jnp.sum((x - 1.5) ** 2)\n\nproblem = px.CompositeProblem(\n    smooth=smooth_fn,\n    proximal=px.prox.L1(weight=0.2),\n)\nsol = px.solve(problem, x0=jnp.zeros(4), solver=px.solvers.APD(opt_tol=1e-6))\nprint(sol.status_enum.name, sol.x)"
---

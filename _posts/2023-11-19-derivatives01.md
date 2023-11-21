---
title: Derivatives (Part I)
date: 2023-11-19
tags: 
  - mathematics
  - calculus
use_math: true
---

**Difficulty**: Undergraduate Students

Multivariate calculus has always been a core part of any mathematics degree, but is often taught through computation or simplified assumptions instead of foundational abstractions. In this series of posts, I describe *a few* of the key concepts that were glanced over in my undergraduate studies, but carefully scrutinized during my graduate studies. I will assume that readers are familiar with the material in an introductory multivariate calculus class.

A good portion of the material below can be found in Chapter 3 of *Iterative solution of nonlinear equations in several variables* by J. M. Ortega and W. C. Rheinboldt. A more in-depth presentation can be found in Appendix A of *Lectures on Modern Convex Optimization* by A. Ben-Tal and A. Nemirovski

# The Fréchet derivative: robust and standard

We start our series with the "canonical" definition of a derivative in higher dimensions. A function $f:\mathbb{R}^{n}\mapsto\mathbb{R}^{m}$ is said to have a **Fréchet** (or **F-**) **derivative** **at** $x\in\mathbb{R}^{n}$ for a given norm $$\|\cdot\|$$ if there exists a (unique) linear operator $${\cal A}_{x}^{f}:\mathbb{R}^{n}\mapsto\mathbb{R}^{m}$$, called the F-derivative, that satisfies the relation 

$$
(\alpha)\qquad\lim_{\Delta\to0}\frac{\left\Vert f(x+\Delta)-[f(x)+{\cal A}_{x}^{f}(\Delta)]\right\Vert }{\|\Delta\|}=0
$$

where the limit is taken over all subsequences $$\{\Delta_{n}\}\subseteq\mathbb{R}^{n}$$ tending to zero. Notice that this is a natural generalization of the one-dimensional case where we replace absolute value errors with norm errors. 

Before giving more definitions, let us discuss some nuances and implications of the above definition.

-   In general, the definition of ${\cal A}_{x}^{f}$ is non-constructive.

-   $${\cal A}_{x}^{f}$$ is linear in its $f$ parameter, i.e., $${\cal A}_{x}^{\lambda(f_{1}+f_{2})}=\lambda({\cal A}_{x}^{f_{1}}+{\cal A}_{x}^{f_{2}})$$.

-   In the one-dimensional case ($n=m=1$), the F-derivative and derivative coincide in the sense that ${\cal A}_{x}^{f}(\delta)=\delta f'(x)$ for $\delta\in\mathbb{R}$.

-   The F-derivative is independent of different choices of the norm $$\|\cdot\|$$. This follows from the fact that for two norms $$\|\cdot\|$$ and $$\|\cdot\|'$$ in $\mathbb{R}^{n}$, there always exist constants $c_{1}>0$ and $c_{2}\geq c_{1}$ such that 

$$c_{1}\|x\|\leq\|x\|'\leq c_{2}\|x\|\quad\forall x\in\mathbb{R}^{n}.$$

In other works of literature, we might see the following variations and applications.

-   The definition in $(\alpha)$ may be equivalently written as 

$$\lim_{y\to x}\frac{\left\Vert f(y)-[f(x)+{\cal A}_{x}^{f}(y-x)]\right\Vert }{\|y-x\|}=0$$ 

where the limit is over all subsequences $$\{y_{n}\}$$ going to $x$. (*Prove this as a simple exercise*!)

-   $${\cal A}_{x}^{f}(\Delta)$$ may be written as $Df(x)[\Delta]$, $Df_{x}(\Delta)$, or $f'(x)\Delta$ to emphasize the dependence on $f$ and $x$.

-   In optimization theory, the term $f(x)+{\cal A}_{x}^{f}(\Delta)$ is often called the **first-order approximation of $f$ at $x$**.

Once we have the above definition of a derivative, we can make the several follow-up definitions. The function $f$ is **Fréchet** (or **F-**) **differentiable at $x$** if its F-derivative ${\cal A}_{x}^{f}$ exists. Consequently, the function $f$ is **Fréchet** (or **F-**) **differentiable** or has **Fréchet** (or **F-**) **differentiability** if it is F-differentiable at all points in $\mathbb{R}^{n}$.

Some important properties that are unique to F-differentiability are as follows.

-   If $f$ is F-differentiable at $x$ then $f$ is **continuous** at $x$, i.e., $\lim_{\bar{x}\to x}f(\bar{x})=f(x)$.

-   The set $$\{f(x)+{\cal A}_{x}^{f}(\Delta):\Delta\in\mathbb{R}^{n}\}$$ is a tangent plane of $f$ at $x$.

Finally, some important anti-properties of F-derivatives and F-differentiability are as follows.

-   The subsequences $$\{\Delta_{n}\}$$ **need not** lie on a line, e.g., like in the definition of a **partial derivative** $\partial f_{i}/\partial x_{j}$.

-   In fact, the existence of the partial derivatives at $x$ **is generally not** sufficient to conclude F-differentiability at $x$.

    -   *Exercise*. Consider the function 

    $$(\gamma_{1})\qquad f(x_{1},x_{2})=\begin{cases}
        x_{1}, & \text{if }x_{2}=0,\\
        x_{2}, & \text{if }x_{1}=0,\\
        1, & \text{otherwise},
        \end{cases}$$ 

    at zero. Show that the partial derivatives of $f$ exist at zero, but the function itself is not F-differentiable.
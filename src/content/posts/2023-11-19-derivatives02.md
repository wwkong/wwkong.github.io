---
title: Derivatives (Part II)
date: '2023-11-19'
slug: derivatives02
description: 'The Gateaux derivative: hemicontinuity, Jacobians, the Riesz-Fréchet
  gradient, chain rule, and counterexamples.'
difficulty: Undergraduate Students
tags:
- mathematics
- calculus
series: Derivatives
seriesOrder: 2
---

Often, we do not need full F-differentiability of a multivariate function $f:\mathbb{R}^{n}\mapsto\mathbb{R}$ to derive interesting results about $f$. Below, we describe a weaker notion of differentiability and its intriguing properties.

# The Gateaux derivative: loose but more flexible

The next stop on our journey is a weaker, but related notion of a derivative. A function $f:\mathbb{R}^{n}\mapsto\mathbb{R}^{m}$ is said to have a **Gateaux** (or **G-**) **derivative** **at** $x\in\mathbb{R}^{n}$ for a given norm $\|\cdot\|$ if there exists a (unique) linear operator ${\cal B}_{x}^{f}:\mathbb{R}^{n}\mapsto\mathbb{R}^{m}$, called the G-derivative, that satisfies the relation 

$$
(\beta)\qquad\lim_{t\downarrow0}\frac{\left\Vert f(x+t\Delta)-[f(x)+{\cal B}_{x}^{f}(t\Delta)]\right\Vert }{t}=0\quad\forall\Delta\in\mathbb{R}^{n}
$$

where the limit is taken over all positive sequences $\{t_{n}\}\subseteq\mathbb{R}_{+}$ tending to zero.

Like in the previous post, let us discuss a few nuances and implications of the above definition.

-   In general, the definition of ${\cal B}_{x}^{f}$ is non-constructive.

-   ${\cal B}_{x}^{f}$ is linear in its $f$ parameter, i.e., ${\cal B}_{x}^{\lambda(f_{1}+f_{2})}=\lambda({\cal B}_{x}^{f_{1}}+{\cal B}_{x}^{f_{2}})$.

-   Compared to the F-derivative, the sequences in the G-derivative are restricted to sequences $\{t_{n}\Delta\}$ which lie on a line emanating from the origin.

-   In the one-dimensional case ($n=m=1$), the F-derivative and G-derivative coincide.

-   Similar to the F-derivative, the G-derivative is independent of different choices of the norm $\|\cdot\|$ (for the same reasons).

Some works may have the same notation for the Fréchet and Gateaux derivatives, while others may prefer $D_{x}f(x)[\Delta]$ for Fréchet and $Df(x)[\Delta]$ for Gateaux. The two notions may be related as follows.

-   If $f$ has an F-derivative ${\cal A}_{x}^{f}$ at $x$ then (i) it also has a G-derivative ${\cal B}_{x}^{f}$ at $x$, and (ii) ${\cal A}_{x}^{f}={\cal B}_{x}^{f}$.

-   If $f$ is convex, then the F-derivative ${\cal A}_{x}^{f}$ exists at $x$ if and only if the G-derivative ${\cal B}_{x}^{f}$ exists at $x$.

We now make the corresponding follow-up definitions. The function $f$ is **Gateaux** (or **G-**) **differentiable at $x$** if its G-derivative ${\cal B}_{x}^{f}$ exists. Consequently, the function $f$ is **Gateaux** (or **G-**) **differentiable** or has **Gateaux** (or **G-**) **differentiability** if it is G-differentiable at all points in $\mathbb{R}^{n}$.

With the above definitions in mind, we give a few properties that merely require G-differentiability (instead of F-differentiability).

-   If $f$ is G-differentiable at $x$, then $f$ is **hemicontinuous** at $x$, i.e., for any $\varepsilon>0$ and $\Delta\in\mathbb{R}^{n}$ there exists $\delta=\delta(\varepsilon,\Delta)$ such that whenever $|t|<\delta$ then $\|f(x+t\Delta)-f(x)\|<\varepsilon$.

    -   *Exercise*. Consider the function

        $$
        (\gamma_{2})\qquad f(x_{1},x_{2})=\begin{cases}
                0, & \text{if }x=0,\\
                \dfrac{x_{2}(x_{1}^{2}+x_{2}^{2})^{3/2}}{(x_{1}^{2}+x_{2}^{2})^{2}+x_{2}^{2}}, & \text{otherwise}.
        \end{cases}
        $$

        Show that $f$ has a G-derivative at zero, but not an F-derivative at zero. Show, moreover, that $f$ is hemicontinuous at zero.

        <details class="solution-box">
        <summary>Show solution</summary>

        Fix $\Delta=(\Delta_{1},\Delta_{2})\neq 0$. If $\Delta_{2}=0$, then $f(t\Delta)=0$ for all $t$. If $\Delta_{2}\neq 0$, then for $t\neq 0$,

        $$
        \frac{f(t\Delta)-f(0)}{t}=\frac{\Delta_{2}\|\Delta\|^{3}|t|^{3}}{t^{4}\|\Delta\|^{4}+t^{2}\Delta_{2}^{2}}=\frac{\Delta_{2}\|\Delta\|^{3}|t|}{t^{2}\|\Delta\|^{4}+\Delta_{2}^{2}}\xrightarrow{t\to 0}0.
        $$

        Hence ${\cal B}_{0}^{f}(\Delta)=0$ is linear in $\Delta$, so $f$ is G-differentiable at zero (and therefore hemicontinuous at zero). If $f$ were F-differentiable at zero, its F-derivative would also have to be ${\cal A}_{0}^{f}=0$. Yet along the parabola $x_{2}=x_{1}^{2}$ ($x_{1}>0$),

        $$
        \frac{|f(x_{1},x_{1}^{2})-f(0)|}{\|(x_{1},x_{1}^{2})\|}=\frac{x_{1}^{2}(x_{1}^{2}+x_{1}^{4})}{(x_{1}^{2}+x_{1}^{4})^{2}+x_{1}^{4}}=\frac{1+x_{1}^{2}}{(1+x_{1}^{2})^{2}+1}\xrightarrow{x_{1}\to 0^{+}}\frac{1}{2}\neq 0,
        $$

        so $f$ is not F-differentiable at zero.

        </details>

-   If $f$ is G-differentiable at $x$ and $\|x\|=\sqrt{x^{T}x}$ for every $x\in\mathbb{R}^{n}$, then the partial derivatives of $f$ exist at $x$. Furthermore, the matrix representation of ${\cal B}_{x}^{f}$ is given by the **Jacobian**

$$
{\cal B}_{x}^{f}\equiv\left(\begin{array}{ccc}
    \frac{\partial f_{1}}{\partial x_{1}}(x) & \cdots & \frac{\partial f_{1}}{\partial x_{n}}(x)\\
    \vdots &  & \vdots\\
    \frac{\partial f_{m}}{\partial x_{1}}(x) & \cdots & \frac{\partial f_{m}}{\partial x_{n}}(x)
\end{array}\right)\in\mathbb{R}^{m\times n};
$$

its transpose in the case of $m=1$ is called the **gradient of $f$ at $x$**, and is denoted by $\nabla f(x)\in\mathbb{R}^{n}$.

-    More general versions of the Jacobian and gradient exist for other inner product spaces through the use of the **Riesz-Fréchet representation** theorem. The (generalized) gradient is specifically defined as the unique element $\nabla f(x)\in\mathbb{R}^{n\times m}$ satisfying $\left\langle ({\cal B}_{x}^{f})^{*}\tau,\Delta\right\rangle =\left\langle \nabla f(x)\tau,\Delta\right\rangle$ for every $\tau\in\mathbb{R}^{m}$ and $\Delta\in\mathbb{R}^{n}$, where $({\cal B}_{x}^{f})^{*}$ is the adjoint operator of ${\cal B}_{x}^{f}$.

-   **\[Chain Rule\]** If $f:\mathbb{R}^{n}\mapsto\mathbb{R}^{m}$ has a G-derivative at $x$ and $g:\mathbb{R}^{m}\mapsto\mathbb{R}^{p}$ has an F-derivative at $f(x)$, then the composite function $h:=g\circ f$ has a G-derivative at $x$ where 

$$
{\cal B}_{x}^{h}={\cal A}_{f(x)}^{g}{\cal B}_{x}^{f}.
$$

If, in addition, ${\cal B}_{x}^{f}$ is an F-derivative then ${\cal B}_{x}^{h}$ is an F-derivative as well.

-   *Exercise*. Let $f$ be as in $(\gamma_{2})$ and let $g:\mathbb{R}^{2}\mapsto\mathbb{R}^{2}$ be given by $g(x)=(x_{1},x_{2}^{2})^{T}$. Show that the composite function $h=f\circ g$ does not have a G-derivative at zero.

    <details class="solution-box">
    <summary>Show solution</summary>

    Note $g(0)=0$ and $h(0)=f(0)=0$. Choosing $\Delta=(1,1)^{T}$, we have $g(t\Delta)=(t,t^{2})^{T}$, so for $t\neq 0$,

    $$
    \frac{h(t\Delta)-h(0)}{t}=\frac{t^{2}(t^{2}+t^{4})^{3/2}}{t\bigl((t^{2}+t^{4})^{2}+t^{4}\bigr)}=\operatorname{sgn}(t)\,\frac{(1+t^{2})^{3/2}}{(1+t^{2})^{2}+1}.
    $$

    As $t\to 0^{+}$ this limit is $+\frac{1}{2}$, whereas as $t\to 0^{-}$ it is $-\frac{1}{2}$. Since the two-sided limit fails to exist, $h$ has no G-derivative at zero (here $f$ is only G-differentiable, not F-differentiable, at $g(0)=0$).

    </details>

Finally, some important anti-properties of G-derivatives and G-differentiability are as follows.

-   Surprisingly, just like the F-derivative, the existence of the partial derivatives at $x$ **does not** imply that the G-derivative exists at $x$.

    -   *Exercise*. Consider the same function in equation $(\gamma_{1})$ of the previous post. Show that $f$ is not G-differentiable at zero.

        <details class="solution-box">
        <summary>Show solution</summary>

        Along $\Delta=(1,1)^{T}$, we have $f(t\Delta)=f(t,t)=1$ for all $t\neq 0$, while $f(0,0)=0$. Thus $\frac{f(t\Delta)-f(0)}{t}=\frac{1}{t}$ has no finite limit as $t\to 0$ (and $f$ is not hemicontinuous along $\Delta$), so $f$ is not G-differentiable at zero.

        </details>

-   The G-differentiability of $f$ **does not** imply that $f$ is continuous (unlike for F-differentiability).

    -   *Exercise*. Consider the function

        $$
        f(x_{1},x_{2})=\begin{cases}
                0, & \text{if }x_{1}=0,\\
                \dfrac{2x_{2}\exp(-x_{1}^{-2})}{x_{2}^{2}+\exp(-2x_{1}^{-2})}, & \text{otherwise},
        \end{cases}
        $$

        at zero. Show that the G-derivative of $f$ exists at zero, but $f$ is not continuous.

        <details class="solution-box">
        <summary>Show solution</summary>

        Fix $\Delta=(\Delta_{1},\Delta_{2})\neq 0$. If $\Delta_{1}=0$ or $\Delta_{2}=0$, then $f(t\Delta)=0$ for all $t$. Otherwise, since $\exp(-(t\Delta_{1})^{-2})$ decays faster than any power of $|t|$ as $t\to 0$,

        $$
        \left|\frac{f(t\Delta)-f(0)}{t}\right|=\frac{2|\Delta_{2}|\exp(-(t\Delta_{1})^{-2})}{t^{2}\Delta_{2}^{2}+\exp(-2(t\Delta_{1})^{-2})}\leq\frac{2\exp(-(t\Delta_{1})^{-2})}{t^{2}|\Delta_{2}|}\xrightarrow{t\to 0}0.
        $$

        Hence ${\cal B}_{0}^{f}=0$ exists at zero. However, along the curve $x_{2}=\exp(-x_{1}^{-2})$ as $x_{1}\to 0$, we have $(x_{1},x_{2})\to(0,0)$ while

        $$
        f\bigl(x_{1},\exp(-x_{1}^{-2})\bigr)=\frac{2\exp(-2x_{1}^{-2})}{2\exp(-2x_{1}^{-2})}=1\not\to 0=f(0,0),
        $$

        so $f$ is discontinuous at zero.

        </details>

---
title: Lipschitz Continuous Gradients
date: '2022-08-13'
slug: lipschitz
description: Proof of the Descent Lemma and its lesser-known converse using mollifiers
  and Taylor's Theorem.
difficulty: Advanced Undergraduate Students
tags:
- mathematics
- optimization
---

During my graduate studies, I have been told that if you can't find a result anywhere else but inside your professor's mind, then it's most likely a result that only a few in the world know of. In this post, I would like to present one such result from one of my brief conversations with [Prof. Arkadi Nemirovski](https://www2.isye.gatech.edu/~nemirovs/) at Georgia Tech. As I remember it, this cool fact was a small side remark that he gave which I worked on for a few hours at home.

## Lipschitz Continuous Gradient

In nearly every beginner continuous optimization book or survey, one will encounter the seemingly mysterious condition of Lipschitz continuity in the gradient of the objective function. Formally, we say that a differentiable objective function $\phi:\mathbb{R}^{n}\mapsto\mathbb{R}$ has a *Lipschitz continuous gradient* $\nabla\phi:\mathbb{R}^{n}\mapsto\mathbb{R}^{n}$ on a convex open set $\Omega$ if 

$$
(\alpha)\qquad\|\nabla\phi(x)-\nabla\phi(y)\|\leq L\|x-y\|\quad\forall x,y\in\Omega.
$$

Another name for $(\alpha)$ that may appear in recent papers is *$L$-Lipschitz smoothness*, and, intuitively, it says the change in the gradient shouldn't grow faster than linearly on $\Omega$.

However, for the problem of minimizing $\phi$, it is not clear how $(\alpha)$ affects its difficulty nor the dynamics of a given method. Instead of dealing with $(\alpha)$, researchers will often instead use the necessary condition 

$$
(\beta)\qquad|\phi(x)-\phi(y)-\langle\nabla\phi(y),x-y\rangle|\leq\frac{L}{2}\|x-y\|^{2}
$$

which says that the error between $\phi$ and its linear approximation is bounded by a quadratic residual. This condition is particularly important in deriving complexity bounds for *gradient descent* type algorithms, which exactly consist of minimizing the linear approximation of $\phi$ plus a special quadratic. For more [complicated analyses](https://link.springer.com/article/10.1007/s10107-012-0629-5), such as bounding the stationarity residual of an algorithm, both $(\alpha)$ and $(\beta)$ are usually needed.

## Descent Lemma and its Converse

The process of proving that $(\alpha)$ implies $(\beta)$ is often called the *Descent Lemma,* and has been well-known for decades. Let's give the proof here for completeness.

*Proof of $(\alpha)\implies(\beta)$.* Let $x,y\in\Omega$ be given, define $\boldsymbol{r}(t)=x+t(y-x)$ for every $t\in[0,1]$, and suppose $(\alpha)$ holds. Using the definition of the gradient, it holds that 

$$
\begin{aligned}
\phi(y)-\phi(x) & =\int_{t=0}^{t=1}\nabla\phi(\boldsymbol{r}(t))\cdot d\boldsymbol{r}(t)=\int_{0}^{1}\left\langle \nabla\phi(x+t(y-x)),y-x\right\rangle dt\\
& =\left\langle \nabla\phi(x),y-x\right\rangle +\int_{0}^{1}\left\langle \nabla\phi(x+t(y-x))-\nabla\phi(x),y-x\right\rangle dt.\end{aligned}
$$

 Using the Cauchy-Schwarz inequality, the above relation, and Lipschitz continuity of $\nabla\phi$, we now conclude that 

$$
\begin{aligned}
\left|\phi(y)-\phi(x)-\langle\nabla\phi(x),y-x\rangle\right| & \leq\int_{0}^{1}\left|\left\langle \nabla\phi(x+t(y-x))-\nabla\phi(x),y-x\right\rangle \right|dt\\
 & \leq\int_{0}^{1}\|\nabla\phi(x+t(y-x))-\nabla\phi(x)\|\cdot\|y-x\|dt\\
& \leq\int_{0}^{1}tL\|y-x\|^{2}dt=\frac{L}{2}\|y-x\|^{2}\end{aligned}
$$

 and hence $(\beta)$ holds. **QED**

A surprising fact, though, is that the converse direction also holds! However, I have not seen its proof in any existing books or sources other than my brief conversation with Arkadi and my [doctoral thesis](/files/publications/thesis_william_kong.pdf). The main trick to proving this is to first define a sequence of ["mollifier"](https://en.wikipedia.org/wiki/Mollifier) functions $\{\delta_{k}\}_{n\geq1}$ that satisfy:

-   $\delta_{k}\geq0$ and $\delta_{k}$ is infinitely differentiable,

-   $\int_{\mathbb{R}^{n}}\delta_{k}(t)\ dt=1$, and

-   $\delta_{k}(t)=0$ for $t$ satisfying $\|t\|\geq1/k$,

Then, we convolve these mollifiers with $\phi$ to form a convergent sequence of smooth approximations with better smoothness properties. For completeness, let's give the full argument below.

*Proof of $(\beta)\implies(\alpha)$.* Let $\delta_{k}$ be as above, define the convolution 

$$
\psi_{k}(x)=\delta_{k}*\phi(x)=\int_{\mathbb{R}^{n}}\delta_{k}(x-y)\phi(y)\ dy\quad\forall x\in\Omega,
$$

and denote $d=x-y$. Using the well-known fact that 

$$
\nabla\psi_{k}(x) := \nabla\delta_{k}*\phi(x)=\delta_{k}*\nabla\phi(x)\quad\forall x\in\Omega
$$

it follows that for sufficiently large enough $k\geq1$, we have 

$$
\begin{aligned}
 & \left|\psi_{k}(y)-\psi_{k}(x)-\langle\nabla\psi_{k}(x),y-x\rangle\right|= \left|\delta_{k}*\left[\phi(y)-\phi(x)\right]+\left\langle \delta_{k}*\nabla\phi(x),d\right\rangle \right|\\
 &= \left|\int_{\mathbb{R}^{n}}\delta_{k}(\tau)\left[\phi(y-\tau)-\phi(x-\tau)\right]\ d\tau+\left\langle \int_{\mathbb{R}^{n}}\delta_{k}(\tau)\nabla\phi(x-\tau)\ d\tau,d\right\rangle \right|\\
 &= \left|\int_{\mathbb{R}^{n}}\delta_{k}(\tau)\left[\phi(y-\tau)-\phi(x-\tau)+\left\langle \nabla\phi(x-\tau),d\right\rangle \right]\ d\tau\right|\\
 &\leq \int_{\mathbb{R}^{n}}\delta_{k}(\tau)\left|\phi(y-\tau)-\phi(x-\tau)+\left\langle \nabla\phi(x-\tau),d\right\rangle \right|\ d\tau\\
&\leq \frac{L}{2}\int_{\mathbb{R}^{n}}\delta_{k}(\tau)\|d\|^{2}\ d\tau=\frac{L}{2}\|d\|^{2}=\frac{L}{2}\|x-y\|^{2},\end{aligned}
$$

and hence that $\psi_{k}$ satisfies $(\beta)$ with $\phi=\psi_{k}$ for sufficiently large enough $k\geq1$. Using Taylor's Theorem, the previous result, and the fact that $\psi_{k}$ is twice differentiable (why?), it holds that there exists $\xi\in[x,y]$ such that 

$$
\begin{aligned}
\frac{L}{2} & \geq\left|\frac{\psi_{k}(y)-\psi_{k}(x)-\langle\nabla\psi_{k}(x),y-x\rangle}{\|d\|^{2}}\right|=\left|\frac{\left\langle d,\nabla^{2}\psi_{k}(\xi)d\right\rangle }{2\|d\|^{2}}+\frac{o(\|d\|^{2})}{\|d\|^{2}}\right|.\end{aligned}
$$

Taking $y\to x$ in the above inequality, we thus conclude that $\|\nabla^{2}\psi_{k}(x)\|\leq L$ for every $x\in\Omega$, and by the Mean Value Theorem, 

$$
\|\nabla\psi_{k}(x)-\nabla\psi_{k}(y)\|\leq\sup_{\xi\in[x,y]}\|\nabla^{2}\psi_{k}(\xi)\|\cdot\|x-y\|\leq L\|x-y\|
$$

so that $\nabla\psi_{k}$ is $L$-Lipschitz continuous. Since $\nabla\psi_{k}\to\nabla\phi$ uniformly (why?), it follows that $\nabla\phi$ is also $L$-Lipschitz continuous. **QED**

---

*Note*: A concrete example of a mollifier $\delta_{k}$ satisfying the three needed conditions above is 

$$
\delta_{k}(x):=\begin{cases}
C_{k}\exp\left(-\dfrac{1}{1-k^{2}\|x\|^{2}}\right), & \|x\|<1/k,\\
0, & \|x\|\geq1/k.
\end{cases}
$$

where $C_{k}$ is a normalization constant to enforce $\int_{\mathbb{R}^{n}}\delta_{k}(t)\ dt=1$.

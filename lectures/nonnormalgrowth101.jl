### A Pluto.jl notebook ###
# v0.11.13

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 0c559e3e-f254-11ea-0871-af26d3e19606
begin
	using LinearAlgebra, Plots
	
	Rslider = @bind R html"<input type=range min=0 max=20 step=0.1 value=0>"
	
	md"**Select value for** _R_: $(Rslider)"
end

# ╔═╡ 98be5ed0-f281-11ea-049d-15a48bed564b
md"# A demonstration of transient energy growth in non-normal linear systems"

# ╔═╡ 0ffdfaea-f283-11ea-2798-8d458434b158
md"""
Consider linear operators that act on elements of a vector space has an inner product.

For example, the linear operator $ -\frac{\mathrm{d}^2}{\mathrm{d} x^2}$ acting on real-valued periodic functions $f(x)$ defined in $x\in [-L, L]$ with an inner product:
```math
 \Big ( f(x), g(x) \Big ) \equiv \int_{-L}^{L} f(x) g(x) \, \mathrm{d} x. \tag{1}
```
"""

# ╔═╡ ba6959ce-f281-11ea-0379-11a467f6fdb2
md"""
**Definition I**: The adjoint $A^\dagger$ of a linear operator $A$ is defined so that 
```math
(f, A\,g) = (A^\dagger f, g), \quad \forall \quad f, g.
```

**Definition II**: A linear operator $A$ is called *normal* if it commutes with its adjoint. That is, $A$ is normal if and only if $A A^\dagger = A^\dagger A$.

"""

# ╔═╡ 73d28218-f284-11ea-2a66-015782fef138
md"""For finite-dimensional vector spaces, linear operators are nothing else than  *matrices* that act on *column vectors*. In this case, the natural generalization of (1) is

```math
 \big ( f, g \big ) \equiv f^T \, g, \tag{2}
```
and one can readily confirm that the adjoint operator $A^\dagger$ is nothing else than the transpose of matrix $A$, i.e.
```math
 [A^\dagger]_{ij} = A_{ji}.
```
"""


# ╔═╡ 8c32cd68-f254-11ea-16a6-599fcaad6347
md"""Let's start by studying one of the simplest non-normal operators,
```math
A = \begin{pmatrix} -1 & -R \\ 0 &-2 \end{pmatrix}.
```

For $R=0$, $A$ is diagonal. In that case, $A^\dagger=A$ and thus they definitely commute. However, when $R\ne 0$, $A A^\dagger \ne A^\dagger A$.
"""

# ╔═╡ 902d6914-f263-11ea-1382-d3d2d5568485
md"_R_ = $(R)"

# ╔═╡ fa9fff24-f253-11ea-15bc-f32bceab352d
A = [-1 -R
	  0 -2]

# ╔═╡ 650c9568-f261-11ea-2bee-73a714e88947
md"Let's compute the commutator, i.e., $A A^\dagger - A^\dagger A$:"

# ╔═╡ 152aac86-f254-11ea-39c3-e3d8809c483e
A*A' - A'*A

# ╔═╡ f482bc52-f263-11ea-0fbf-8541eb594b1a
md"""Now let's do an eigen decomposition of both $A$ and $A^\dagger$, i.e.,

```math
\begin{align}
A u_j = \lambda_j u_j,\ &\text{or } A = U \Lambda U^{-1},
\end{align}
```

where $\Lambda$ is a diagonal matrix with eigenvalues $\lambda_j$ and $U$ is a matrix whose columns are the eigenvectors $u_j$. Similarly,

```math
\begin{align}
A^\dagger v_j = \mu_j v_j,\ &\text{or } A^\dagger = V M V^{-1}.
\end{align}
```
"""

# ╔═╡ 0ba5682a-f256-11ea-1eaa-e788ed04e3a4
begin
	Λ, U = eigen(A)
	u1, λ1 = U[:, 1], Λ[1]
	u2, λ2 = U[:, 2], Λ[2]

	M, V = eigen(A')
	v1, μ1 = V[:, 1], M[1]
	v2, μ2 = V[:, 2], M[2]
end;

# ╔═╡ bafcd406-f266-11ea-0226-15d57f29d5e4
md"It's instructive to plot the eigenvectors of $A$ and $A^\dagger$."

# ╔═╡ 75e6cd04-f264-11ea-3e1e-ff68240e2b49
begin	
	md"*R*: $(Rslider)"
end

# ╔═╡ 28bac61c-f256-11ea-32af-e5e6602bb255
begin
	plot([0, u1[1]], [0, u1[2]], arrow = arrow(), c=:blue, xlims=(-1.5, 1.5), ylims=(-1.5, 1.5), aspectratio = 1, box=:on, legend=:none, lw=2, title="R = "*string(R))
	plot!([0, u2[1]], [0, u2[2]], arrow = arrow(), c=:blue, lw=2)

	plot!([0, v1[1]], [0, v1[2]], arrow = arrow(), c=:red, lw=2)
	plot!([0, v2[1]], [0, v2[2]], arrow = arrow(), c=:red, lw=2)
	
	δangle = deg2rad(4)
	
	annotate!(1.15*cos(acos(u1[1])-δangle), 1.15*cos(acos(u1[2])-δangle), "u₁", :blue)
	annotate!(1.15*cos(acos(u2[1])-δangle), 1.15*cos(acos(u2[2])-δangle), "u₂", :blue)
	annotate!(1.15*cos(acos(v1[1])+δangle), 1.15*cos(acos(v1[2])+δangle), "v₁", :red)
	annotate!(1.15*cos(acos(v2[1])+δangle), 1.15*cos(acos(v2[2])+δangle), "v₂", :red)

end

# ╔═╡ a96bba38-f267-11ea-269c-8b507aabab45
md"""
Assume now that this operator $A$ describes the evolution of perturbations $\phi$ about some mean state. For example, think of the evolutions of flow and density perturbations $u'$, $v'$, $w'$, and $\rho'$ about a mean flow $U(z)$ and a mean density profile $\rho(z)$. In this case $\phi$ is all our perturbation fields while the information about $U$ and $\rho$ is all inside $A$.

Thus, $\phi=(\phi_1, \phi_2)$ has two components it is governed by

```math
\frac{\mathrm{d} \phi}{\mathrm{d} t} =  A\, \phi. \tag{1}
```

The state $\phi=0$ is an equilibrium. We want to find out whether small perturbations about $\phi=0$ will grow.

"""

# ╔═╡ 6d9a4318-f268-11ea-241e-b1794bb5e5af
md"""Let's define as _energy_ the quantity
```math
\begin{align}
E(t) &= \tfrac1{2} [\phi_1(t)^2 + \phi_2(t)^2] \\
	 &= \tfrac1{2} \hspace{-0.4em} \underbrace{(\phi, \phi)}_{\substack{\text{Eucledian}\\\text{inner product}}}
\end{align}
```
"""

# ╔═╡ 7ddd5150-f26f-11ea-3f1c-21b6eda45493
energy(φ) = 0.5 * dot(φ, φ);

# ╔═╡ 83bb414c-f26d-11ea-0469-5933cef63242
md"Let's pick an initial condition $\phi(t=0)=\phi_0$. Then we solve (1) and compute the energy time-series."

# ╔═╡ bec38c9c-f26d-11ea-1928-6930fdc6a579
md"""If we select an eigenvectors as an initial conditions, e.g., 
```math
\phi(t=0) = u_1,
```
then it's easy to show that the solution is
```math
\phi(t) = e^{\lambda_1 t} \, u_1,
```
with corresponding _energy_:
```math
E(t) = e^{2\lambda_1 t} E(0).
```

What if we pick a random initial condition? Of course, since the eigenvectors form a basis, any random condition can be written as a linear combination of the eigenvectors...
"""

# ╔═╡ a2b42a32-f259-11ea-1fd0-b70e45e22026
begin
	θslider = @bind θ html"<input type=range min=0.0 max=6.29 value=0 step=0.017453292519943295>"
	
	md"**Select value for** _θ_ (in degrees): $(θslider)"
end

# ╔═╡ 3156e636-f25e-11ea-0b8e-f9e4d6615521
begin
	md"_θ_ = $(round(rad2deg(θ), digits=1))°"
end

# ╔═╡ 9d9a5074-f26f-11ea-26bb-83de90f16a3a
begin	
	md"*R*: $(Rslider)"
end

# ╔═╡ 5e92c9f4-f258-11ea-15df-73790c800eb6
begin
	φ0 =  [cos(θ), sin(θ)]
	φ0 /= sqrt(energy(φ0))    # normalize to start with unit energy
end;

# ╔═╡ 640f70ac-f290-11ea-0f48-0f177b31944e
begin
	plot([0, u1[1]], [0, u1[2]], arrow = arrow(), c=:blue, xlims=(-1.9, 1.9), ylims=(-1.9, 1.9), aspectratio = 1, box=:on, legend=:none, lw=2, size=(350, 350))
	plot!([0, u2[1]], [0, u2[2]], arrow = arrow(), c=:blue, lw=2)

	plot!([0, v1[1]], [0, v1[2]], arrow = arrow(), c=:red, lw=2)
	plot!([0, v2[1]], [0, v2[2]], arrow = arrow(), c=:red, lw=2)
	
	plot!([0, φ0[1]], [0, φ0[2]], arrow = arrow(), c=:black, lw=2)
		
	annotate!(1.15*cos(acos(u1[1]) - δangle), 1.15*cos(acos(u1[2]) - δangle), "u₁", :blue)
	annotate!(1.15*cos(acos(u2[1]) - δangle), 1.15*cos(acos(u2[2]) - δangle), "u₂", :blue)
	annotate!(1.15*cos(acos(v1[1]) + δangle), 1.15*cos(acos(v1[2]) + δangle), "v₁", :red)
	annotate!(1.15*cos(acos(v2[1]) + δangle), 1.15*cos(acos(v2[2]) + δangle), "v₂", :red)
	
	annotate!(1.7*cos(θ), 1.7*sin(θ), "φ₀", :black)


end

# ╔═╡ a6c46692-f258-11ea-2eb5-a19abf72f00e
begin
	nsteps = 350
	
	t = range(0, stop=3.5, length=nsteps)
	
	φ = φ0
	
	Φ = [exp(A*t[j]) * φ for j=1:nsteps]
	E = [energy(Φ[j]) for j=1:nsteps]
	
	plot(t, [E exp.(2*λ1*t) exp.(2*λ2*t)],
		 # yscale = :log10,
		    label = ["E(t)" "exp(2λ₁t)" "exp(2λ₂t)"],
		linewidth = [4 2 2],
		linestyle = [:solid :dash :dash],
	  	   xlabel = "time",
	  	   ylabel = "perturbation energy amplification E(t)/E(t=0)",
		    title = "R = $R; maximum amplification: "*string(maximum(round.(E, digits=2)))
	)
end

# ╔═╡ Cell order:
# ╟─98be5ed0-f281-11ea-049d-15a48bed564b
# ╟─0ffdfaea-f283-11ea-2798-8d458434b158
# ╟─ba6959ce-f281-11ea-0379-11a467f6fdb2
# ╟─73d28218-f284-11ea-2a66-015782fef138
# ╟─8c32cd68-f254-11ea-16a6-599fcaad6347
# ╟─0c559e3e-f254-11ea-0871-af26d3e19606
# ╟─902d6914-f263-11ea-1382-d3d2d5568485
# ╠═fa9fff24-f253-11ea-15bc-f32bceab352d
# ╟─650c9568-f261-11ea-2bee-73a714e88947
# ╠═152aac86-f254-11ea-39c3-e3d8809c483e
# ╟─f482bc52-f263-11ea-0fbf-8541eb594b1a
# ╠═0ba5682a-f256-11ea-1eaa-e788ed04e3a4
# ╟─bafcd406-f266-11ea-0226-15d57f29d5e4
# ╟─75e6cd04-f264-11ea-3e1e-ff68240e2b49
# ╟─28bac61c-f256-11ea-32af-e5e6602bb255
# ╟─a96bba38-f267-11ea-269c-8b507aabab45
# ╟─6d9a4318-f268-11ea-241e-b1794bb5e5af
# ╠═7ddd5150-f26f-11ea-3f1c-21b6eda45493
# ╟─83bb414c-f26d-11ea-0469-5933cef63242
# ╟─bec38c9c-f26d-11ea-1928-6930fdc6a579
# ╟─a2b42a32-f259-11ea-1fd0-b70e45e22026
# ╟─3156e636-f25e-11ea-0b8e-f9e4d6615521
# ╟─9d9a5074-f26f-11ea-26bb-83de90f16a3a
# ╠═5e92c9f4-f258-11ea-15df-73790c800eb6
# ╟─640f70ac-f290-11ea-0f48-0f177b31944e
# ╟─a6c46692-f258-11ea-2eb5-a19abf72f00e

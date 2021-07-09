### A Pluto.jl notebook ###
# v0.14.8

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

# ╔═╡ d58ccd7f-7168-46ad-accb-475f283478e4
begin
	using Pkg: Pkg
	Pkg.add("PlutoUI")
	Pkg.add("LinearAlgebra")
	Pkg.add("Plots")
end

# ╔═╡ 47e61ea1-5bf5-4ff0-81a1-f9471ac933f1
begin
	using PlutoUI: Slider
	using LinearAlgebra: Diagonal
	using Plots: contour, quiver!, savefig
end

# ╔═╡ 9e5a1fdd-30de-436e-9090-6142494617b8
md"""Eigenspaces

| Direction (radians) | Eigenvalue |
| :--- | :--- |
| $(@bind dir_1 Slider(0:0.1:pi, default=1, show_value=true)) | $(@bind lambda_1 Slider(-2:0.1:5, default=1, show_value=true)) |
|  | $(@bind lambda_2 Slider(-2:0.1:5, default=2, show_value=true)) |
"""

# ╔═╡ 6ed6aa03-88e1-4e8a-9bfc-60e3d22058e5
begin
	eigenvec1 = [sin(dir_1), cos(dir_1)]
	eigenvec2 = [sin(dir_1+pi/2), cos(dir_1+pi/2)]
	
	eigen = [eigenvec1 eigenvec2]
	A = eigen * Diagonal([lambda_1, lambda_2]) / eigen
end

# ╔═╡ c3e4e730-d97d-11eb-0340-1d1e2fd0167a
begin
	f(x::Array) = sum(x .* (A * x))
	f(x::Tuple) = sum(x .* (A * collect(x)))
	f(x...) = f(x)
end

# ╔═╡ dc609f58-f607-4772-bdb0-f2db25475e18
begin
	contour(-5:0.1:5, -5:0.1:5, f, levels=-50:5:80)
	quiver!([0,0], [0,0], quiver=(eigen[1,:], eigen[2,:]))
end

# ╔═╡ 3d9d041e-5d53-410f-a1ce-e63b264ea924
savefig("contour.svg")

# ╔═╡ Cell order:
# ╠═d58ccd7f-7168-46ad-accb-475f283478e4
# ╠═47e61ea1-5bf5-4ff0-81a1-f9471ac933f1
# ╟─9e5a1fdd-30de-436e-9090-6142494617b8
# ╠═6ed6aa03-88e1-4e8a-9bfc-60e3d22058e5
# ╠═c3e4e730-d97d-11eb-0340-1d1e2fd0167a
# ╠═dc609f58-f607-4772-bdb0-f2db25475e18
# ╠═3d9d041e-5d53-410f-a1ce-e63b264ea924

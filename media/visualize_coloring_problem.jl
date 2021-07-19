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

# ╔═╡ 7e59c7cc-29d4-469e-bef5-37af84e7e9f3
begin
	using Pkg: Pkg
	Pkg.add("LaTeXStrings")
end

# ╔═╡ 058bfa8c-4d22-470e-b532-756948040f4e
begin
	using PlutoUI: Slider
	using SparseArrays: sparse
	using Plots: plot, plot!, savefig
	using LaTeXStrings
end

# ╔═╡ 0e3af38d-75a6-45e1-b051-8d3eb49bde94
md"#### Tiles
$(@bind tiles Slider(10:100, default=30, show_value=true))
"

# ╔═╡ 2632f25f-1939-4a31-8423-7ef817c1205b
begin
	laplacian = sparse(
		vcat(1:tiles, 2:tiles, 1:(tiles-1)), 
		vcat(1:tiles, 1:(tiles-1), 2:tiles), 
		vcat(2*ones(tiles), -1*ones(2*(tiles-1)))
	)
	laplacian[end,end] = 1
	laplacian
end

# ╔═╡ ab08220d-85b7-4e6d-aa23-d547b41cde3d
gradient(x) = laplacian * x - vcat(1, zeros(tiles-1)) 

# ╔═╡ f6373f3e-ddc9-4c6c-a82e-3b65cad7b14f
md"#### Learning Rate
$(@bind learning_rate Slider(0:0.01:0.5, default=0.5, show_value=true))
"

# ╔═╡ 3d67a2e4-695b-428c-b2c9-b9b7e30f009d
max_time_steps = 20*tiles

# ╔═╡ 5a3c1ee7-d58e-4838-a839-78504f4e5c85
states = accumulate((w, _)->(w-learning_rate*gradient(w)), 1:max_time_steps, init=zeros(tiles))

# ╔═╡ 370d6464-e28d-4c6f-9d9f-ed537935eebf
md"#### Timesteps
$(@bind time_steps Slider(2:max_time_steps, default=tiles, show_value=true))
"

# ╔═╡ 9736727f-0c5b-41c0-bb04-efcb87169c12
plot((0:tiles), vcat(1,states[time_steps]), linetype=:steppre, xlim=[0,tiles], ylim=[0,1], fillrange=zeros(tiles), fillalpha=0.4)

# ╔═╡ 01dfe578-cd63-4670-87b6-aff2da59369b
begin
	plt = plot(
		0:tiles, vcat(1,states[10*tiles]), 
		linetype=:steppre, 
		xlim=[0,tiles], ylim=[0,1], 
		fillrange=vcat(1,states[5*tiles]), 
		fillalpha=0.5,
		label="t=10·tiles"
	)
	plot!(plt,
		0:tiles, vcat(1,states[5*tiles]), 
		linetype=:steppre, 
		xlim=[0,tiles], ylim=[0,1], 
		fillrange=vcat(1,states[tiles]), 
		fillalpha=0.5,
		label="t=5·tiles"
	)
	plot!(plt,
		0:tiles, vcat(1,states[tiles]), 
		linetype=:steppre, 
		xlim=[0,tiles], ylim=[0,1], 
		fillrange=zeros(tiles), 
		fillalpha=0.5,
		label="t=tiles"
	)
end

# ╔═╡ 8c5a0bd4-d3e4-49d4-a449-7074250f0b94
savefig(plt, "visualize_coloring_problem.svg")

# ╔═╡ 8aa1962e-facb-46f7-ae34-404b28212c2e
md"# Appendix"

# ╔═╡ Cell order:
# ╟─0e3af38d-75a6-45e1-b051-8d3eb49bde94
# ╟─2632f25f-1939-4a31-8423-7ef817c1205b
# ╠═ab08220d-85b7-4e6d-aa23-d547b41cde3d
# ╟─f6373f3e-ddc9-4c6c-a82e-3b65cad7b14f
# ╟─5a3c1ee7-d58e-4838-a839-78504f4e5c85
# ╟─3d67a2e4-695b-428c-b2c9-b9b7e30f009d
# ╟─370d6464-e28d-4c6f-9d9f-ed537935eebf
# ╠═9736727f-0c5b-41c0-bb04-efcb87169c12
# ╟─01dfe578-cd63-4670-87b6-aff2da59369b
# ╠═8c5a0bd4-d3e4-49d4-a449-7074250f0b94
# ╟─8aa1962e-facb-46f7-ae34-404b28212c2e
# ╠═7e59c7cc-29d4-469e-bef5-37af84e7e9f3
# ╠═058bfa8c-4d22-470e-b532-756948040f4e

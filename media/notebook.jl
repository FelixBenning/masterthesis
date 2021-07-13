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
	Pkg.add("Zygote")
end

# ╔═╡ 47e61ea1-5bf5-4ff0-81a1-f9471ac933f1
begin
	using PlutoUI: Slider, Select
	using LinearAlgebra: Diagonal
	using Plots: savefig, plot, plot!, cgrad, grid
	using Zygote: gradient
end

# ╔═╡ f709e1de-aaac-4eb0-a2e0-a2bfa6ae6370
md"# Visualize Paraboloid"

# ╔═╡ 3d9d041e-5d53-410f-a1ce-e63b264ea924
# savefig("contour.svg")

# ╔═╡ 491bbd1c-39f6-4631-a9e0-1e29dbcc4ec1
md"# Visualize Gradient Decent"

# ╔═╡ 5993f2a2-dd65-49a5-8777-83ea02194f89
@bind viz_type Select(["normal"=>:Normal, "saddlepoint"=>:Saddlepoint, "bad_conditioning"=>:BadConditioning])

# ╔═╡ e771e800-f72c-46db-b80d-598c309f9743
default_ev = [
	Dict(
		"saddlepoint" => -1,
		"bad_conditioning" => 0.2,
		"normal"=> 1
	)[viz_type],
	Dict(
		"saddlepoint" => 2,
		"bad_conditioning" => 2,
		"normal"=> 2
	)[viz_type]
		
]

# ╔═╡ 9e5a1fdd-30de-436e-9090-6142494617b8
md"""Eigenspaces

| Direction (radians) | Eigenvalue |
| :--- | :--- |
| $(@bind dir_1 Slider(0:0.1:pi, default=1, show_value=true)) | $(@bind lambda_1 Slider(-2:0.1:5, default=default_ev[1], show_value=true)) |
|  | $(@bind lambda_2 Slider(-2:0.1:5, default=default_ev[2], show_value=true)) |
"""

# ╔═╡ 6ed6aa03-88e1-4e8a-9bfc-60e3d22058e5
begin
	eigenvec1 = [sin(dir_1+pi/2), cos(dir_1+pi/2)]
	eigenvec2 = [sin(dir_1), cos(dir_1)]

	
	eigen = [eigenvec1 eigenvec2]
	A = eigen * Diagonal([lambda_1, lambda_2]) / eigen
end

# ╔═╡ c3e4e730-d97d-11eb-0340-1d1e2fd0167a
begin
	f(x::Array) = sum(x .* (A * x))/2
	f(x::Tuple) = sum(x .* (A * collect(x)))/2
	f(x...) = f(x)
end

# ╔═╡ dc609f58-f607-4772-bdb0-f2db25475e18
begin
	plot(-5:0.1:5, -5:0.1:5, f, levels=-30:2:60, st=:contour)
	plot!([0,0], [0,0], quiver=(eigen[1,:], eigen[2,:]), st=:quiver)
end

# ╔═╡ fa713758-2713-4446-aa5c-f5fa1e2f601c
md"
#### Learning Rate (Optimal: $(opt_lr=round(2/(abs(lambda_1)+abs(lambda_2)), digits=2)))
$(@bind lr Slider(
	0.01:0.01:round(2/max(abs(lambda_1),abs(lambda_2)), digits=2), 
	default=opt_lr, 
	show_value=true
))
"

# ╔═╡ c5d4b530-3e8f-4a46-888f-22b54b4be7e2
log_rates = log.(abs.(1 .-lr.*[lambda_1,lambda_2])) 

# ╔═╡ f76998fa-a01e-4f5f-b714-2440a2f8dd50
start = Dict(
	"saddlepoint" => 4*eigenvec2 + 0.001*eigenvec1,
	"bad_conditioning" => 3*eigenvec1 + 3*eigenvec2,
	"normal"=> 3*eigenvec1 + 3*eigenvec2
)[viz_type]

# ╔═╡ 342ee539-d5da-43a6-b7ec-7717c338207c
max_steps = 
if maximum(log_rates) > 0
	# not convex, stop iterate from moving outside frame
	floor(Int32, minimum(log.(5 ./[eigenvec1'*start,eigenvec2'*start])./log_rates))
else
	# convex stop once all are close to 0 (below threshold 0.01)
	ceil(Int32, maximum(log.(0.01 ./[eigenvec1'*start, eigenvec2'*start])./log_rates))
end

# ╔═╡ 9bcec655-65b9-4444-b6ab-38ab8ab5d169
md"#### Gradient Steps
$(@bind steps Slider(1:max_steps, default=max_steps, show_value=true))
"

# ╔═╡ 02bfcd93-3512-4d75-9bb2-021fbf226a31
md"### Gradient Decent Steps"

# ╔═╡ e12b1bcb-4bbf-4adb-b277-c5703486ec72
begin
	decent_steps = Array{Float32}(undef, 2, steps)
	decent_steps[:,1] = start
	for step in 2:steps
		decent_steps[:,step] = 
		decent_steps[:,step-1] - lr .* gradient(f, decent_steps[:, step-1])[1]
	end
	decent_steps
end

# ╔═╡ f15c0419-96ec-4b9f-afab-00e4e8883146
begin
	losssurface = plot(-3:0.1:6, -6:0.1:3, f, st=:contour, title="Losssurface")
	plot!(
		losssurface,
		decent_steps[1,:], 
		decent_steps[2,:],
		markershape=:circle,
		label="Path of Gradient Decent",
		# aspect_ratio=1
	)
	loss = mapslices(f, decent_steps; dims=(1))'
	lossplot = plot(
		loss, 
		st=:scatter, 
		label=missing, 
		title="Loss", 
		xlabel="Iteration",
		xlim=(0, max_steps+1),
		ylim=(0-0.2, maximum(loss)+0.2)
	)
	gd_viz = plot(
		losssurface, lossplot, 
		layout=grid(1,2, widths=[0.7,0.3]), 
		fontfamily="Computer Modern"
	)
end

# ╔═╡ 45306bbd-ccfa-43bc-a90c-1c1b88f28a46
savefig(gd_viz, "visualize_$(viz_type).svg")

# ╔═╡ 2d3d6cdf-42f5-4c51-b3fe-58f227bb5aac
md"### GD with Momentum Steps"

# ╔═╡ 6954f075-9818-4742-98b5-f7e95a85cf77
md"# Appendix"

# ╔═╡ Cell order:
# ╟─f709e1de-aaac-4eb0-a2e0-a2bfa6ae6370
# ╠═e771e800-f72c-46db-b80d-598c309f9743
# ╟─9e5a1fdd-30de-436e-9090-6142494617b8
# ╟─6ed6aa03-88e1-4e8a-9bfc-60e3d22058e5
# ╠═c3e4e730-d97d-11eb-0340-1d1e2fd0167a
# ╟─dc609f58-f607-4772-bdb0-f2db25475e18
# ╠═3d9d041e-5d53-410f-a1ce-e63b264ea924
# ╟─491bbd1c-39f6-4631-a9e0-1e29dbcc4ec1
# ╟─5993f2a2-dd65-49a5-8777-83ea02194f89
# ╟─f15c0419-96ec-4b9f-afab-00e4e8883146
# ╠═45306bbd-ccfa-43bc-a90c-1c1b88f28a46
# ╟─fa713758-2713-4446-aa5c-f5fa1e2f601c
# ╟─c5d4b530-3e8f-4a46-888f-22b54b4be7e2
# ╟─342ee539-d5da-43a6-b7ec-7717c338207c
# ╟─9bcec655-65b9-4444-b6ab-38ab8ab5d169
# ╟─f76998fa-a01e-4f5f-b714-2440a2f8dd50
# ╟─02bfcd93-3512-4d75-9bb2-021fbf226a31
# ╠═e12b1bcb-4bbf-4adb-b277-c5703486ec72
# ╟─2d3d6cdf-42f5-4c51-b3fe-58f227bb5aac
# ╟─6954f075-9818-4742-98b5-f7e95a85cf77
# ╠═d58ccd7f-7168-46ad-accb-475f283478e4
# ╠═47e61ea1-5bf5-4ff0-81a1-f9471ac933f1

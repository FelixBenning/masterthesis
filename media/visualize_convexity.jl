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

# ╔═╡ 408078e0-e7cf-11eb-29d9-a33f00534ef9
begin
	using Plots: plot, plot!, savefig
	using Zygote: gradient
	using PlutoUI: RangeSlider, Slider
end

# ╔═╡ 8654d5be-b1f6-49e8-a02c-b9aac7eb7196
f(x) = x^2

# ╔═╡ 31607b26-b7e1-4915-af86-3387ed055f1a
x = -2:0.05:6

# ╔═╡ 678b920c-fcd9-4f0f-9c61-c558d652c58d
md"#### Convex Combination"

# ╔═╡ 5f774d04-aebd-4822-9cdb-c8534dc025a0
@bind lin_comb RangeSlider(x, left=-1,right=4,show_value=true)

# ╔═╡ 9d5ab13d-ec73-4aa0-9c35-90dc59e09380
md"#### Tangent Position
$(@bind tangent_pos Slider(x, default=3, show_value=true))
"

# ╔═╡ 74a2da17-048a-4b2e-8a0b-37c752313875
begin
	plt = plot(x, f, ylim=(-10,40), label=missing)
	plot!(
		plt, 
		x, y->(f(tangent_pos) + gradient(f,tangent_pos)[1]*(y-tangent_pos)),
		label=missing,
	)
	plot!(
		plt, [tangent_pos], [f(tangent_pos)], 
		marker="circle", color=2,  label="tangent"
	)
	plot!(
		plt, 
		[lin_comb[1], lin_comb[end]], [f(lin_comb[1]), f(lin_comb[end])],
		marker="circle", label="convex combination", color=3
	)
end

# ╔═╡ 2ea89667-15c9-463f-88b1-98c524d33bc6
savefig(plt, "visualize_convexity.svg")

# ╔═╡ Cell order:
# ╠═408078e0-e7cf-11eb-29d9-a33f00534ef9
# ╠═8654d5be-b1f6-49e8-a02c-b9aac7eb7196
# ╟─31607b26-b7e1-4915-af86-3387ed055f1a
# ╟─678b920c-fcd9-4f0f-9c61-c558d652c58d
# ╟─5f774d04-aebd-4822-9cdb-c8534dc025a0
# ╟─9d5ab13d-ec73-4aa0-9c35-90dc59e09380
# ╟─74a2da17-048a-4b2e-8a0b-37c752313875
# ╠═2ea89667-15c9-463f-88b1-98c524d33bc6

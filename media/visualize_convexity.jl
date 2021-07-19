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
	plt = plot(
		x, f, 
		ylim=(-10,40), 
		linewidth=2.5, 
		label=missing, 
		fontfamily="Computer Modern"
	)
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

# ╔═╡ adf6e322-a753-4351-a560-224597906fdc
md"# Visualize Strong Convexity"

# ╔═╡ 378e53e2-de1a-41ed-a4c5-57c4d905549e
foo(x) = x^4/20 + x^2

# ╔═╡ 74488258-5e84-407d-86ae-d2f273ab8412
foo_domain = -2:0.1:3

# ╔═╡ b360fc7e-fb4d-4c3f-b4e5-4546fc98dfd6
ubound =maximum(abs.([x[1] for x in gradient.(x -> gradient(foo,x)[1], foo_domain)]))

# ╔═╡ 004982d5-e167-44c2-a11d-e86e034bab4f
lbound = minimum(abs.([x[1] for x in gradient.(x -> gradient(foo,x)[1], foo_domain)]))

# ╔═╡ e79c444e-57f9-48b7-bbaa-d1aa70ed2292
md"#### Approximation Location
$(@bind approx_loc Slider(foo_domain, default=1, show_value=true))
"

# ╔═╡ 95188ed1-bba5-4e56-b017-37b132731bb9
begin
	sc_viz = plot(
		foo_domain, foo, 
		label=missing,
		fontfamily="Computer Modern",
		ylim=[minimum(foo.(foo_domain)),maximum(foo.(foo_domain))],
		linewidth=2.5
	)
	plot!(
		sc_viz,
		foo_domain,
		x-> (
			foo(approx_loc) 
			+ gradient(foo, approx_loc)[1]*(x-approx_loc)
			+ ubound/2*(x-approx_loc)^2
		),
		label="Lipschitz Continuous Gradient (Upper bound)"
	)
	plot!(
		sc_viz,
		foo_domain,
		x-> (
			foo(approx_loc) 
			+ gradient(foo, approx_loc)[1]*(x-approx_loc)
		),
		label="Convexity (Lower bound)"
	)
	plot!(
		sc_viz,
		foo_domain,
		x-> (
			foo(approx_loc) 
			+ gradient(foo, approx_loc)[1]*(x-approx_loc)
			+ lbound/2*(x-approx_loc)^2
		),
		label="Strong Convexity (Lower bound)"
	)
	plot!(
		sc_viz, [approx_loc], [foo(approx_loc)], 
		marker="circle", label=missing
	)
end

# ╔═╡ 0b219ee3-6cc1-492b-a3e6-c9460f8e6b34
savefig(sc_viz, "visualize_strong_convexity.svg")

# ╔═╡ d52e55a9-650b-42ae-99ed-c4c2e5ef062b
md"# Appendix"

# ╔═╡ Cell order:
# ╠═8654d5be-b1f6-49e8-a02c-b9aac7eb7196
# ╟─31607b26-b7e1-4915-af86-3387ed055f1a
# ╟─678b920c-fcd9-4f0f-9c61-c558d652c58d
# ╟─5f774d04-aebd-4822-9cdb-c8534dc025a0
# ╟─9d5ab13d-ec73-4aa0-9c35-90dc59e09380
# ╟─74a2da17-048a-4b2e-8a0b-37c752313875
# ╠═2ea89667-15c9-463f-88b1-98c524d33bc6
# ╟─adf6e322-a753-4351-a560-224597906fdc
# ╠═378e53e2-de1a-41ed-a4c5-57c4d905549e
# ╟─74488258-5e84-407d-86ae-d2f273ab8412
# ╟─b360fc7e-fb4d-4c3f-b4e5-4546fc98dfd6
# ╟─004982d5-e167-44c2-a11d-e86e034bab4f
# ╟─e79c444e-57f9-48b7-bbaa-d1aa70ed2292
# ╟─95188ed1-bba5-4e56-b017-37b132731bb9
# ╠═0b219ee3-6cc1-492b-a3e6-c9460f8e6b34
# ╟─d52e55a9-650b-42ae-99ed-c4c2e5ef062b
# ╠═408078e0-e7cf-11eb-29d9-a33f00534ef9

# Operatornorm of Momentum Transformation

spectral radius is not equal to operator norm, bound operator norm somehow

## Ideas

- [ ] Basis Change to Jordan normal form
	- [x] Bound J^n
	- [ ] Bound Basis Change
- [x] Schur decomposition / QR decomposition
	- [x] explicit decomposition to find value in the corner
	- [x] same idea as bounding J^n just that the basis is no problem this time as it is orthogonal
- [ ] Constrained Optimization (Lagrange) OR spectrum AA^t OR A^tA spektrum
	- [ ] Bound ||A^2||
	- [ ] Bound ||A||^2
	- [ ] Apply Kozyakin

# Operatornorm for Changing Learning rate

Basis change matrices do not cancel out

## Ideas

- [ ] Piecewise constant learning rate?
- [ ] Basis change matrices are maybe *similar enough*, add basis change for iteration n and bound the difference between basis change n+1 and change n
	- [ ] somehow surgically remove the basis change differences from the
	product without forcing a product of operator norms
	
# Calculation based Backtracking

- [ ] classic case
- [ ] stochastic case

# Standard Basis are Eigenvectors? Heuristics Foundation

- [ ] In high dimension two random vectors are likely orthogonal -> eigenspace groups?
- [ ] Coordinate Descent

# SDE view

- [ ] try to do the estimation better

# Conjugate Gradient Descent

# Multi chain Montecarlo (estimate bias of larger steps)

- Simon (Heidelberg) work?

# Trust Regions

- [ ] Instead of bounded 2nd derivative -> upper bound on Bregman Divergence
	  use bounded third derivative -> derive lr for newton?



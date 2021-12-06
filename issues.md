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

# Conjugate Gradient Descent

# Multi chain Montecarlo (estimate bias of larger steps)

- Simon (Heidelberg) work?

# Trust Regions

- [x] Instead of bounded 2nd derivative -> upper bound on Bregman Divergence
	  use bounded third derivative -> derive lr for newton? -> Cubic newton

# Optimization similar to autodiff?

## Instant optimization:

- Addition: Select every value as large as possible 
- division: max divisor, min dividend
- multiplication: max both
- subtraction: max ...
- if/else: maximize respective options and  decision boundary

-> all other operations can be expressed with those (?)

### Issue: Conflicting orders

(x-y)/x

make x large/make x small

solvable?

## condition calculation?

# Take Gradient w.r.t. different norm

cf. Conjugate Gradient

# Parallelization Alternative to Batches

Global Optimization?
Idea
1. start out gd from n points -> distribution
2. split one point in random distribution around point occasionally during training 
-> tree (too many branches for parallelization)
-> branch cutting based on current height (evolutionary algorithm).
Tree has independent strands so we can apply SGD proof (for mathematical proof
pretend cutting does not exist) then apply culling to full tree.

Tree might approximate uniform distribution over all parameters?
include("../poly_factorization_project.jl")

#############################################
#############################################
#############################################
# Testing zone...
#############################################
#############################################

p1 = Polynomial(Term(1,2)) + Polynomial(Term(1,0))
p2 = Polynomial(Term(1,1)) + Polynomial(Term(1,0))

# @show typeof((p1 % p2)(101))

# euclid_alg(p1, p2, (a,b)-> (a%b)(101)   )
# @show p1
# @show p2

# euclid_alg(Polynomial([Term(1,1),Term(1,0)]), Polynomial(Term(2,0)), (a,b)-> (a%b)(101)   )

(Polynomial([Term(1,1),Term(1,0)]) %  Polynomial(Term(2,0)) )(101)

# Polynomial([Term(2,3),Term(4,5)])

#QQQQ - handle tests without dividing by zero.
# using Random; Random.seed!(0)
# for _ in 1:12
#     p1 = rand(Polynomial)
#     p2 = rand(Polynomial)
#     @show p1
#     @show p2
#     p_prod = p1*p2
#     prime = 101
#     p_prod_reduced =  p_prod % prime
#     q, r = divide(p_prod_reduced,p2)(prime)
#     @show q, r
#     @assert iszero( (q*p2+r - p_prod_reduced)%prime )
# end


# p1 = Polynomial([(2,5),(4,7),(9,17),(2,4),(-3,18),(-6,8)])
# p1 % 3
# @show p1 * Term(2,3)
# p1 = Polynomial([(1,2),(-1,0)])
# @show p1
# p2 = Polynomial([(1,1),(1,0)])
# @show p2

# @show p1 - p2
# divideby(p1,p2,101)

# p1 = Polynomial([Term(2,3),Term(5,2)])


# @show p2
# @show evaluate(p2,2)
# @show p1
# @show p2
# p3 = p1 + p2z
# @show p3
# @show p3
# @show iszero(p)
# @show iszero(Polynomial())
# p = Polynomial()
# push!(p,Term(2,3))
# push!(p,Term(2,5))
include("../poly_factorization_project.jl")


# function extended_gcd(a, b)
#     (old_r, r) := (a, b)
#     (old_s, s) := (1, 0)
#     (old_t, t) := (0, 1)
    
#     while r ≠ 0 do
#         quotient := old_r div r
#         (old_r, r) := (r, old_r − quotient × r)
#         (old_s, s) := (s, old_s − quotient × s)
#         (old_t, t) := (t, old_t − quotient × t)
    
#     output "Bézout coefficients:", (old_s, old_t)
#     output "greatest common divisor:", old_r
#     output "quotients by the gcd:", (t, s)






# x2 + 7x + 6 and x2 − 5x − 6:

# p1 = Polynomial([Term(1,2),Term(7,1),Term(6,0)])
# p2 = Polynomial([Term(1,2),Term(-5,1),Term(-6,0)])

# p = x8 + x4 + x3 + x + 1, and a = x6 + x4 + x + 1 

extended_euclid_alg(p1,p2,101)

# p1 = Polynomial([Term(94,3), Term(23,1), Term(20,0)]) 
# p2 = Polynomial([Term(13,8), Term(8,6), Term(29,3), Term(75,1)]);

# @show p1
# @show p2
# g = euclid_alg(p1,p2,(a,b)->(a%b)(101),10)

# a = 94⋅x^3+ 23⋅x^1+ 20⋅x^0+ 
# b = -89⋅x^2+ -36⋅x^1+ -72⋅x^0+ 
# rem_function(a, b) = 87⋅x^3+ 21⋅x^2+ 65⋅x^1+ 20⋅x^0+ 


# a = Polynomial([Term(94, 3),Term(23, 1),Term(20, 0)]) 
# b = Polynomial([Term(-89, 2),Term(-36, 1),Term(-72, 0)]) 
# @show a
# @show b
# @show a%101
# @show b%101
# q = ((a,b)->(a÷b)(101))(a, b) 
# r = ((a,b)->(a%b)(101))(a, b) 
# @show q
# @show r
# @show (q*b+r)%101

#############################################
#############################################
#############################################
# Testing zone...
#############################################
#############################################

# p1 = Polynomial(Term(1,2)) + Polynomial(Term(-1,0)) #x^2 - 1
# p2 = Polynomial(Term(1,1)) + Polynomial(Term(1,0)) #x + 1


# ext_euclid_alg(p1, p2, (a,b)-> (a%b)(101), (a,b)-> (a ÷ b)(101)   )


# @show typeof((p1 % p2)(101))

# euclid_alg(p1, p2, (a,b)-> (a%b)(101)   )
# @show p1
# @show p2

# euclid_alg(Polynomial([Term(1,1),Term(1,0)]), Polynomial(Term(2,0)), (a,b)-> (a%b)(101)   )

#p3 = (Polynomial([Term(1,1),Term(1,0)]) ÷  Polynomial(Term(2,0)) )(101)

# Polynomial([Term(2,3),Term(4,5)])




# division_test()

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
# p3 = p1 + p2
# @show p3
# @show p3
# @show iszero(p)
# @show iszero(Polynomial())
# p = Polynomial()
# push!(p,Term(2,3))
# push!(p,Term(2,5))
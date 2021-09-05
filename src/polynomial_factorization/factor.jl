#############################################################################
#############################################################################
#
# This file implements factorization 
#                                                                               
#############################################################################
#############################################################################

"""
Factors a polynomial over the field Z_p.

Returns a list of irreducible polynomials (mod p) such that their product of the list (mod p) is f. Irreducibles are fixed points on the function factor.
"""
function factor(f::Polynomial, prime::Int) 
    #functionality missing here.
end

"""
Distinct degree factorization.

Given a square free polynomial `f` returns a list, `g` such that `g[k]` is a product of irreducible polynomials of degree `k` for `k` in 1,...,degree(f) ÷ 2, such that the product of the list (mod `prime`) is equal to `f` (mod `prime`).
"""
function dd_factor(f::Polynomial, prime::Int)::Array{Polynomial}
    x = x_poly()
    w = deepcopy(x)
    g = Array{Polynomial}(undef,degree(f)) #Array of polynomials indexed by degree

    #Looping over degrees
    for k in 1:degree(f)
        w = rem(w^prime,f)(prime)
        g[k] = gcd(w - x, f, prime) 
        f = (f ÷ g[k])(prime) 
    end

    #edge case for final factor
    f != one(Polynomial) && push!(g,f)
    
    return g
end

"""
Distinct degree split.

Returns a list of irreducible polynomials of degree `d` so that the product of that list (mod prime) is the polynomial `f`.
"""
function dd_split(f::Polynomial, d::Int, prime::Int)::Vector{Polynomial}
    degree(f) == d && return [f]
    degree(f) == 0 && return []
    w = rand(Polynomial, degree = d, monic = true)#QQQQ, condition = (p)->is_irreducible(p,prime) )
    n_power = (prime^d-1) ÷ 2
    g = gcd(w^n_power - one(Polynomial), f, prime)
    ḡ = (f ÷ g)(p) # g\bar + [TAB]
    return vcat(dd_split(g, d, prime), dd_split(ḡ, d, prime) )
end
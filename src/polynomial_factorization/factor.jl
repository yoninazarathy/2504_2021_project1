#############################################################################
#############################################################################
#
# This file defines the polynomial type with several operations 
#                                                                               
#############################################################################
#############################################################################

####################################
# Polynomial type and construction #
####################################

"""
Factors a polynomial over the field Z_p.

Returns a list of irreducible polynomials (mod p) such that their product of the list (mod p) is f. Irreducibles are fixed points on the function factor.
"""
function factor(f::Polynomial, prime::Int) 
    #cantor_zassenhaus_factorization
    f = mod(f,prime)
    old_content = content(f)
    f = mod(f ÷ old_content,prime)      # make f primitive;
    old_coeff = leading(f).coeff
    f = mod(f ÷ old_coeff,prime)        # make f monic
    squares = gcd(f, derivative(f), prime) 
    sqrfree_f = (f ÷ squares)(prime)    # make f square-free
    dds = dd_factor(sqrfree_f, prime)
    # look = map(x -> Factor(x) mod p, dds); 
#     irreduc_factors := foldr(list_concat, seq(dd_split(dds[k], k, p), k=1..nops(dds)));
#     # construct the answer
#     ans := [old_content*old_coeff, 1];  # the old leading coefficient
#     for k from 1 to nops(irreduc_factors) do:   # nops is length
#         ans := ans, [irreduc_factors[k], repeated_remainder(f, irreduc_factors[k], p)];
#     end do;
#     return [ans];
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
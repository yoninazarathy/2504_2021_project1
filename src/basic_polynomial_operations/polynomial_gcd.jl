#############################################################################
#############################################################################
#
# This file implements polynomial GCD 
#                                                                               
#############################################################################
#############################################################################

"""
The extended euclid algorithm for polynomials modulo prime.
"""
function extended_euclid_alg(a::Polynomial, b::Polynomial, prime::Int)
    old_r, r = smod(a,prime), smod(b,prime)
    # @show old_r, r
    old_s, s = one(Polynomial), zero(Polynomial)
    old_t, t = zero(Polynomial), one(Polynomial)

    # cnt = 0

    while !iszero(smod(r,prime)) #&& cnt < 20
        # cnt += 1
        # @show cnt
        q = divide(old_r, r)(prime) |> first #QQQQ cleanup
        # @show q
        old_r, r = r, smod(old_r - q*r, prime)
        old_s, s = s, smod(old_s - q*s, prime)
        old_t, t = t, smod(old_t - q*t, prime)
    end
    g, s, t = old_r, old_s, old_t
    @assert smod(s*a + t*b - g, prime) == 0
    return g, s, t  
end

"""
The GCD of two polynomials modulo prime.
"""
gcd(a::Polynomial, b::Polynomial, prime::Int) = extended_euclid_alg(a,b,prime) |> first
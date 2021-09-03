#############################################################################
#############################################################################
#
# This file implements polynomial multiplication 
#                                                                               
#############################################################################
#############################################################################

"""
Multiply two polynomials.
"""
#STD: Improve this naive (inefficient multiplication)
function *(p1::Polynomial, p2::Polynomial)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(p1.terms)) #tt is target term
        p_out = p_out + (tt * p2)
    end
    return p_out
end

"""
Power of a polynomial.
"""
function ^(p::Polynomial, n::Int)
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
    end
    return out
end


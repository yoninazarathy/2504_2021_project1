#############################################################################
#############################################################################
#
# This file implements polynomial division 
#                                                                               
#############################################################################
#############################################################################


#QQQQ - create a different type
# struct UnluckyPrimeError <: Excpetion
# end

"""  Modular algorithm.
f divide by g

f = q*g + r

p is a prime
"""
function divide(num::Polynomial, den::Polynomial)
    function division_function(p::Int)
        f, g = smod(num,p), smod(den,p)
        degree(f) < degree(num) && return nothing #QQQQ ask Paul/Andy...
        iszero(g) && throw(DivideError())# QQQQ - is there a string with it???"polynomial is zero modulo $p"))
        q = Polynomial()
        prev_degree = degree(f)
        while degree(f) ≥ degree(g) 
            h = Polynomial( (leading(f) ÷ leading(g))(p) )  #syzergy #QQQQ - Andy/Paul-B - can we do automatic promoting (see line below)
            f = smod((f - h*g), p)
            q = smod((q + h), p) #QQQQ - would have auto promoted 
            prev_degree == degree(f) && break
            prev_degree = degree(f)
        end
        @assert iszero( smod((num  - (q*g + f)),p))
        return q, f
    end
    return division_function
end

"""
The quotient from polynomial division. Returns a function of an integer.
"""
÷(num::Polynomial, den::Polynomial)  = (p::Int) -> first(divide(num,den)(p))

"""
The remainder from polynomial division. Returns a function of an integer.
"""
rem(num::Polynomial, den::Polynomial)  = (p::Int) -> last(divide(num,den)(p))
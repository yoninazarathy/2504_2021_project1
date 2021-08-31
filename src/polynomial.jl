"""
A Polynomial type - designed to be for polynomials with integer coefficients.
"""
struct Polynomial
    terms::MutableBinaryMaxHeap{Term}   
        #The terms heap needs to satisfy:
            # Will never have terms with 0 coefficient
            # Will never have two terms with same coefficient
        #An empty terms heap means the zero polynomial
    Polynomial() = new(MutableBinaryMaxHeap{Term}())
    Polynomial(h::MutableBinaryMaxHeap{Term}) = new(h) #QQQQ - check not to have 0 coefficient
end

"""
Construct a polynomial with a single term.
"""
function Polynomial(t::Term)
    terms = MutableBinaryMaxHeap{Term}()
    t.coeff != 0 && push!(terms,t)
    return Polynomial(terms)
end

"""
Construct a polynomial with a vector of terms.
"""
function Polynomial(tv::Vector{Term})
    terms = MutableBinaryMaxHeap{Term}()
    for t in tv
        t.coeff != 0 && push!(terms,t)
    end
    return Polynomial(terms)
end

"""
Creates the zero polynomial.
"""
zero(::Type{Polynomial}) = Polynomial()

"""
Creates the unit polynomial.
"""
one(::Type{Polynomial}) = Polynomial(one(Term))

"""
Generates a random polynomial.
"""
function rand(::Type{Polynomial} ; 
                degree::Int = -1, 
                terms::Int = -1, 
                max_coeff::Int = 100, 
                mean_degree::Float64 = 5.0,
                prob_term::Float64  = 0.7)

    if degree == -1
        degree = rand(Poisson(mean_degree))
    end

    if terms == -1
        terms = rand(Binomial(degree+1,prob_term))
    end

    degrees = sample(0:degree,terms,replace = false)
    coeffs = rand(1:max_coeff,terms)
    return Polynomial( [Term(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
end

"""
The number of terms of the polynomial.
"""
length(p::Polynomial) = length(p.terms)


"""
Allows to do iteration over the terms of the polynomial. The iteration is in an arbitrary order.
"""
iterate(p::Polynomial, state=1) = iterate(p.terms, state)

"""
Returns the coefficients of the polynomial.
"""
coeffs(p::Polynomial)::Vector{Int} = [t.coeff for t in p]


#QQQQ Handle error if pushing another term of same degree
"""
Push a new term into the polynomial.
"""
function push!(p::Polynomial, t::Term) 
    iszero(t) && return #don't push a zero
    push!(p.terms,t)
end


"""
Pop the leading term out of the polynomial.
"""
pop!(p::Polynomial)::Term = pop!(p.terms)


#QQQQ - Maybe re-think when doing mod-p
"""
The leading term of the polynomial.
"""
leading(p::Polynomial)::Term = isempty(p.terms) ? zero(Term) : first(p.terms)  #QQQQ should maybe use a "zero method" instead of Term(0,0)

"""
The degree of the polynomial.
"""
degree(p::Polynomial)::Int = leading(p).degree 

"""
Check if the polynomial is zero.
"""
iszero(p::Polynomial)::Bool = isempty(p.terms)

"""
The content of the polynomial is the GCD of its coefficients.
"""
content(p::Polynomial)::Int = euclid_alg(coeffs(p))

"""
Create a new polynomial which is the derivative of the polynomial.
"""
derivative(p::Polynomial)::Polynomial = Polynomial(map(derivative,p.terms)) #QQQQ Fix to handle two constants...

"""
Take the derivative of the polynomial and return itself.
"""
derivative!(p::Polynomial)::Polynomial = (map!(derivative,p.terms), return p)

#QQQQ - Improve pretty printing
"""
QQQQ
"""
function Base.show(io::IO, p::Polynomial) 
    p = deepcopy(p)
    if iszero(p)
        print(io,"0")
    else
        for t in extract_all!(p.terms)
            print(io, t, "+ ")
        end
    end
end

"""
QQQQ
"""
==(p1::Polynomial, p2::Polynomial)::Bool = p1.terms == p2.terms


#QQQQ - is this sensible (Paul/Andy)
"""
QQQQ
"""
==(p::Polynomial, n::T) where T <: Real = iszero(p) == iszero(n)

#QQQQ - Maybe have the "distributive addition" paradigm like multiplication (less efficient)
"""
QQQQ
"""
function +(p1::Polynomial, p2::Polynomial)::Polynomial
    p1, p2 = deepcopy(p1), deepcopy(p2)
    p3 = Polynomial()
    while !iszero(p1) && !iszero(p2)
        t1, t2 = leading(p1), leading(p2) 
        if t1.degree == t2.degree
            push!(p3, pop!(p1)+pop!(p2))
        elseif t1.degree < t2.degree
            push!(p3,pop!(p2))
        else
            push!(p3,pop!(p1))
        end
    end
    while !iszero(p1)
        push!(p3,pop!(p1))
    end
    while !iszero(p2)
        push!(p3,pop!(p2))
    end
    return p3
end

"""
QQQQ
"""
function -(p::Polynomial)::Polynomial
    p_temp = deepcopy(p)
    p_out = Polynomial()
    while !iszero(p_temp)
        push!(p_out,-pop!(p_temp))
    end
    return p_out
end

"""
QQQQ
"""
*(t::Term,p1::Polynomial)::Polynomial = iszero(t) ? Polynomial() : Polynomial(map((pt)->t*pt, p1.terms))
*(p1::Polynomial, t::Term)::Polynomial = t*p1

"""
QQQQ
"""
-(p::Polynomial) = Polynomial(map((pt)->-pt, p.terms)) #Can't specify return Polynomial?

"""
QQQQ
"""
-(p1::Polynomial, p2::Polynomial)::Polynomial = p1 + (-p2)

##Our naive multiplier
"""
QQQQ
"""
function *(p1::Polynomial, p2::Polynomial)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(p1.terms)) #tt is target term
        p_out = p_out + (tt * p2)
    end
    return p_out
end

#QQQQ - Yoni - use map as needed and also maintain not having Term(0,0) as invairant
"""
QQQQ
"""
function mod(f::Polynomial, p::Int)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(f.terms))
        push!(p_out, mod(tt, p)) #if coeff reduced to zero, push! will handle it
    end
    return p_out
end

#QQQQ - use a "map" after making it.
"""
QQQQ
"""
evaluate(f::Polynomial, x::T) where T <: Number = sum(evaluate(tt,x) for tt in extract_all!(deepcopy(f.terms)))

#QQQQ - create a different type
# struct UnluckyPrimeError <: Excpetion
# end

"""  Modular algorithm.
f divide by g

f = q*g + r

p is a prime
"""
function divide(num::Polynomial, den::Polynomial)# QQQQ what is the return type
    function division_function(p::Int)
        f, g = mod(num,p), mod(den,p)
        degree(f) < degree(num) && return nothing #QQQQ ask Paul/Andy...
        iszero(g) && throw(DivideError())# QQQQ - is there a string with it???"polynomial is zero modulo $p"))
        q = Polynomial()
        prev_degree = degree(f)
        while degree(f) ≥ degree(g) 
            h = Polynomial( (leading(f) ÷ leading(g))(p) )  #syzergy #QQQQ - Andy/Paul-B - can we do automatic promoting (see line below)
            f = mod((f - h*g), p)
            q = mod((q + h), p) #QQQQ - would have auto promoted 
            prev_degree == degree(f) && break
            prev_degree = degree(f)
        end
        @assert iszero( mod((num  - (q*g + f)),p))
        return q, f
    end
    return division_function
end

"""
QQQQ
"""
÷(num::Polynomial, den::Polynomial)  = (p::Int) -> first(divide(num,den)(p))

"""
QQQQ
"""
mod(num::Polynomial, den::Polynomial)  = (p::Int) -> last(divide(num,den)(p))




# def divideby(self, other, p: int):
#         syzergy = lambda f, g: Polynomial( [(f.leading_term() // g.leading_term())(p)] )

#         f, g, q = self % p, other % p, Polynomial([])
#         while f.degree() >= g.degree():
#             h = syzergy(f, g)
#             f = (f - h*g) % p
#             q = (q + h) % p
#         r = f % p

#         return q, r


#QQQQ - Consider where this goes... 
"""
QQQQ
"""
function extended_euclid_alg(a::Polynomial, b::Polynomial, prime::Int)
    old_r, r = mod(a,prime), mod(b,prime)
    old_s, s = one(Polynomial), zero(Polynomial)
    old_t, t = zero(Polynomial), one(Polynomial)

    while !iszero(mod(r,prime))
        q = divide(old_r, r)(prime) |> first
        old_r, r = r, mod(old_r - q*r, prime)
        old_s, s = s, mod(old_s - q*s, prime)
        old_t, t = t, mod(old_t - q*t, prime)
    end
    g, s, t = old_r, old_s, old_t
    @assert mod(s*a + t*b - g, prime) == 0
    return g, s, t  
end
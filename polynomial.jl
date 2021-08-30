struct Polynomial
    #QQQQ MutableBinaryMaxHeap or BinaryMaxHeap
    terms::MutableBinaryMaxHeap{Term}   #Will never have terms with 0 coefficient
    Polynomial() = new(MutableBinaryMaxHeap{Term}())
    Polynomial(h::MutableBinaryMaxHeap{Term}) = new(h) #QQQQ - check not to have 0 coefficient
end

function Polynomial(t::Term)
    terms = MutableBinaryMaxHeap{Term}()
    t.coeff != 0 && push!(terms,t)
    return Polynomial(terms)
end

function Polynomial(tv::Vector{Term})
    terms = MutableBinaryMaxHeap{Term}()
    for t in tv
        t.coeff != 0 && push!(terms,t)
    end
    return Polynomial(terms)
end

#QQQQ - Yoni clean up to use above constuctors
# """
# Convenience constructor 
# """
# function Polynomial(terms_tuples::Vector{Tuple{Int,Int}})
#     p = Polynomial()
#     for tt in terms_tuples
#         push!(p,Term(tt...))
#     end
#     return p
# end

#QQQQ - ideally do rand
# function rand(u::Type{T})::Polynomial where T<:Polynomial
#     @show hello
# end


#QQQQ - Yoni fiddle

function rand(::Type{Polynomial} ; degree::Int = -1, terms::Int = -1, max_coeff::Int = 100)
    if degree == -1
        degree = rand(Poisson(5)) #shifted Poisson
    end

    if terms == -1
        terms = rand(Binomial(degree+1,0.5))
    end

    degrees = sample(0:degree,terms,replace = false)
    coeffs = rand(1:max_coeff,terms)
    return Polynomial( [Term(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
end


#QQQQ Handle error if pushing another term of same degree
function push!(p::Polynomial, t::Term) 
    iszero(t) && return #don't push a zero
    push!(p.terms,t)
end
pop!(p::Polynomial) = pop!(p.terms)


#QQQQ - Maybe re-think when doing mod-p
leading(p::Polynomial)::Term = isempty(p.terms) ? Term(0,0) : first(p.terms)  #QQQQ should maybe use a "zero method" instead of Term(0,0)
degree(p::Polynomial)::Int = leading(p).degree 
iszero(p::Polynomial) = isempty(p.terms)

#QQQQ - Improve pretty printing
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

==(p1::Polynomial, p2::Polynomial)::Bool = p1.terms == p2.terms


#QQQQ - is this sensible (Paul/Andy)
==(p::Polynomial, n::T) where T <: Real = iszero(p) == iszero(n)

#QQQQ - Maybe have the "distributive addition" paradigm like multiplication (less efficient)

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


function -(p::Polynomial)::Polynomial
    p_temp = deepcopy(p)
    p_out = Polynomial()
    while !iszero(p_temp)
        push!(p_out,-pop!(p_temp))
    end
    return p_out
end

*(t::Term,p1::Polynomial)::Polynomial = iszero(t) ? Polynomial() : Polynomial(map((pt)->t*pt, p1.terms))
*(p1::Polynomial, t::Term)::Polynomial = t*p1

-(p::Polynomial) = Polynomial(map((pt)->-pt, p.terms)) #Can't specify return Polynomial?
-(p1::Polynomial, p2::Polynomial)::Polynomial = p1 + (-p2)

##Our naive multiplier
function *(p1::Polynomial, p2::Polynomial)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(p1.terms)) #tt is target term
        p_out = p_out + (tt * p2)
    end
    return p_out
end

#QQQQ - Yoni - use map as needed and also maintain not having Term(0,0) as invairant
function %(f::Polynomial, p::Int)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(f.terms))
        push!(p_out, tt % p) #if coeff reduced to zero, push! will handle it
    end
    return p_out
end

#QQQQ - use a "map" after making it.
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
        f, g = num % p, den % p
        degree(f) < degree(num) && return nothing #QQQQ ask Paul/Andy...
        iszero(g) && throw(DivideError())# QQQQ - is there a string with it???"polynomial is zero modulo $p"))
        q = Polynomial()
        prev_degree = degree(f)
        while degree(f) ≥ degree(g) 
            h = Polynomial( (leading(f) ÷ leading(g))(p) )  #syzergy #QQQQ - Andy/Paul-B - can we do automatic promoting (see line below)
            f = (f - h*g) % p
            q = (q + h) % p #QQQQ - would have auto promoted 
            prev_degree == degree(f) && break
            prev_degree = degree(f)
        end
        @assert iszero( (num  - (q*g + f)) %p)
        return q, f
    end
    return division_function
end

÷(num::Polynomial, den::Polynomial)  = (p::Int) -> first(divide(num,den)(p))
%(num::Polynomial, den::Polynomial)  = (p::Int) -> last(divide(num,den)(p))




# def divideby(self, other, p: int):
#         syzergy = lambda f, g: Polynomial( [(f.leading_term() // g.leading_term())(p)] )

#         f, g, q = self % p, other % p, Polynomial([])
#         while f.degree() >= g.degree():
#             h = syzergy(f, g)
#             f = (f - h*g) % p
#             q = (q + h) % p
#         r = f % p

#         return q, r


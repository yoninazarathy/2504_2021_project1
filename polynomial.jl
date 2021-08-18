struct Polynomial
    #QQQQ MutableBinaryMaxHeap or BinaryMaxHeap
    terms::MutableBinaryMaxHeap{Term}
    Polynomial() = new(MutableBinaryMaxHeap{Term}())
end

"""
Convenience constructor 
"""
function Polynomial(terms_tuples::Vector{Tuple{Int,Int}})
    p = Polynomial()
    for tt in terms_tuples
        push!(p,Term(tt...))
    end
    return p
end

#QQQQ Handle error if pushing another term of same degree
function push!(p::Polynomial, t::Term) 
    iszero(t) && return #don't push a zero
    push!(p.terms,t)
end
pop!(p::Polynomial) = pop!(p.terms)


#QQQQ - Maybe re-think when doing mod-p
leading(p::Polynomial)::Term = first(p.terms)
degree(p::Polynomial)::Int = leading(p).degree
iszero(p::Polynomial) = isempty(p.terms)

#QQQQ - Improve pretty printing
function Base.show(io::IO, p::Polynomial) 
    p = deepcopy(p)
    if iszero(p)
        print("0")
    else
        for t in extract_all!(p.terms)
            print(io, t, "+ ")
        end
    end
end

#QQQQ Yoni implement neg(-) and then we'll have subtration..

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

#QQQQ - improve !exctract_all

*(t::Term,p1::Polynomial)::Polynomial = Polynomial(map((tr)->t*tr,p1.terms))
*(p1::Polynomial, t::Term)::Polynomial = t*p1

function *(p1::Polynomial, p2::Polynomial)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(p1.terms)) #tt is target term
        p_out = p_out + (tt * p2)
    end
    return p_out
end

function %(f::Polynomial, p::Int)::Polynomial
    p_out = Polynomial()
    for tt in extract_all!(deepcopy(f.terms))
        push!(p_out, tt % p) #if coeff reduced to zero, push! will handle it
    end
    return p_out
end

#QQQQ - use a "map" after making it.
evaluate(f::Polynomial, x::T) where T <: Number = sum(evaluate(tt,x) for tt in extract_all!(deepcopy(f.terms)))

"""  Modular algorithm.
f divide by g

f = q*g + r

p is a prime
"""
function divideby(num::Polynomial, den::Polynomial, p::Int)::Tuple{Polynomial,Polynomial}
    f, g, q = num % p, den % p, Polynomial()
    while degree(f) ≥ degree(g)
        h = (leading(num) ÷ leading(den))(p) #syzergy
        f = (f - h*g) % p
        q = (q + h) % p
    end
    @assert f % p == (q*g+r)%p #QQQQ see Polynomials can equate.
    return q, f % p
end


# def divideby(self, other, p: int):
#         syzergy = lambda f, g: Polynomial( [(f.leading_term() // g.leading_term())(p)] )

#         f, g, q = self % p, other % p, Polynomial([])
#         while f.degree() >= g.degree():
#             h = syzergy(f, g)
#             f = (f - h*g) % p
#             q = (q + h) % p
#         r = f % p

#         return q, r

#############################################
#############################################
#############################################
# Testing zone...
#############################################
#############################################

# p1 = Polynomial([(2,5),(4,7),(9,17),(2,4),(-3,18),(-6,8)])
# p1 % 3
# @show p1 * Term(2,3)
p2 = Polynomial([(2,2),(-4,7)])
@show p2
@show evaluate(p2,2)
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
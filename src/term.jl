"""
A term.
"""
struct Term  #structs are immutable by default
    coeff::Int
    degree::Int
    function Term(coeff::Int, degree::Int)
        degree < 0 && error("Degree must be non-negative")
        coeff != 0 ? new(coeff,degree) : new(coeff,0)
    end
end

"""
Creates the zero term.
"""
zero(::Type{Term}) = Term(0,0)

"""
Creates the unit term.
"""
one(::Type{Term}) = Term(1,0)


"""
QQQQ
"""
Base.show(io::IO, t::Term) = print(io, "$(t.coeff)⋅x^$(t.degree)")

"""
QQQQ
"""
Base.iszero(t::Term) = iszero(t.coeff)

"""
QQQQ
"""
isless(t1::Term,t2::Term) =  t1.degree == t2.degree ? (t1.coeff < t2.coeff) : (t1.degree < t2.degree)  

"""
QQQQ
"""
function +(t1::Term,t2::Term)::Term
    @assert t1.degree == t2.degree
    Term(t1.coeff + t2.coeff, t1.degree)
end

"""
QQQQ
"""
-(t::Term) = Term(-t.coeff,t.degree)  #QQQQ - check with Andy why can't have ::Term as return value

"""
QQQQ
"""
-(t1::Term,t2::Term)::Term = t1 + (-t2) 

"""
QQQQ
"""
*(t1::Term,t2::Term)::Term = Term(t1.coeff * t2.coeff, t1.degree + t2.degree)

"""
QQQQ
"""
÷(t::Term,n::Int)::Term = Term(t.coeff ÷n, t.degree)

"""
QQQQ
"""
smod(t::Term,p::Int)::Term = Term(smod(t.coeff,p), t.degree)

"""
QQQQ
"""
derivative(t::Term) = Term(t.coeff*t.degree,max(t.degree-1,0))

"""
QQQQ
"""
function ÷(t1::Term,t2::Term)#::QQQQ what is return value???
    @assert t1.degree ≥ t2.degree
    f(p::Int)::Term = Term(smod((t1.coeff * int_inverse_smod(t2.coeff, p)), p), t1.degree - t2.degree)
end

#QQQQ - maybe there is a better "julian" name for it.
"""
QQQQ
"""
evaluate(t::Term, x::T) where T <: Number = t.coeff * x^t.degree
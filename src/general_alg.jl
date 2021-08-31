"""
QQQQ
"""
function quo(a::T,b::T) where T <: Int
    a < 0 && return -quo(-a,b)
    a < b && return 0
    return 1 + quo(a-b, b)
end

"""
QQQQ
"""
function euclid_alg(a, b, rem_function = %)
    b == 0 && return a
    return euclid_alg(b, rem_function(a,b), rem_function)
end

"""
QQQQ
"""
function ext_euclid_alg(a, b, rem_function = %, div_function = ÷)
    a == 0 && return b, 0, 1
    g, t, s = ext_euclid_alg(rem_function(b,a), a, rem_function, div_function)
    s = s - div_function(b,a)*t
    @assert g == a*s + b*t
    return g, s, t
end

"""
QQQQ
"""
pretty_print_egcd((a,b),(g,s,t)) = println("$a × $s + $b × $t = $g") #\times + [TAB]
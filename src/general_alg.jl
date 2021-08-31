function remainder(a::T,b::T) where T <: Int #Note that later we'll extend this to integral domains
    a < 0 && return remainder(-a,b) #short circuit evalution  #later replace `0` with `zero(T)`
    a < b && return a
    return remainder(a-b,b)
end

function quo(a::T,b::T) where T <: Int
    a < 0 && return -quo(-a,b)
    a < b && return 0
    return 1 + quo(a-b, b)
end

function euclid_alg(a, b, rem_function = %)
    b == 0 && return a
    return euclid_alg(b, rem_function(a,b), rem_function)
end

function ext_euclid_alg(a, b, rem_function = %, div_function = ÷)
    a == 0 && return b, 0, 1
    g, t, s = ext_euclid_alg(rem_function(b,a), a, rem_function, div_function)
    s = s - div_function(b,a)*t
    @assert g == a*s + b*t
    return g, s, t
end

pretty_print_egcd((a,b),(g,s,t)) = println("$a × $s + $b × $t = $g") #\times + [TAB]



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

function euclid_alg(a,b)
    (b == 0) && return a
    return euclid_alg(b, a % b)
end


function ext_euclid_alg(a,b)
    a == 0 && return b, 0, 1
    g, s, t = ext_euclid_alg(b % a, a)
    return g, t - (b ÷ a)*s, s
end

pretty_print_egcd((a,b),(g,s,t)) = println("$a × $s + $b × $t = $g") #\times + [TAB]

inverse_mod(a,m) = mod(ext_euclid_alg(a,m)[2],m);

"""
Symmetric mod for integers.
"""
function smod(a::Int, m::Int)::Int 
    crude_mod = mod(a,m)
    crude_mod > m ÷ 2 ? crude_mod - m : crude_mod
end


"""
Integer inverse symmetric mod
"""
function int_inverse_smod(a::Int, m::Int)::Int 
    if smod(a, m) == 0
        error("Can't find inverse of $a mod $m because $m divides $a") #QQQQ update to throw
    end
    return smod(ext_euclid_alg(a,m)[2],m)
end
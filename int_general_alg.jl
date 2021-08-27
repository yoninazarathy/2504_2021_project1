function int_inverse_mod(a ,m) 
    if a % m == 0
        error("Can't find inverse of $a mod $m because $m divides $a") #QQQQ update to throw
    end
    return mod(ext_euclid_alg(a,m)[2],m,)
end

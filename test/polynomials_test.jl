"""
Tests QQQQ.
"""
function prod_test_poly(;N::Int = 10^4, seed::Int = 0)
    # QQQQ - handle tests without dividing by zero.
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        prod = p1*p2
        @assert leading(prod) == leading(p1)*leading(p2)
    end

    p_base = Polynomial(Term(1,0))
    for _ in 1:N
        p = rand(Polynomial)
        prod = p_base*p
        @assert leading(prod) == leading(p_base)*leading(p)
        p_base = prod
    end
    println("prod_test_poly - PASSED")
end


"""
Tests QQQQ.
"""
function division_test_poly(;prime::Int = 101, N::Int = 10^4, seed::Int = 0)
    # QQQQ - handle tests without dividing by zero.
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        p_prod = p1*p2
        q, r = Polynomial(), Polynomial() #QQQQ how to expose from try to outside of it...
        try
            q, r = divide(p_prod,p2)(prime)
            if (q, r) == (nothing,nothing)
                println("Unlucky prime: $p1 is reduced to $(p1 % prime) modulo $prime")
                continue
            end
        catch e
            if typeof(e) == DivideError
                @assert mod(p2, prime) == 0
            else
                throw(e)
            end
        end
        @assert iszero( mod(q*p2+r - p_prod,prime) )
    end
    println("division_test_poly - PASSED")
end

"""
Tests QQQQ.
"""
function euclid_test_poly(;prime::Int=101, N::Int = 1,seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        g = euclid_alg(p1, p2, (a,b)-> (a%b)(prime))
        # @show (p1 % g)(prime), (p2 % g)(prime)
        @assert false
    end
    println("euclid_test_poly - PASSED")
end
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
                @assert (p2 % prime) == 0
            else
                throw(e)
            end
        end
        @assert iszero( (q*p2+r - p_prod)%prime )
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
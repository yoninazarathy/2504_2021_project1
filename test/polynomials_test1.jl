include("../poly_factorization_project.jl")

# QQQQ - handle tests without dividing by zero.
using Random;
function division_test_poly()
    Random.seed!(0)
    for _ in 1:100
        # print(".")
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        # @show p1
        # @show p2
        global p_prod = p1*p2
        prime = 101  #7919 
        # p_prod_reduced =  p_prod % prime
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

function euclid_test_poly(;prime::Int=101)
    Random.seed!(0)
    for _ in 1:2
        # print(".")
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        @show p1
        @show p2

        @show divide(p2,p1)(prime)

        # g = euclid_alg(p1, p2, (a,b)-> (a%b)(prime))
        # @show (p1 % g)(prime), (p2 % g)(prime)
    end
    println("euclid_test_poly - PASSED")
end




# division_test_poly()
euclid_test_poly()
# test_inverse_mod_poly()
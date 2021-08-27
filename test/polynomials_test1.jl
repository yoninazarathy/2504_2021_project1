include("../poly_factorization_project.jl")

#############################################
#############################################
#############################################
# Testing zone...
#############################################
#############################################

p1 = Polynomial(Term(1,2)) + Polynomial(Term(-1,0)) #x^2 - 1
p2 = Polynomial(Term(1,1)) + Polynomial(Term(1,0)) #x + 1


# ext_euclid_alg(p1, p2, (a,b)-> (a%b)(101), (a,b)-> (a ÷ b)(101)   )


# @show typeof((p1 % p2)(101))

# euclid_alg(p1, p2, (a,b)-> (a%b)(101)   )
# @show p1
# @show p2

# euclid_alg(Polynomial([Term(1,1),Term(1,0)]), Polynomial(Term(2,0)), (a,b)-> (a%b)(101)   )

#p3 = (Polynomial([Term(1,1),Term(1,0)]) ÷  Polynomial(Term(2,0)) )(101)

# Polynomial([Term(2,3),Term(4,5)])

# QQQQ - handle tests without dividing by zero.
using Random;
function division_test_poly()
    Random.seed!(0)
    for _ in 1:100
        print(".")
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
        # @show q, r
        @assert iszero( (q*p2+r - p_prod)%prime )
            #     println("found a problem:")
            #     @show p1, p2
            # end
    end
end

function test_inverse_mod_poly(prime::Int=101)
    Random.seed!(0)
    for _ in 1:1
        p = rand(Polynomial)
        ip = inverse_mod(p,prime,(a,b)-> (a%b)(prime),(a,b)-> (a \divb)(prime)) 
        @assert (n*im) % prime == 1
    end
end


function euclid_test_poly()
    Random.seed!(0)
    for _ in 1:3
        print(".")
        p1 = rand(Polynomial)
        p2 = rand(Polynomial)
        @show p1
        @show p2
        prime = 101  #7919 
        g = euclid_alg(p1, p2, (a,b)-> (a%b)(prime))
        @show (p1 % g)(prime), (p2 % g)(prime)
    end
end

euclid_test_poly()


# division_test()

# p1 = Polynomial([(2,5),(4,7),(9,17),(2,4),(-3,18),(-6,8)])
# p1 % 3
# @show p1 * Term(2,3)
# p1 = Polynomial([(1,2),(-1,0)])
# @show p1
# p2 = Polynomial([(1,1),(1,0)])
# @show p2

# @show p1 - p2
# divideby(p1,p2,101)

# p1 = Polynomial([Term(2,3),Term(5,2)])


# @show p2
# @show evaluate(p2,2)
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
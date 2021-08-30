include("../poly_factorization_project.jl")

using Random

function test_euclid_ints()
    Random.seed!(0)
    for _ in 1:1000
        n1 = rand(1:10^6)
        n2 = rand(1:10^6)
        g = euclid_alg(n1,n2)
        @assert n1 % g == 0 &&  n2 % g == 0
    end
    println("test_euclid_ints - PASSED")
end

function test_ext_euclid_ints()
    Random.seed!(0)
    for _ in 1:1000
        n1 = rand(1:10^6)
        n2 = rand(1:10^6)
        g, s, t = ext_euclid_alg(n1,n2)
        @assert g == s*n1 + t*n2
        @assert n1 % g == 0 &&  n2 % g == 0
    end
    println("test_ext_euclid_ints - PASSED")
end

function test_inverse_mod_ints(prime::Int=101)
    Random.seed!(0)
    for _ in 1:1000
        n = rand(1:10^6)
        if n % prime == 0
            continue #QQQQ - handle to actually catch the error thrown and continue testing...
        end
        im = int_inverse_mod(n,prime) 
        @assert (n*im) % prime == 1
    end
    println("test_inverse_mod_ints - PASSED")
end



test_euclid_ints()
test_ext_euclid_ints()
test_inverse_mod_ints()
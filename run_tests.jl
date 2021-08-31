include("poly_factorization_project.jl")

include("test/integers_test.jl")
test_euclid_ints()
test_ext_euclid_ints()

include("test/polynomials_test1.jl")
division_test_poly()
euclid_test_poly()
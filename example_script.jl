include("poly_factorization_project.jl")

x = x_poly()
p1 = 2x^3 + 4x^2 - 3x
p2 = 2x^4 - 4x^2 - 3x + 3

@show p1*p2
@show p1^3

@show derivative(p1*p2)
@show derivative(p1)*p2 + p1*derivative(p2);
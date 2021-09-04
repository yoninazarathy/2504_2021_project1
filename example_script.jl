include("poly_factorization_project.jl")

x = x_poly()
p1 = 2x^3 + 4x^2 - 3x
p2 = 2x^4 - 4x^2 - 3x + 3

@show p1*p2
@show p1^3

@show derivative(p1*p2)
@show derivative(p1)*p2 + p1*derivative(p2);

#QQQQ - make better example
@show (p1 ÷ p2)(101)
@show mod

gcd(p1,p2,101)

#From Maple 1
p1 = 4x^5 + 3x^4 + 6x^3 + 3x^2 + 4
p2 = 5x^4 + 2x^3 + 6x^2 + 5x + 6
p3 = 3x^3 + 4x^2 + 3x
p = p1*p2*p3
@show p

g = gcd(p,derivative(p),7)
@show g
p = (4p ÷ g)(7)
@show p
dd_factor(p,7)

# From Maple 2
p1 = 5x^5 + 6x^3 + 3x^2 + 2x + 2
p2 = 3x^4 + 4x^3 + 4x + 1
p3 = 6x^3 + 2x^2 + 6x + 5
p = p1*p2*p3
@show p

g = gcd(p,derivative(p),7)
@show g
p = (p ÷ g)(7)
@show p
dd_factor(p,7)

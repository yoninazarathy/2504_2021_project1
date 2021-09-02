#Fermat's little theorem
# a^p is congruent to to a mod p (for p prime)
# a^p-a = 0 mod p
# x^p-x = 0 mod p  True for any x
# Hence the factorization of the "special" polynomial x^p-x is known:  (x-0)(x-1)(x-2)...(x-(p-1))

# A polynomial has a root a
#QQQQ - Unit test (Yoni do....)

#Say we want to factor F
#That means we want f_1,...,f_k irreducible polynomials such that f_1^n_1* ... *f_k^n_k = F modulo prime
#The factorization process will initially give us f_1,...,f_k  (but not the powers...) so we do it 

#reconsider again the cyclotonic polynomial x^p-x (provided p is an odd prime, thus p-1 is even).

#x^p-x = x(x^(p-1) - 1) note that p-1 is even 
            # = x(x^(p-1)/2 - 1)(x^(p-1)/2 + 1)

#So the product of linear factors should factor into the (triple product) above 

#(x^p)^k-x is the product of all monic irreducible polynomials in Z_p(x) of degree d / k 

# function factor(f::Polynomial, prime::Int)
    
#     #Step 1 - remove the content of the polynomial 
#     f = prim_part(f)

#     #Step 2 - remove repeated roots (make the polynomial square free)
#     f = square_free(f)

#     #QQQQQ - Assume here we are square_free....

#     #Let's work on getting the linear factors
#     #This g is the product of all linear factors of f
#     g = gcd(f, cyclotonic_polynomial(prime), prime)
# end

# function factor_recusrive_clean(f::Polynomial,prime::Int)
#     if STOPPING CONDITION  -  
# end


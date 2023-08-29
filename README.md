# 2504_2021_project1 - Polynomial Factorization
# WARNING THIS IS FROM A PREVIOUS YEAR

This project implements polynomial arithmetic and polynomial factorization for polynomials with integer coefficients. 

Students are supposed to fork the project and create their modifications and improvements according [Project1 description](https://courses.smp.uq.edu.au/MATH2504/2021/assessment_html/project1.html).

To load all functionality run:

```
julia> include("poly_factorization_project.jl")
```

You may then use functionality such as,

```
julia> gcd(rand(Polynomial) + rand(Polynomial), rand(Polynomial), 101)
```

To execute all unit tests run:

```
julia> include("test/runtests.jl")
```

You may see examples in `example_script.jl` and run that script line by line.

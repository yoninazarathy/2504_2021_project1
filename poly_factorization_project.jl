using DataStructures, Distributions, StatsBase

import Base: push!, pop!, iszero, show, isless, map, map!, +, -, *, %, ÷, ==, rand, rem

include("heap_extensions.jl")
include("general_alg.jl")
include("term.jl")
include("polynomial.jl")
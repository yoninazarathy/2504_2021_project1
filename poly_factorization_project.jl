using DataStructures, Distributions, StatsBase, Random

import Base: %
import Base: push!, pop!, iszero, show, isless, map, map!, iterate, length, last
import Base: +, -, *, mod, ÷, ==, rand, rem, zero, one #QQQQ - maybe don't need mod here

include("src/heap_extensions.jl")
include("src/int_general_alg.jl")
include("src/general_alg.jl")
include("src/term.jl")
include("src/polynomial.jl")
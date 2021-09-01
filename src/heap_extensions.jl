"""
QQQQ
"""
==(h1::MutableBinaryMaxHeap, h2::MutableBinaryMaxHeap)::Bool = extract_all!(deepcopy(h1)) == extract_all!(deepcopy(h2))

"""
QQQQ
"""
function map!(f, h::MutableBinaryMaxHeap)
    for n in h.nodes
        update!(h, n.handle, f(n.value))
    end
    return h
end

"""
QQQQ
"""
map(f,h::MutableBinaryMaxHeap) = map!(f,deepcopy(h))

"""
QQQQ
"""
iterate(h::MutableBinaryMaxHeap, state=1) = state > length(h) ? nothing : (h.nodes[state].value, state+1)

"""
Very ineffcient for heap! Getting the minimal term from a Max Heap.
"""
#QQQQ  - probability delete this function
last(h::MutableBinaryMaxHeap) = last(extract_all!(deepcopy(h)))
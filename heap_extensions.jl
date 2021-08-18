function map!(f,h::MutableBinaryMaxHeap)
    for n in h.nodes
        update!(h, n.handle, f(n.value))
    end
    return h
end

map(f,h::MutableBinaryMaxHeap) = map!(f,deepcopy(h))

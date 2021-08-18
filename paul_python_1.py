from __future__ import annotations
from importlib import reload
from collections import defaultdict
from typing import List
import re

# programming a computer is like talking to a pedantic idiot.

def egcd(a, b):
    if not a:
        return b, 0, 1
    gcd, s, t = egcd(b % a, a)
    return gcd, t - (b // a) * s, s

def inverse(u, m):
    '''
    Calculates inverse of u modulo m
    '''
    g, inv, _ = egcd(u, m)
    if g > 1:
        return None
    return inv

class Term():
    def __init__(self, coeff: int, degree: int = 0):
        self.coeff  = coeff
        if coeff:
            self.degree = degree
        else:
            self.degree = 0

    def __bool__(self) -> Bool:
        return bool(self.coeff)

    def __eq__(self, other) -> Bool:
        (coeff, deg) = self.coeff, self.degree
        (doeff, eeg) = other.coeff, other.degree
        return coeff == doeff and deg == eeg

    def __str__(self) -> str:
        (coeff, deg) = self.coeff, self.degree

        sign = lambda x : "+" if x >= 0 else "-"
        
        if not deg:
            return sign(coeff) + str(abs(coeff))
        elif deg == 1:
            mono = "x"
        else:
            mono = "x^{}".format(deg)

        return ''.join(map(str,[sign(coeff), abs(coeff) if coeff not in [1,-1] else "", mono]))

    def __repr__(self) -> str:
        return str([self.coeff, self.degree])

    def __add__(self, other) -> Term:
        (coeff, deg) = self.coeff, self.degree
        (doeff, eeg) = other.coeff, other.degree

        if not deg == eeg:
            return None
        
        if not coeff + doeff:
            return Term(0)
            
        return Term(coeff+doeff, deg)

    def __sub__(self, other) -> Term:
        return self + (-other)

    def __neg__(self) -> Term:
        return Term(-self.coeff, self.degree)

    def __mul__(self, other) -> Term:
        (coeff, deg) = self.coeff, self.degree
        (doeff, eeg) = other.coeff, other.degree
        return Term(coeff*doeff, deg+eeg)

    def __mod__(self, prime: int) -> Term:
        (coeff, deg) = self.coeff, self.degree
        return Term(coeff % prime, deg)

    def __floordiv__(self, other):
        (coeff, deg) = self.coeff, self.degree
        (doeff, eeg) = other.coeff, other.degree
        if eeg > deg:
            return None
        return lambda p : Term(coeff*inverse(doeff, p) % p, deg-eeg)


class Polynomial():
    def __init__(self, terms: List[Term]):
        """
        terms :: List[Term]
        Precondition:  No like terms.
        """
        self.terms = sorted(terms, key=lambda term: term.degree, reverse=True)  # Make this a heap
        
        """
        # Include this if you want to dump precondition.
        # Combine like terms -- insanely inefficient to do this in initializer.
        self.terms = []
        temp = sorted(terms, key=lambda term: term.degree)
        while len(temp) >= 2:
            if temp[-1].degree == temp[-2].degree:
                temp[-2] = temp[-1] + temp[-2]
                temp.pop()
            else:
                self.terms.append(temp.pop())
        self.terms.extend(temp)
        """
    
    def __bool__(self):
        return bool(self.terms)

    def __str__(self):
        return str([str(term) for term in self.terms])

    def __repr__(self):
        ans = ''.join([str(term) for term in self.terms if term])

        if not ans:
            return "0"

        return ans[1:] if ans[0]=="+" else ans

    def __add__(self, other):
        ans, f, g = [], self.terms[::-1], other.terms[::-1]
        while f and g:
            if f[-1].degree == g[-1].degree:
                new_term = f.pop() + g.pop()
                if new_term:
                    ans.append(new_term)
            elif f[-1].degree > g[-1].degree:
                ans.append(f.pop())
            else: # g.degree > f.degree
                ans.append(g.pop())

        ans.extend(f)
        ans.extend(g)

        return Polynomial(ans[::-1])

    def __neg__(self):
        return Polynomial([-term for term in self.terms])

    def __sub__(self, other):
        return self + (-other)

    def __mul__(self, other):
        f, g = self, other
    
        if not f or not g:
            return Polynomial([])  # Zero polynomial

        if len(f) == len(g) == 1:
            return Polynomial([f.leading_term() * g.leading_term()])   # f[0] is leading term of f
        
        # (A+B)(C+D) = AC + AD + BC + BD 
        A, B = Polynomial(f.terms[:len(f)//2]), Polynomial(f.terms[len(f)//2:])
        C, D = Polynomial(g.terms[:len(g)//2]), Polynomial(g.terms[len(g)//2:])

        return A*C + A*D + B*C + B*D

    def __mod__(self, p: int) -> Polynomial:
        return Polynomial([Term(term.coeff % p, term.degree) for term in self.terms if term.coeff % p])

    def __len__(self) -> int:
        return len(self.terms)

    def leading_term(self):
        return self.terms[0]

    def evaluate(self):
        return None


if __name__ == "__main__":
    s = Term(16, 2)
    t = Term(22, 3)

    #f = Polynomial([s,t,Term(3,1),Term(7),Term(1,10),Term(-1,5)])
    #g = Polynomial([s])

    f = Polynomial([Term(1,1), Term(1,0)])
    g = Polynomial([Term(1,1), Term(-1,0)])
    h = f*g



###################################
###################################
###################################
def divideby(self, other, p: int):
        """  Modular algorithm.
        f divide by g

        f = q*g + r

        p is a prime
        """
        syzergy = lambda f, g: Polynomial( [(f.leading_term() // g.leading_term())(p)] )

        f, g, q = self % p, other % p, Polynomial([])
        while f.degree() >= g.degree():
            h = syzergy(f, g)
            f = (f - h*g) % p
            q = (q + h) % p
        r = f % p

        return q, r
# for 3x3 case
def isTernaryTriple(a):
    m=min(a)
    a=[x-m for x in a]
    if a==[0]*3:
        return True
    mods=sorted([a[i]%3 for i in range(3)])
    if mods[0]==mods[1] and mods[0]==mods[2]:
        return isTernaryTriple([a[i]//3 for i in range(3)])
    else:
        if mods==[0,1,2]:
            return True
        return False
def bal(A,verbose=False):
    A=matrix(A)
    n=A.nrows()
    if n==1:
        if verbose:
            print("1 x 1 matrix")
            print("already balanced")
            print("balancing index =",1)
        return 1
    if n==2:
        if verbose:
            print("2 x 2 matrix")
        b=2
        if A[0,0]==A[1,1] and A[0,1]==A[1,0]:
            b=1
            if verbose:
                print("symmetric, so already balanced")
        else:
            if verbose:
                print("not symmetric, so balanced via swap")
            if verbose:
                print("balancing index =",b)
    if n>=4:
        print("not yet ready")
        return 0
        return b
    if n==3:
        if verbose:
            print("3 x 3 matrix")
        if A[0,1]+A[1,2]+A[2,0]==A[1,0]+A[2,1]+A[0,2]:
            if verbose:
                print("broken diagonal sums equal")
            parity=1
        else:
            if verbose:
                print("broken diagonal sums unequal")
            parity=2
        d=[A[i,i] for i in range(3)]
        r=[sum([A[i,j] for j in range(3)]) for i in range(3)]
        c=[sum([A[j,i] for j in range(3)]) for i in range(3)]
        if isTernaryTriple(d) and isTernaryTriple(r) and isTernaryTriple(c):
            if verbose:
                print("diagonal, row sums, and column sums are ternary triples")
        else:
            b=3*parity
            if verbose:
                print("ternary triple condition fails")
                print("balancing index =",b)
            return b
        Theta=matrix([[1,1,1],d,r,c])
        if Theta.rank()<3:
            b=parity
            if verbose:
                print("local matrix has nontrivial kernel")
                print("balancing index =",b)
        else:
             b=3*parity
             if verbose:
                print("local matrix has trivial kernel")
                print("balancing index =",b)
        return b

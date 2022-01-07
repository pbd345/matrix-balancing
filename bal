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
        print("balancing index =",b)
        return b
    if n==3:
        print("not yet ready")
        return 0

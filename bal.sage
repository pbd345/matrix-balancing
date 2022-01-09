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
def matPerm(A,p):
    return matrix(A.nrows(),A.ncols(),lambda i,j:A[p[i],p[j]])
# off-diagonal line sums
def rowdegs(A):
    n=A.nrows()    
    return [sum(A[i,j] for j in range(n))-A[i,i] for i in range(n)]
def coldegs(A):
    n=A.nrows()    
    return [sum(A[i,j] for i in range(n))-A[j,j] for j in range(n)]
# triangle analysis
def smallestTriangle(A):
    n=A.nrows()
    ans=0
    perms=Permutations(range(n),3).list()
    for p in perms:
        [x,y,z]=p
        ans=gcd(ans,A[x,y]+A[y,z]+A[z,x]-A[y,x]-A[z,y]-A[x,z])
    return ans
val2=QQ.valuation(2)
def countMinTriangles(A):
    n=A.nrows()
    ans=[0]*n
    t=smallestTriangle(A)
    if t==0:
        return ans
    for h in range(n):
        for i in range(n):
            for j in range(i):
                if i!=h and j!=h:
                    thiscycweight=(A[h,i]+A[i,j]+A[j,h])-(A[i,h]+A[h,j]+A[j,i])
                    if val2.is_equivalent(t,thiscycweight):
                        ans[h]+=1
    return ans
# Four-cycle analysis
def box(A,p):
    n=A.nrows()
    r=list(range(4,n))
    A=matPerm(A,list(p)+[x for x in range(n) if x not in p])
    return A-matPerm(A,[1,0,2,3]+r)-matPerm(A,[0,1,3,2]+r)+matPerm(A,[1,0,3,2]+r)
def indexOfPrimitivity(A):
    n=A.nrows()
    perms=Permutations(range(n),4)
    ans=0
    for p in perms:
        M=box(A,p)
        ans=gcd(ans,M[0,2])
    return ans
from sage.modules.free_module_integer import IntegerLattice
def lat2d(S):
    n=len(S)
    m=matrix(ZZ,n,2,S)
    return sorted([x for x in m.LLL().rows() if x!=vector((0,0))],reverse=True)
def basisOfPrimitivity(A):
    n=A.nrows()
    perms=Permutations(range(n),4)
    gens=[]
    for p in perms:
        M=box(A,p)
        b=M[0,2]
        c=M[2,0]
        if vector((b,c)) not in gens:
            gens+=[vector((b,c))]
    return lat2d(gens)
import sage.combinat.permutation as permutation
def mypermFromCycle(n,a):
    if a[0]==a[1]:
        return list(range(n))
    b=[x+1 for x in a]
    p=permutation.from_cycles(n,[b])
    return [x-1 for x in p]
def tilde(A,r):
    n=A.nrows()
    perms=Permutations(range(n))
    L=(1-n)*A+sum(matPerm(A,mypermFromCycle(n,[r,j])) for j in range(n))
    return matPerm(L,mypermFromCycle(n,[0,r]))
def bal(A,verbose=False):
    A=matrix(A)
    n=A.nrows()
    if verbose:
        print(n,"x",n,"matrix")
    if n==1:
        if verbose:
            print("already balanced")
            print("balancing index =",1)
        return 1
    if n==2:
        b=2
        if A[0,0]==A[1,1] and A[0,1]==A[1,0]:
            b=1
            if verbose:
                print("already balanced")
                print("balancing index =",b)
        else:
            if verbose:
                print("balanced via swap")
                print("balancing index =",b)
        return b
    if n==3:
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
    if n>=4:
        p=A.trace()
        diagonal=[A[i,i] for i in range(n)]
        rd=rowdegs(A)
        cd=coldegs(A)
        ee=sum(rd)
        mt=countMinTriangles(A)
        la=[tilde(A,i)[0,1] for i in range(n)]
        lb=[tilde(A,i)[1,0] for i in range(n)]
        bop=basisOfPrimitivity(A)
        if verbose:
            print("diagonal:",diagonal)
            print("off-diagonal row sums:",rd)
            print("off-diagonal col sums:",cd)
        local_lat_basis=[vector([1,rd[i],cd[i],mt[i],la[i],lb[i],diagonal[i]]) for i in range(n)]+[vector([0,0,0,2,0,0,0])]+[vector([0,0,0,0,u[0],u[1],0]) for u in bop]
        m=matrix(ZZ,local_lat_basis)
        Lambda=IntegerLattice(m)
        testvector=vector([1,ee/n,ee/n,0,ee/n/(n-1),ee/n/(n-1),p/n])
        for b in range(1,factorial(n)+1):
            if factorial(n)%b==0:
                if b*testvector in Lambda:
                    if verbose:
                        print("balancing index =",b)
                    return b
    return "ERROR -- no balancing found" # hopefully never occurs

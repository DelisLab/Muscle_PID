function [Opt_rank,Vs,Q]=Link_Consensus(X,Type)

%%X is a cell array of adjacency matrices
%%Type==1 aggregrates the binary matrices generated from link_communities and determines modularity using the Louvain method.
%%Type==2 applies a multiplex generalisation of the louvain algorithm directly to the set of binary adjacency matrices. 
        %Requires GenLouvain package to be imported: https://github.com/GenLouvain/GenLouvain

%%Outputs:
        %Opt_rank: The number of overlapping modules identified that can be used as the input parameter for dimensionality reduction
        %Vs: A set of binary adjacency matrices describing the link-based community structure of X.
        %Q: The Q-statistic corresponding to the modularity maximising cost-function.
        

Vs=[];
for i=1:length(X)
    try
        M=link_communities(X{i},'single');
        
        for ii=1:size(M,1)
            Vs=cat(3,Vs,M(ii,:)'.*M(ii,:));
        end
    catch message
    end
    
end

if Type==1
    [M,Q]=community_louvain(sum(Vs,3));
    Opt_rank=max(M);
    
elseif Type==2
        
    N=length(Vs(:,:,1));
    T=size(Vs,3);
    ii=[]; jj=[]; vv=[];
    twomu=0;
    for s=1:T
        indx=[1:N]'+(s-1)*N;
        [i,j,v]=find(Vs(:,:,s));
        ii=[ii;indx(i)]; jj=[jj;indx(j)]; vv=[vv;v];
        k=sum(Vs(:,:,s));
        kv=zeros(N*T,1);
        twom=sum(k);
        twomu=twomu+twom;
        kv(indx)=k/twom;
        kcell{s}=kv;
    end
    gamma=1;
    omega=1;
    AA = sparse(ii,jj,vv,N*T,N*T);
    clear ii jj vv
    kvec = full(sum(AA));
    all2all = N*[(-T+1):-1,1:(T-1)];
    AA = AA + omega*spdiags(ones(N*T,2*T-2),all2all,N*T,N*T);
    twomu=twomu+T*omega*N*(T-1);
    B = @(i) AA(:,i) - gamma*kcell{ceil(i/(N+eps))}*kvec(i);
    
    [S,Q] = iterated_genlouvain(B);
    S = reshape(S,N,T);
    Opt_rank=max(max(S));
end

end

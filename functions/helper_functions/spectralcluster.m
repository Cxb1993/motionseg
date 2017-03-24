% affmat is the affinity matrix A
% k is the number of largest eigenvectors in matrix L
% num_class is the number of classes

%diagmat is the diagonal matrix D^(-0.5)
% Lmat is the matrix L
%X and Y ar matrices formed from eigenvectors of L
% IDX is the clustering results
% errorsum is the distance from kmeans

function [diagMat,LMat,X,Y,IDX,errorsum]= spectralcluster(affMat,k,num_class)

numDT=size(affMat,2);

diagMat= diag((sum(affMat,2)).^(-1./2));
LMat=diagMat*affMat*diagMat;
LMat=fix(LMat*10^4)/10^4;
% if ~all(all(LMat==LMat'))
%     yj=1;
% end


if k==0
    [v,d]=eigs(LMat,numDT);
    k=find_rank(diag(d));
    num_class=k;
else
    [v,d]=eigs(LMat,k);
end

X=v(:,1:k);
normX=(sum(X.^2,2)).^(1./2);
Y=zeros(size(X));
for index=1:numDT
    Y(index,:)=X(index,:)./normX(index,1);
end

[IDX,C,sumd] = kmeans(Y,num_class,'EmptyAction','drop','Replicates',10);
%[C,IDX] = kmeans(Y,num_class);

errorsum=1;%sum(sum(sumd));
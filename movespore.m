function [newsol]=movespore(pop,i,j,nspore,Dave,varsize,e,alpha,m,w)
spore.Position=[];
spore.cost=inf;
newspore=repmat(spore,nspore,1);
CostFunction=@(x) Ackley(x); 
for k=1:nspore
    newspore(k).Position=pop(i).Position+rand(varsize).*(Dave^-m).*(pop(i).Position-pop(j).Position)*w+alpha*e;
    newspore(k).cost=CostFunction(newspore(k).Position);
end
for k=1:nspore
    spo(k)=newspore(k).cost;
end
minspore=min(spo);
for k=1:nspore
    if minspore==newspore(k).cost
        minindex=k;
        newsol.Position=newspore(minindex).Position;
    elseif k==nspore
        newsol.Position=newspore(1).Position;
    end
end

%newsol.cost=newspore(minindex).cost;
end


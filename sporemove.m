function [newsol]=movespore(pop,i,j,nspore,Dave,varsize,e)
spore.Position=[];
spore.cost=inf;
newspore=repmat(spore,nspore,1);
CostFunction=@(x) Rosenbrock(x); 
for k=1:nspore
    newspore(k).Position=pop(i).Position+rand(varsize).*exp(Dave^-2).*(pop(i).Position-pop(j).Position)+alpha*e;
    newspore(k).cost=CostFunction(newspore(k).Position)
end
for k=1:nspore
    spo(k)=newspore(k).cost;
end
minspore=min(spo);
for k=1:nspore
    if minspore==newspore(k).cost
        minindex=k;
    end
end
newsol.Position=newspore(minindex).Position;
newsol.cost=newspore(minindex).cost;
end


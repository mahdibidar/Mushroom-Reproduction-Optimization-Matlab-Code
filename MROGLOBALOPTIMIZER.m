%%%______________MUSHROOM REPRODUCTION OPTIMIZATION ALGORITHM______________
% Mushroom Reproduction Optimization (MRO) proposed and developed by Mahdi Bidar 2016-06-01 (university Of Regina)
%MRO inspired by Mushrooms'lifecycle in nature
%Spores of mushrooms move by wind and animal to different part of the
%environment-> rich areas will be found.
% Usage: For global optimization tasks.
%Supervisors:
%Dr Hamidreza Rashidykanan, Dr Malek Mouhoub and Dr Samira Sadaoui
%__________________________________________________________________________

clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) Rosenbrock(x);        % Cost Function
nVar=5;                                 % Problem Dimensionality
VarSize=[1 nVar];                       % Decision Variables Matrix Size (Solution Size)

VarMin=-2;                             % Decision Variables Lower Bound
VarMax= 2;                             % Decision Variables Upper Bound

%% MRO Algorithm Parameters

MaxIt=2000;                       % Maximum Number of Iterations

nPop=10;                         %Population size (Number of the parent MUSHROOMS)

alpha=0.2;                       % Mutation Coefficient

alpha_damp=0.95;                 % Mutation Coefficient Damping Ratio

delta=0.05*(VarMax-VarMin);      % Uniform Mutation Range
w=0.9;                           %inertia weight
m=1;                             % User-defined constant number for changing the step size of the movement
nspore=4;                         %Number of the spores each parent mushroom is allowd to distribute
radius=1;                        %Radius that Mushrooms distribute their spores in local development

%% Initialization

%Empty Mushroom Structure for keeping information about each colony
mushroom.Position=[];
mushroom.Cost=[];

%Initialize Population Array (Matrix of structure for all mushrooms)
pop=repmat(mushroom,nPop,1);

% Initialize Best Solution
BestSol.Cost=inf;

% Distributing initial mushrooms on the problem space and evaluating thier
% fitness
for i=1:nPop
   pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
   pop(i).Cost=CostFunction(pop(i).Position);
   %Updating Best solution
   if pop(i).Cost<=BestSol.Cost
       BestSol=pop(i);
   end
end

% Array to keep Best Cost Values
BestCost=zeros(MaxIt,1);
%% Choose your desired Selection Method
%ANSWER=questdlg('Choose selection method:','MRO Algorithm',...
 %   'Roulette Wheel','Best','Roulette Wheel');

%UseRouletteWheelSelection=strcmp(ANSWER,'Roulette Wheel');
%UseTournamentSelection=strcmp(ANSWER,'Best');


%if UseRouletteWheelSelection
 %   beta=8; % Selection Pressure
%end
%% LOCAL DEVELOPMENT OF THE MUSHROOM COLONIES
[pop,ave,Tave,newsol]=localsearch(pop,nPop,nspore,radius,VarSize);

%% MUSHROOM Algorithm Main Loop

for it=1:MaxIt
    newpop=repmat(mushroom,nPop,1);
    for i=1:nPop
        newpop(i).Cost = inf;
        if (~isequal(ave(i),Tave))
        for j=1:nPop
            %%%%%%%%%% Check if a colony needs to move or not
            
            if pop(j).Cost < pop(i).Cost
                %%%%%%%%%%%%%%%%%%%%
                Dave=(Tave/ave(i));
                %%%Randome part Movement of the colony
                e=delta*unifrnd(-1,+1,VarSize);
           %%%%move spores by wind
               [newsol]=movespore(pop,i,j,nspore,Dave,VarSize,e,alpha,m,w);
           %%%Checking to See If the solution is in the Problem Range
                newsol.Position=max(newsol.Position,VarMin);
                newsol.Position=min(newsol.Position,VarMax);
           %%%%Evaluating The New Foun Solution     
                newsol.Cost=CostFunction(newsol.Position);
                
                if newsol.Cost <= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost<=BestSol.Cost
                        BestSol=newpop(i);
                    end
                end
            end
         end
            %%%%LOCAL DEVELOPMENT OF THE COLONIES
            [pop,ave,Tave,newsol]=localsearch(pop,nPop,nspore,radius,VarSize);
             %newsol.Cost=CostFunction(newsol.Position);
                
                if newsol.Cost <= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost<=BestSol.Cost
                        BestSol=newpop(i);
                    end
                end
        else
         [pop,ave,Tave,newsol]=localsearch(pop,nPop,nspore,radius,VarSize);
          %newsol.Cost=CostFunction(newsol.Position);
                
                if newsol.Cost <= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost<=BestSol.Cost
                        BestSol=newpop(i);
                    end
                end
        end
    end
    
    % Merging the Structure
    pop=[pop
         newpop];  
    
    % Sort The solutions according to their Cost
    [~, SortOrder]=sort([pop.Cost]);
    pop=pop(SortOrder);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Mutation Coefficient
    alpha = alpha*alpha_damp;
    
end

%% Results

figure;
%plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

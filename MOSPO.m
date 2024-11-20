

%__________________________________________________________________ %
%                          Multi-Objective                          %
%        Multi-Objetective Stochastic Paint Optimizer (MOSPO)       %
%                                                                   %
%                                                                   %
%                  Developed in MATLAB R2021a (MacOs)               %
%                                                                   %
%                      Author and programmer                        %
%                ---------------------------------                  %
%                      Nima Khodadadi (ʘ‿ʘ)                         %
%                       SeyedAli Mirjalili                          %
%                             e-Mail                                %
%                ---------------------------------                  %
%                         nkhod002@fiu.edu                          % 
%                                                                   %
%                            Homepage                               %
%                ---------------------------------                  %
%                    https://nimakhodadadi.com                      %
%                                                                   %
%                                                                   %
%                                                                   %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %





%% Outputs:
% BestColors       (Best solution)
% BestFitness      (final Best fitness)
% Conv_History     (Convergence History Curve)

function[Archive_costs]=MOSPO(MaxIt,Archive_size,Colors_Number,nVar,method,m)
% clc;
% clear;
% close all;
disp('MOSPO is running')
drawing_flag = 0;
%% Simple Problem Definition




   if method==3
         
        TestProblem=sprintf('P%d',m);
        
        fobj = Ptest(TestProblem);
        
        xrange  = xboundaryP(TestProblem);
        nVar=max(size(xrange));
        % Lower bound and upper bound
        lb=xrange(:,1)';
        ub=xrange(:,2)';
        
    end



%% MOSPO Parameters


alpha=0.1;  % Grid Inflation Parameter
nGrid=30;   % Number of Grids per each Dimension
beta=4; %=4;    % Leader Selection Pressure Parameter
gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure



%% Updating the Size of ProblemParams (If Necessary)
if length(lb)==1
    lb=repmat(lb,1,nVar);
end
if length(ub)==1
    ub=repmat(ub,1,nVar);
end

%% initialization
% Number of each group
SPO=CreateEmptyParticle(Colors_Number);
Colors=zeros(Colors_Number,nVar);
for i=1:Colors_Number
    SPO(i).Velocity=0;
    SPO(i).Position=zeros(1,nVar);
    for j=1:nVar
        SPO(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    SPO(i).Cost=fobj(SPO(i).Position')';
    Colors(i,:)=SPO(i,:).Position;
%     Funeval(i,:)=norm(SPO(i).Cost);
    SPO(i).Best.Position=SPO(i).Position;
    SPO(i).Best.Cost=SPO(i).Cost;
end

SPO=DetermineDominations(SPO);
Archive=GetNonDominatedParticles(SPO);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

N1stColors=fix(Colors_Number/3);
N2ndColors=fix(Colors_Number/3);
N3rdColors=Colors_Number-N1stColors-N2ndColors;



%% Main Loop

for Iter=1:MaxIt
    for ind=0:Colors_Number
        Leader=SelectLeader(Archive,beta);

        Group1st=Colors(1:N1stColors,:);
        Group2nd=Colors(1+N1stColors:N1stColors+N2ndColors,:);
        Group3rd=Colors((N1stColors+N2ndColors+1):Colors_Number,:);
        
        % Complement Combination
        Id1=randi(N1stColors); % Select one color blongs to the 1st group
        Id2=randi(N3rdColors); % Select one color blongs to 3st group
        SPO(4*ind+1,:).Position=Leader.Position+rand(1,nVar).*(Group1st(Id1,:)-Group3rd(Id2,:));
        
        % Analog Combination
        if ind<=N1stColors
            Id=randi(N1stColors,2);
            AnalogGroup=Group1st;
        elseif ind<=N1stColors+N2ndColors
            Id=randi(N2ndColors,2);
            AnalogGroup=Group2nd;
        else
            Id=randi(N3rdColors,2);
            AnalogGroup=Group3rd;
        end
        SPO(4*ind+2,:).Position=Leader.Position+rand(1,nVar).*(AnalogGroup(Id(2),:)-AnalogGroup(Id(1),:));
        
        % Triangle Combination
        Id1=randi(N1stColors); % Select a color blengs to the 1st group
        Id2=randi(N2ndColors); % Select a color blengs to the 2nd group
        Id3=randi(N3rdColors); % Select a color blengs to the 3rd group
        
        SPO(4*ind+3,:).Position=Leader.Position+rand(1,nVar).*(Group1st(Id1,:)+Group2nd(Id2,:)+Group3rd(Id3,:))/3;
        
        % Rectangle Combination
        Id1=randi(N1stColors); % Select a color blengs to the  1st group
        Id2=randi(N2ndColors); % Select a color blengs to the  2nd group
        Id3=randi(N3rdColors); % Select a color blengs to the  3rd group
        Id4=randi(Colors_Number);% Select a color blengs to the  all groups
        
        SPO(4*ind+4,:).Position=Leader.Position+(rand(1,nVar).*Group1st(Id1,:)+rand(1,nVar).*Group2nd(Id2,:)+...
            rand(1,nVar).*Group3rd(Id3,:)+rand(1,nVar).*Colors(Id4,:))/4;
        
        %i2=randi(size(NewColors,1))
        for i2=1:4
      
            SPO(4*ind+i2,:).Position=min(max(SPO(4*ind+i2).Position,lb),ub);
     
            SPO(4*ind+i2,:).Cost=fobj(SPO(4*ind+i2,:).Position')';
            %
        end

    end
    SPO=DetermineDominations(SPO);
    non_dominated_SPO=GetNonDominatedParticles(SPO);
    
    Archive=[Archive
        non_dominated_SPO];
    
    Archive=DetermineDominations(Archive);
    Archive=GetNonDominatedParticles(Archive);
    
    
    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);
        
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
        
    end
    
    disp(['In iteration ' num2str(Iter) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
    
    costs=GetCosts(SPO);
    Archive_costs=GetCosts(Archive);

    if drawing_flag==1
        hold off
        plot(costs(1,:),costs(2,:),'k.');
        hold on
        plot(Archive_costs(1,:),Archive_costs(2,:),'rO','MarkerFaceColor','r');
        legend('SPO','Non-dominated solutions');
        drawnow
    end
    
    
end  

end

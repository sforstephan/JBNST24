

rng('shuffle');

%x(1)=fl
%x(2)=a
%x(3)=p
%x(4)=productivity
%x(5)=para
%x(6)=aara
%x(7)=disa
%x(8)=resutil
%x(9)=eqeffort
%x(10)=umw
%-------------------------------------------------------------------------
%variable definition (fixed, for baseline scenario)
fl=0; %fixed salary component of agent
productivity=50; %productivity of agents
araP=0; %Arrow-Pratt-Measure principal
araA=0.5; %Arrow-Pratt-Measure agent
disA=2; %Disutility-Exponent agent
resutil=0; %Reservation utility
eqeffort=1; %Equidistance effort 
umwM=0; %variable for the mean of the environment
%-------------------------------------------------------------------------
%variable definition (for simulation scenarios)
explorationDegree=0; 
jfrom=1;
simRuns=jto-jfrom+1;
%How many additional candidate solutions are calculated in each run
aknown=2; %amount of additional candidate solutions. Candidate solutions are the solution of t-1 + amount of aknown
%----
% variables not relevant for this simulation study
araASD=0; 
disASD=araASD;
productivitySD=araASD;
aarAM=0;
disAM=0; 
productivityM=0;
%----
maxT=20; %variable for the timesteps. 
fragmentation=1; %fragmentation of the search space (not relevant in this simulation study)
%-------------------------------------------------------------------------
%Structure for saving the results
ordner=strxcat('umwSD_',umwSD,'--sims_from_',jfrom,'--sims_to',jto,'--maxT_',maxT);
pfad=strxcat(pwd,'/results/',ordner);
mkdir(pfad);
pfadEndergebnis=strxcat(pfad,'/final');
pfadZwischenergebnis=strxcat(pfad,'/einzelneSims');
mkdir(pfadEndergebnis);
mkdir(pfadZwischenergebnis);
%-------------------------------------------------------------------------
%reference solution (according to secondbest agency-theory)
%for reference solution set environmental factor at umw
%x(10)=umw;
%starting points for optimization (correspond to the fixed values)
%umwM used for environmental factor (later in the simulation this value gets replaced
%with the expected value)
x0=[fl,10,0.1,productivity,araP,araA,disA,resutil,eqeffort,umwM];
%linear inequality constraints
A=[];
b=[];
%linear equality constraints
Aeq=[1,0,0,0,0,0,0,0,0,0; %fl (place 2 (a) and palce 3 (p) not set)
    0,0,0,1,0,0,0,0,0,0; %productivity
    0,0,0,0,1,0,0,0,0,0; %para
    0,0,0,0,0,1,0,0,0,0; %aara
    0,0,0,0,0,0,1,0,0,0; %disa
    0,0,0,0,0,0,0,1,0,0; %resutil
    0,0,0,0,0,0,0,0,1,0; %eqeffort
    0,0,0,0,0,0,0,0,0,1; %umw
    ];
%Target values for linear equality constraints
beq=[fl;productivity;araP;araA;disA;resutil;eqeffort;umwM];
%nonlinear equality and inequality constraints in CONFUN_firstbest &
%CONFUN_secondbest
options=optimoptions(@fmincon,'Algorithm','interior-point','Display','none','UseParallel',true);
%invoke optimization routine
if araP==0
    [x]=fmincon('UP_objfun_lin',x0,A,b,Aeq,beq,[],[],'CONFUN_secondbest',options);
else
    [x]=fmincon('UP_objfun_nonlin',x0,A,b,Aeq,beq,[],[],'CONFUN_secondbest',options);
end
opta=x(2);
optp=x(3);
optUP=UP(x(1),x(2),x(3),x(4),x(5),x(10));
optUA=UA(x(2),x(7),x(9),x(1),x(3),x(4),x(6),x(10));
optoutcome=PROD(x(2),x(4),x(10));
umwSD=optoutcome/100*umwSD;
%-------------------------------------------------------------------------
%looking for max effort level
x0=[fl,opta,optp,productivity,araP,araA,disA,resutil,eqeffort,umwM];
[x,fval,exitflag]=fmincon('maxa_objfun',x0,A,b,Aeq,beq,[],[],'CONFUN_maxa',options);

maxa=real(x(2));
maxp=real(x(3));
maxUP=UP(x(1),x(2),x(3),x(4),x(5),x(10));
maxUA=UA(x(2),x(7),x(9),x(1),x(3),x(4),x(6),x(10));
maxoutcome=PROD(x(2),x(4),x(10));

clear x x0 Aeq beq; %options, A und b stay the same
%-------------------------------------------------------------------------
%Search effort level (a) and premium paramter (p)with limited knowledge of the activity room


%loop for the simulation
%-------------------------------------------------------------------------
initialVars=who;
%Vectors and variables for function values during simulation. Not all are
%relevant for this simulation study
%(save for every simulation run (700))
exploration=zeros(1,maxT); 
forcedJumps=zeros(1,maxT);
exitFlags=zeros(1,maxT);
UP_P=zeros(1,maxT); %Utility of the principal from his point of view
UA_P=zeros(1,maxT); %Utility of the agent from the principal's point of view
a_P=zeros(1,maxT); %Effort level, incited by the principal
p_P=zeros(1,maxT); %premium paramter selected by the principal
UA_A=zeros(1,maxT); %Utility of the agent from his point of view
a_A=zeros(1,maxT); %Effort level selected by the agent
outcome_realized=zeros(1,maxT);
UA_realized=zeros(1,maxT);
UP_realized=zeros(1,maxT);
lostUP=zeros(1,maxT);
lostUA=zeros(1,maxT);
lostoutcome=zeros(1,maxT);
araAEst_P=zeros(1,maxT); 
disaEst_P=zeros(1,maxT); 
productivityEst_P=zeros(1,maxT); 
resutilEst_P=zeros(1,maxT); 
umwEst_P=zeros(1,maxT); %Principal's estimation of the environmental variable
umwEst_A=zeros(1,maxT); %Agent's estimation of the environmental variable
umw_realized=zeros(1,maxT); %Realized value of the environmental variable
control_minatmpGroesserMaxatmp=zeros(1,maxT);
control_maxatmpNegativ=zeros(1,maxT);
countTrys=0; 


%-------------------------------------------------------------------------
%begin of the simulation
for j=jfrom:1:jto
    %-------------------------------------------------------------------------
    for t=1:1:maxT
        %first period
        if t==1
            %not used in the simulation study
            if araASD==0
                araAForecast=0;
            else
                araAForecast=randn()*araASD+aarAM;
            end
            if disASD==0
                disAForecast=0;
            else
                disAForecast=randn()*disASD+disAM;
            end
            if productivitySD==0
                productivityForecast=0;
            else
                productivityForecast=randn()*productivitySD+productivityM;
            end
                       
            %generating random effort level a
            %starting point for the optimization with limited knowledge
            %of the activity room
            %Important: for t=0 umwM (environment mean) is set to 0 in
            %vector x, because principal has no information
            x=[fl,(0+maxa*rand()),0,(productivity*(1+productivityForecast)),araP,(araA*(1+araAForecast)),(disA*(1+disAForecast)),resutil,eqeffort,0];
            
            while isreal(Estimate_p(x))==false
                  x(2)=0+maxa*rand();
            end
            %----------------------------------------------
            %Principal's point of view
            %generating premium parameter p 
            x(3)=Estimate_p(x);
            a_P(t)=x(2); %incited a of the principal
            p_P(t)=x(3); %corresponding p
            %Calculating the utility of the principal and the agent for the
            %first period
            UP_P(t)=UP(x(1),x(2),x(3),x(4),x(5),x(10));
            UA_P(t)=UA(x(2),x(7),x(9),x(1),x(3),x(4),x(6),x(10));
            %save estimations of the first period (not all are used in this
            %simulation study)
            araAEst_P(t)=x(6);
            disaEst_P(t)=x(7);
            productivityEst_P(t)=x(4);
            resutilEst_P(t)=x(8);
            umwEst_P(t)=x(10);
            %variables which are fixed:
            %fl, eqeffort, para
            %----------------------------------------------
            %Agent's point of view!
            %Vector for agent's point of view. Same structure as for the
            %principal before
            x=[fl 0 p_P(t) productivity araP araA disA resutil eqeffort 0];
            %agent chooses an effort level
            x(2)=Estimate_a(x);
            %save the choosen effort level
            a_A(t)=x(2);
            %save the utility of the agent
            UA_A(t)=UA(x(2),x(7),x(9),x(1),x(3),x(4),x(6),x(10));
            umwEst_A(t)=x(10);
            %----------------------------------------------
            %save realized values
            %calculate realized environmental factor
            umw_realized(t)=randn()*umwSD+umwM;
            %Calculate outcome and the utilities of the principal and the
            %agent
            outcome_realized(t)=PROD(a_A(t),productivity,umw_realized(t));
            UP_realized(t)=UP(fl,a_A(t),p_P(t),productivity,araP,umw_realized(t));
            UA_realized(t)=UA(a_A(t),disA,eqeffort,fl,p_P(t),productivity,araA,umw_realized(t));
            %Calculate lost utility(P and A) and lost outcome
            lostUP(t)=UP_realized(t)-optUP;
            lostUA(t)=UA_realized(t)-optUA;
            lostoutcome(t)=outcome_realized(t)-optoutcome;
     
            clear araAForecast disAForecast productivityForecast x;
            %for all periods of a simulation run >1
        else
            %----------------------------------------------
            %Principal's point of view!
            %estimate the environmental factor for t-1
            umwEst_P(t) = outcome_realized(t-1) - (PROD(a_P(t-1),productivityEst_P(t-1),umwEst_P(t-1))-umwEst_P(t-1));
            %Estimate the agent's characteristics (not used in this
            %simulation study)
            araAEst_P(t)=araAEst_P(t-1);
            disaEst_P(t)=disaEst_P(t-1);
            productivityEst_P(t)=productivityEst_P(t-1);
            resutilEst_P(t)=resutilEst_P(t-1);
            
            %NEW OPTIONS FOR LIMITED ABILITY TO OPTIMIZE
            options=optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1.0e-2,'Display','none','UseParallel',true);
            
            %Decide if Exploration or Exploitation (not used in this
            %simulation study)
            if limitedMemoryP==false
                minatmp=real(Estimate_mina(productivityEst_P(t),mean( umwEst_P(1:t))));
            else 
                if t>=memoryP 
                    minatmp=real(Estimate_mina(productivityEst_P(t),mean( umwEst_P((t-(memoryP-1)):t))));
                else 
                    minatmp=real(Estimate_mina(productivityEst_P(t),mean( umwEst_P(1:t))));
                end
            end
            
            Aeq=[1,0,0,0,0,0,0,0,0,0; %fl
                0,0,0,1,0,0,0,0,0,0; %productivity
                0,0,0,0,1,0,0,0,0,0; %para
                0,0,0,0,0,1,0,0,0,0; %aara
                0,0,0,0,0,0,1,0,0,0; %disa
                0,0,0,0,0,0,0,1,0,0; %resutil
                0,0,0,0,0,0,0,0,1,0; %eqeffort
                0,0,0,0,0,0,0,0,0,1; %umw
                ];
            
            x0=[fl,maxa,maxp,productivityEst_P(t),araP,araAEst_P(t),disaEst_P(t),resutilEst_P(t),eqeffort,mean(umwEst_P(1:t))];
 
            if limitedMemoryP==false
                beq=[fl;productivityEst_P(t);araP;araAEst_P(t);disaEst_P(t);resutilEst_P(t);eqeffort;mean(umwEst_P(1:t))];
            else 
                if t>=memoryP 
                    beq=[fl;productivityEst_P(t);araP;araAEst_P(t);disaEst_P(t);resutilEst_P(t);eqeffort;mean(umwEst_P((t-(memoryP-1)):t))];
                else 
                    beq=[fl;productivityEst_P(t);araP;araAEst_P(t);disaEst_P(t);resutilEst_P(t);eqeffort;mean(umwEst_P(1:t))];
                end
            end    
            
            maxagroesser = 0;   
            while maxagroesser == 0
               
            [x,fval,exitflag]=fmincon('maxa_objfun',x0,A,b,Aeq,beq,[],[],'CONFUN_maxa',options);
           
             if real(x(2))>minatmp
                 maxagroesser =1;
                 maxatmp=real(x(2));
             end
             if countTrys >1000 && real(x(2))<minatmp
                  disp('maxatmp_if');
                  disp(maxatmp);
                 maxagroesser =1;
                 maxatmp=maxatmp;  
             end
             countTrys=countTrys+1;
            end
           
            startp=real(x(3));
            
            %only a check. not relevant for results
            if maxatmp<0
                control_maxatmpNegativ(t)=1;
            else
                control_maxatmpNegativ(t)=0;
            end
            if maxatmp<minatmp
                control_minatmpGroesserMaxatmp(t)=1;
            else
                control_minatmpGroesserMaxatmp(t)=0;
            end
                   
            %calculate boundaries for the set of effort levels the
            %principal can incite (want to incite)
            if a_P(t-1)>=minatmp && a_P(t-1)<=maxatmp
                forcedJump=false;
                if a_P(t-1)-(((maxatmp-minatmp)/fragmentation)/2)<=0
                    lb_StatusQuo=1E-10;
                else
                    lb_StatusQuo=a_P(t-1)-(((maxatmp-minatmp)/fragmentation)/2);
                end

                if a_P(t-1)+(((maxatmp-minatmp)/fragmentation)/2)>=maxatmp
                    ub_StatusQuo=maxatmp;
                else
                    ub_StatusQuo=a_P(t-1)+(((maxatmp-minatmp)/fragmentation)/2);
                end
            else
                forcedJump=true;
            end
            forcedJumps(t)=forcedJump;
            %Preparation for the optimization
            %Prepare vector for the optimization (find p for the discovered effort levels)
            if limitedMemoryP==false
                x=[fl 0 0 productivityEst_P(t) araP araAEst_P(t) disaEst_P(t) resutilEst_P(t) eqeffort mean(umwEst_P(1:t))];
                tmpMean=mean(umwEst_P(1:t));
                tmpStd=std(umwEst_P(1:t));
            else 
                if t>=memoryP 
                    x=[fl 0 0 productivityEst_P(t) araP araAEst_P(t) disaEst_P(t) resutilEst_P(t) eqeffort mean(umwEst_P((t-(memoryP-1)):t))];
                    tmpMean=mean(umwEst_P((t-(memoryP-1)):t));
                    tmpStd=std(umwEst_P((t-(memoryP-1)):t));
                else 
                    x=[fl 0 0 productivityEst_P(t) araP araAEst_P(t) disaEst_P(t) resutilEst_P(t) eqeffort mean(umwEst_P(1:t))];
                    tmpMean=mean(umwEst_P(1:t));
                    tmpStd=std(umwEst_P(1:t));
                end
            end
            
            %Generating the additional a (in our case 2 additional)
            %2 possible options. Exploration and exploitation. Only one is
            %used in this simulation study
             if umwEst_P(t)<Estimate_exphurdle(explorationDegree,tmpMean,tmpStd) || forcedJump==true
                exploration(t)=true;
                for n=1:1:(1+aknown)
                    exitflag=-1;
                    while exitflag<=0                      
                            x(2)=minatmp+(maxatmp-minatmp)*rand();
                        

                        x(3)=Estimate_p(x);
                        if isnan(x(3))==true
                            exitflag=-1;
                        else
                            exitflag=1;
                        end
                    end
                    exitFlags(t)=exitflag;
                    
                    if n==1
                        tmpa=x(2);
                        tmpp=x(3);
                        tmpUP=UP(x(1),x(2),x(3),x(4),x(5),x(10));
                    else
                        if UP(x(1),x(2),x(3),x(4),x(5),x(10))>tmpUP && x(3)>0
                            tmpa=x(2);
                            tmpp=x(3);
                            tmpUP=UP(x(1),x(2),x(3),x(4),x(5),x(10));
                        end
                    end
                end %end of loop for exploration
            else
                %begin exploitation
                exploration(t)=false;
                for n=1:1:(1+aknown)
                    exitflag=-1;
                    while exitflag<=0
                        
                        
                        if n==1
                            x(2)=a_P(t-1);
                        else
                            x(2)=lb_StatusQuo+(ub_StatusQuo-lb_StatusQuo)*rand();
                        end
                        x(3)=Estimate_p(x);
                        if isnan(x(3))==true
                            exitflag=-1;
                        else
                            exitflag=1;
                        end
                       
                    end
                    
                    exitFlags(t)=exitflag;
                    
                    if n==1
                        tmpa=x(2);
                        tmpp=x(3);
                        tmpUP=UP(x(1),x(2),x(3),x(4),x(5),x(10));
                    else
                        if UP(x(1),x(2),x(3),x(4),x(5),x(10))>tmpUP && x(3)>0
                            tmpa=x(2);
                            tmpp=x(3);
                            tmpUP=UP(x(1),x(2),x(3),x(4),x(5),x(10));
                        end
                    end
                end
            end %End
            %after the "best" a is found
            %safe "best" a and the corresponding p in
            %Vector x
            a_P(t)=tmpa; %a, incited by the principal
            p_P(t)=tmpp; %correspoding premium parameter
            %Caculate and safe the principal's and agent's utility from the
            %principals point of view
            UP_P(t)=UP(x(1),a_P(t),p_P(t),x(4),x(5),x(10));
            UA_P(t)=UA(a_P(t),x(7),x(9),x(1),p_P(t),x(4),x(6),x(10));
           
            
            clear tmpa tmpp tmpUP tmpMean tmpStd fval output x exitflag;
            
            %----------------------------------------------
            %Agent's point of view!
            %Estimate the environmental factor
            umwEst_A(t)=outcome_realized(t-1)-(PROD(a_A(t-1),productivity,umwEst_A(t-1))-umwEst_A(t-1));
            %Vector for the agent's point of view. Same structure as for the principal
            
            if limitedMemoryA==false
                x=[fl 0 p_P(t) productivity araP araA disA resutil eqeffort mean(umwEst_A(1:t))];
            else 
                if t>=memoryA
                    x=[fl 0 p_P(t) productivity araP araA disA resutil eqeffort mean(umwEst_A((t-(memoryA-1)):t))];
                else 
                    x=[fl 0 p_P(t) productivity araP araA disA resutil eqeffort mean(umwEst_A(1:t))];
                end
            end 
            
            %Agent chooses an effort level 
            x(2)=Estimate_a(x);
            %safe effort level
            a_A(t)=x(2);
            %safe the agent's utility (utility the agent expects)
            UA_A(t)=UA(x(2),x(7),x(9),x(1),x(3),x(4),x(6),x(10));
            clear x;
            %----------------------------------------------
            %safe realized values
            %Calculate environmental factor
            umw_realized(t)=randn()*umwSD+umwM;
            %Calculate outcome, and the principal's and agent's utility
            outcome_realized(t)=PROD(a_A(t),productivity,umw_realized(t));
            UP_realized(t)=UP(fl,a_A(t),p_P(t),productivity,araP,umw_realized(t));
            UA_realized(t)=UA(a_A(t),disA,eqeffort,fl,p_P(t),productivity,araA,umw_realized(t));
            %Calculate lost outcome and lost utilities
            lostUP(t)=UP_realized(t)-optUP;
            lostUA(t)=UA_realized(t)-optUA;
            lostoutcome(t)=outcome_realized(t)-optoutcome;
            %End  
        end
        %-------------------------------------------------------------------------
    end
    %safe interim results
    filename=num2str(j);
    save([pfadZwischenergebnis '/' filename '.mat']);
end
%End

%Safe interim results in final results
clearvars('-except',initialVars{:})
filelist=dir([pfadZwischenergebnis '/*.mat']);
numfiles=length(filelist);
 
UP_P_sims=zeros(numfiles,maxT);
UA_P_sims=zeros(numfiles,maxT);
a_P_sims=zeros(numfiles,maxT);
p_P_sims=zeros(numfiles,maxT);
UA_A_sims=zeros(numfiles,maxT);
a_A_sims=zeros(numfiles,maxT);
outcome_realized_sims=zeros(numfiles,maxT);
UA_realized_sims=zeros(numfiles,maxT);
UP_realized_sims=zeros(numfiles,maxT);
lostUP_sims=zeros(numfiles,maxT);
lostUA_sims=zeros(numfiles,maxT);
lostoutcome_sims=zeros(numfiles,maxT);
control_minatmpGroesserMaxatmp_sims=zeros(numfiles,maxT);
control_maxatmpNegativ_sims=zeros(numfiles,maxT);

for ii=1:1:numfiles
    tmp=load([pfadZwischenergebnis '/' filelist(ii).name]);
    UP_P_sims(ii,:)=tmp.UP_P;
    UA_P_sims(ii,:)=tmp.UA_P;
    a_P_sims(ii,:)=tmp.a_P;
    p_P_sims(ii,:)=tmp.p_P;
    UA_A_sims(ii,:)=tmp.UA_A;
    a_A_sims(ii,:)=tmp.a_A;
    outcome_realized_sims(ii,:)=tmp.outcome_realized;
    UA_realized_sims(ii,:)=tmp.UA_realized;
    UP_realized_sims(ii,:)=tmp.UP_realized;
    lostUP_sims(ii,:)=tmp.lostUP;
    lostUA_sims(ii,:)=tmp.lostUA;
    lostoutcome_sims(ii,:)=tmp.lostoutcome;
    control_minatmpGroesserMaxatmp_sims(ii,:)=tmp.control_minatmpGroesserMaxatmp;
    control_maxatmpNegativ_sims(ii,:)=tmp.control_maxatmpNegativ;
    clear tmp;
end


filename=strxcat('final_',date,'_umwSD=',umwSD,'_limitedmemoryP=',limitedMemoryP, 'limitedmemoryA=',limitedMemoryA,'memorylengthP=',memoryP,'memorylengthA=',memoryA,'--sims=',simRuns,'--maxT=',maxT);
save([pfadEndergebnis '/' filename '.mat']);

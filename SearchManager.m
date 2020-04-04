clc;
clear;
close all;

global initial_flag

global NFE
%%  Globalization of Parameters and Settings 

global ProblemSettings;
global SM_Settings;
    
nVar=10;   % Number of decision variables 
DiversityPlot=[]; Diversitycount=0;
for Grp=[10 ]
	for Fm=[100]
		for Rm=[0.25]

			for Func=1:25
				Diversitycount=0;
				topology=1; policy=1; % Migration process parameters      Fm = 300;     
				switch Func
					 case 1 
						 VarMin = -100;
						 VarMax = 100;
						 bias=450;
					 case 2
						 VarMin = -100;
						 VarMax = 100; 
						 bias=450;
					 case 3
						 VarMin = -100;
						 VarMax = 100;   
						 bias=450;
					 case 4
						 VarMin = -100;
						 VarMax = 100;                 
						 bias=450;
					 case 5
						 VarMin = -100;
						 VarMax = 100;                 
						 bias=310;
					 case 6
						 VarMin = -100;
						 VarMax = 100;   
						 bias=-390;
					 case 7
						 VarMin = 0;
						 VarMax = 600;
						 bias=180;
					 case 8   
						 VarMin = -32;
						 VarMax = 32;
						 bias=140;
					 case 9
						 VarMin = -5;
						 VarMax = 5;
						 bias=330;
					 case 10
						 VarMin = -5;
						 VarMax = 5;
						 bias=330;
					 case 11
						 VarMin = -0.5;
						 VarMax = 0.5;
						 bias=-90;
					 case 12
						 VarMin = -pi;
						 VarMax = pi;
						 bias=460;
					 case 13
						 VarMin = -5;
						 VarMax = 5;
						 bias=130;
					 case 14
						 VarMin = -100;
						 VarMax = 100;
						 bias=300;
					 case 15    
						 VarMin = -5;
						 VarMax = 5;
						 bias=-120;
					 case 16
						 VarMin = -5;
						 VarMax = 5;
						 bias=-120;
					 case 17
						 VarMin = -5;
						 VarMax = 5;
						 bias=-120;
					 case 18
						 VarMin = -5;
						 VarMax = 5;
						 bias=-10;
					 case 19
						 VarMin = -5;
						 VarMax = 5;
						 bias=-10;
					 case 20
						 VarMin = -5;
						 VarMax = 5;
						 bias=-10;
					 case 21
						 VarMin = -5;
						 VarMax = 5;
						 bias=-360;
					 case 22
						 VarMin = -5;
						 VarMax = 5;
						 bias=-360;
					 case 23
						 VarMin = -5;
						 VarMax = 5;
						 bias=-360;
					 case 24
						 VarMin = -5;
						 VarMax = 5;
						 bias=-260;
					 case 25
						 VarMin = 2;
						 VarMax = 5;
						 bias=-260;
				end

				CostFunction=@(x) benchmark_func(x,Func);

				VarSize=[1 nVar];   % Decision Variables Matrix Size

				%% SEARCH MANAGER Parameters

				MaxIt=1650;         % 860 in WOA + TLBO  Maximum Number of Iterations

				nPop=60;            % Population Size
				nGroup=Grp;           % Number of Groups     

				nStyle=2;           % Number of Movement Styles
				%% Initialization

				ProblemSettings.CostFunction=CostFunction;
				ProblemSettings.nVar=nVar;
				ProblemSettings.VarSize=VarSize;
				ProblemSettings.VarMin=VarMin;
				ProblemSettings.VarMax=VarMax;

				SM_Settings.MaxIt=MaxIt;
				SM_Settings.nPop=nPop;
				SM_Settings.nGroup=nGroup;
				SM_Settings.nStyle=nStyle;

				BestCosts=[];
				DiversityPlot=[];
				MeanCosts=[];
				
				%% Search Manager Main Loop                
				for Run=1:1
					Diversitycount=Diversitycount+1;
					rng('shuffle');
					% Initialize Organization
					initial_flag = 0;
					SM_Settings.BestIndividual.Cost = inf;
					SM_Settings.BestIndividual.Decision = zeros(1,nVar);

					Structure=Create_Initial_Stucture(); 
					NFE=0;

					%% Determine Best
					DetermineBest(Structure, 0);

					it=0;
					while (it<MaxIt)
						it=it+1;

						SM_Settings.W=(0.9-0.4)*((MaxIt-it)/MaxIt)+0.4;

						% Movement Operation
						Structure=Movement(Structure, Func, it);        

						% Dominations ...
						DetermineBest(Structure, 0);
						MeanCosts(it, Run) = DetermineMeanCost( Structure );
						% Migration ...
						% Fm: Migration Period, Rm: Migration Rate 
						if rem(it, Fm)==0
							Structure=Migration(Structure, Rm, topology, policy);
						end

						%BestCosts(it, Run)=SM_Settings.BestIndividual.Cost+bias;
						BestCosts(it, Diversitycount)=SM_Settings.BestIndividual.Cost+bias;              
						disp(['F=' num2str(Func) '  RUN=' num2str(Run) '  In=' num2str(Grp) '  Fm=' num2str(Fm) '  Rm=' num2str(Rm) '  Iteration ' num2str(it) ' :  # Best Cost = ' num2str(SM_Settings.BestIndividual.Cost)]);    						
						

					end
				end

			end % End FOR functions
		end
	end
end % END of Groups
 
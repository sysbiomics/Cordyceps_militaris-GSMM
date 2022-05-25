%% WORKSPACE
cd '/Users/nachonase/Documents/GitHub/Cordyceps_militaris-GSMM';
initCobraToolbox;
%setRavenSolver('cobra');
%% STEP 0: Load the model
load('model/mat/iPC1469.mat');
iPC1469Model = model;
%% STEP 5: MODEL VALIDATION
%% 5.1: Growth capability
% The model validation was performed against experimental data 
% obtained from previous study by Raethong et al., (2018).
finalValidateModel = iPC1469Model;
finalValidateModel = setParam(finalValidateModel,'lb',{'bmOUT','cordycepinOUT'},[0 0]);
finalValidateModel = setParam(finalValidateModel,'eq',{'matp'},1);
finalValidateModel = setParam(finalValidateModel,'ub',{'bmOUT','cordycepinOUT'},[1000 1000]);
finalValidateModel = setParam(finalValidateModel,'obj',{'bmOUT'},1);
sol = solveLP(finalValidateModel,1);
% The following information was reported in Table 2
sugars = {'glcIN' 'fruIN' 'arabIN' 'xylIN' 'sucIN'};
uptake = [0.1448,0.1472,0.1074,0.0681,0.0815]; %observed from experiment
sumax(1) = sol;

for i = 1:numel(uptake)
    model=setParam(finalValidateModel,'ub',sugars,[0 0 0 0 0]);
    model=setParam(model,'ub',sugars(i),uptake(i));
    sugar = sugars(i);
    sol = solveLP(model,1);
    sumax(i) = sol;
    umax = num2str(sol.f*-1);
    fprintf([char(sugar) '\t' num2str(sol.f*-24) ' per day' '\n']);
end

%% 5.2: Synthesis capabilities of sphingolipid derivatives
% the biosynthetic capabilities of the improved model 
% for sphingolipid derivatives were tested by flux balance analysis (FBA). 
% To explore this, the secretion reaction of corresponding products 
% was set as the object function to perform FBA, 
% in which the production rates above zero pointed 
% that the model gained the corresponding biosynthetic capacity. 

iPC1469 = setParam(iPC1469Model,'ub',{'glcIN'},[25]);
iPC1469 = setParam(iPC1469,'eq',{'bmOUT'},[1]);

finalValidateModel0 = setParam(iPC1469,'obj',{'cordycepinOUT'},1);
finalValidateModel1 = setParam(iPC1469,'obj',{'exc C16 sphinganine'},1);
finalValidateModel2 = setParam(iPC1469,'obj',{'exc C17 sphinganine'},1);
finalValidateModel3 = setParam(iPC1469,'obj',{'exc phytosphingosine'},1);
finalValidateModel4 = setParam(iPC1469,'obj',{'exc C17 sphingosine'},1);

sol0 = solveLP(finalValidateModel0,1);
fprintf(['production rate of cordycepin' '\t' num2str(sol0.f*-1) ' mmol/g DW/h' '\n']);
sol1 = solveLP(finalValidateModel1,1);
fprintf(['production rate of C16 sphinganine' '\t' num2str(sol1.f*-1) ' mmol/g DW/h' '\n']);
sol2 = solveLP(finalValidateModel2,1);
fprintf(['production rate of C17 sphinganine' '\t' num2str(sol2.f*-1) ' mmol/g DW/h' '\n']);
sol3 = solveLP(finalValidateModel3,1);
fprintf(['production rate of phytosphingosine' '\t' num2str(sol3.f*-1) ' mmol/g DW/h' '\n']);
sol4 = solveLP(finalValidateModel4,1);
fprintf(['production rate of C17 sphingosine' '\t' num2str(sol4.f*-1) ' mmol/g DW/h' '\n']);

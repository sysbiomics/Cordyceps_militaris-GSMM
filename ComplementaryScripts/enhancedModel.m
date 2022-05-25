%% Reconstruction process
% Purposed: Here is a script for enhancing a GEM of Cordyceps militaris, iN1329 
% through metabolite footprint profiles integration.  
% This included the 4 steps.c
% This is an iterative process which ends up with an enhanced GEM 
% that can represent the synthesis capacities of sphingolipid derivatives of C. militaris.
% 
% Written by Nachon Raethong, 09-APR-2022
% Updated by Nachon Raethong, 24-May-2022

%% WORKSPACE
cd '/Users/nachonase/Documents/GitHub/Cordyceps_militaris-GSMM';
initCobraToolbox;
%setRavenSolver('cobra');
%% STEP 0: Load the model
load('ComplementaryData/model.mat');
iNR1329Model = model;
iNR1329Cobra = ravenCobraWrapper(iNR1329Model);
iNR1329Raven = ravenCobraWrapper(iNR1329Cobra);
%Check the model !!
finalValidateModel = iNR1329Raven;
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
    fprintf([num2str(sol.f*-1) '\n']);
end



%% STEP 1: Incorperating metabolite footprint profiles
% Addition of new metabolites to the model
[~, newMets]=xlsread('ComplementaryData/supplementary.xlsx','Sheet2');
metsToAdd = struct();
metsToAdd.mets = newMets(2:end,2);
metsToAdd.metNames = newMets(2:end,2);
metsToAdd.metFormulas = newMets(2:end,5);
metsToAdd.compartments = 'c';
metsToAdd.inchis = newMets(2:end,10);
addMetsModel=addMets(iNR1329Raven,metsToAdd);
addMetsModel = contractModel(addMetsModel);

addMetsModel.equations = constructEquations(addMetsModel);
sol = solveLP(addMetsModel,1);
sol.f

%% STEP 2: Gapfilling
% Introduction of newly-identified rxns to the model.
[~, SheetS]=xlsread('ComplementaryData/supplementary.xlsx','NewTR');
ac5_newRxns = struct();
ac5_newRxns.rxns = SheetS(2:end,1);
ac5_newRxns.rxnNames = SheetS(2:end,2);
ac5_newRxns.equations = SheetS(2:end,3);
ac5_newRxns.eccodes = SheetS(2:end,4);
ac5_newRxns.grRules = SheetS(2:end,5);
%Add new genes
genesToAdd = struct();
genesToAdd.genes = {'CCM_01242','CCM_05029'};
addMetsModel=addGenesRaven(addMetsModel,genesToAdd);
new2 = addRxns(addMetsModel,ac5_newRxns,3,'',true,true);
new2.equations = constructEquations(new2);
new2 = sortModel(new2);
new3 = contractModel(new2);

[a, b]=ismember(new2.rxns,ac5_newRxns.rxns);
I=find(a);
new2.rev(I)=0;
reducedModel=new3;
for i = 1:numel(ac5_newRxns.rxns)
    if reducedModel.rev(i) == 1
        reducedModel=setParam(reducedModel,'lb',ac5_newRxns.rxns(i),[-1000])
        reducedModel=setParam(reducedModel,'ub',ac5_newRxns.rxns(i),[1000])
    else
        reducedModel=setParam(reducedModel,'lb',ac5_newRxns.rxns(i),[0])
        reducedModel=setParam(reducedModel,'ub',ac5_newRxns.rxns(i),[1000])
    end
end

reducedModel.equations = constructEquations(reducedModel);
sold = solveLP(reducedModel,1)
iPC1469Raven=reducedModel;
save('ComplementaryData/iPC1469Raven.mat','iPC1469Raven');
%% Add new genes updated from roypim data 
%iNR1329_model = model;
iNR1329_model = iPC1469Raven;

[~, newGenes]=xlsread('ComplementaryData/supplementary_2.xlsx','new_genes');
genesToAdd = struct();
genesToAdd.genes = newGenes(2:end,1);

iPlus_Model=addGenesRaven(iNR1329_model,genesToAdd);

[~, newGrRules]=xlsread('ComplementaryData/supplementary_2.xlsx','new_gr');
rxnID = newGrRules(2:end,1);
geneAssoc = newGrRules(2:end,2);
%take time
for i = 1:numel(rxnID)
    rxn = rxnID(i);
    new = geneAssoc{i};
    iPlus_Model = changeGeneAssoc(iPlus_Model,rxn,new,true);
end

iPlus2_Model = contractModel(iPlus_Model);
iPlus3_Model=deleteUnusedGenes(iPlus_Model);
sol = solveLP(iPlus3_Model,1);
iPC1469 = iPlus3_Model;
iPC1469.id = 'iPC1469';
iPC1469.name = 'iPC1469';
iPC1469.description = 'Enhanced C. militaris GSMM [15-APR-2022]';
iPC1469.annotation = [];
iPC1469.rxnReferences =iPC1469.rxns;
printModelStats(iPC1469);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exportForGit(iPC1469,'iPC1469',...
   '/Users/nachonase/Documents/GitHub/Cordyceps_militaris-GSMM',...
  {'mat', 'txt', 'xlsx', 'xml'});


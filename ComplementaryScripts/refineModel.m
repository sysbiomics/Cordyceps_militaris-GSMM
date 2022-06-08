%% WORKSPACE
cd '/Users/nachonase/Documents/GitHub/Cordyceps_militaris-GSMM';
initCobraToolbox;
%setRavenSolver('cobra');
%% STEP 0: Load the model
modelOri = readCbModel('ComplementaryData/iPC1469.xml');
%% STEP 1: reformat the model
iPC1469raven=ravenCobraWrapper(modelOri);
iPC1469cobra=ravenCobraWrapper(iPC1469raven);
iPC1469cobra.metFormulas{53, 1}=char('');
iPC1469cobra.metFormulas{54, 1}=char('');
iPC1469cobra.metFormulas{55, 1}=char('');
iPC1469cobra.metFormulas{56, 1}=char('');
iPC1469cobra.metFormulas{118, 1}=char('');
iPC1469cobra.metFormulas{329, 1}=char('');
iPC1469cobra.metFormulas{334, 1}=char('');
iPC1469cobra.metFormulas{382, 1}=char('');
iPC1469cobra.metFormulas{387, 1}=char('');
iPC1469cobra.metFormulas{389, 1}=char('');
iPC1469cobra.metFormulas{392, 1}=char('');
iPC1469cobra.metFormulas{402, 1}=char('');
iPC1469cobra.metFormulas{408, 1}=char('');
iPC1469cobra.metFormulas{409, 1}=char('');
iPC1469cobra.metFormulas{413, 1}=char('');
iPC1469cobra.metFormulas{418, 1}=char('');
iPC1469cobra.metFormulas{421, 1}=char('');
iPC1469cobra.metFormulas{423, 1}=char('');
iPC1469cobra.metFormulas{424, 1}=char('');
iPC1469cobra.metFormulas{426, 1}=char('');
iPC1469cobra.metFormulas{429, 1}=char('');
iPC1469cobra.metFormulas{431, 1}=char('');
iPC1469cobra.metFormulas{436, 1}=char('');
iPC1469cobra.metFormulas{439, 1}=char('');
iPC1469cobra.metFormulas{441, 1}=char('');
iPC1469cobra.metFormulas{443, 1}=char('');
iPC1469cobra.metFormulas{445, 1}=char('');
iPC1469cobra.metFormulas{576, 1}=char('');
iPC1469cobra.metFormulas{611, 1}=char('');
iPC1469cobra.metFormulas{810, 1}=char('');
iPC1469cobra.metFormulas{834, 1}=char('');
iPC1469cobra.metFormulas{836, 1}=char('');
iPC1469cobra.metFormulas{843, 1}=char('');
iPC1469cobra.metFormulas{844, 1}=char('');
iPC1469cobra.metFormulas{848, 1}=char('');
iPC1469cobra.metFormulas{851, 1}=char('');
iPC1469cobra.metFormulas{856, 1}=char('');
iPC1469cobra.metFormulas{858, 1}=char('');
iPC1469cobra.metFormulas{860, 1}=char('');
iPC1469cobra.metFormulas{920, 1}=char('');
iPC1469cobra.metFormulas{935, 1}=char('');
iPC1469cobra.metFormulas{936, 1}=char('');
iPC1469cobra.metFormulas{1026, 1}=char('');
iPC1469cobra.metFormulas{1027, 1}=char('');
iPC1469cobra.metFormulas{1038, 1}=char('');
iPC1469cobra.metFormulas{1048, 1}=char('');
iPC1469cobra.metFormulas{1052, 1}=char('');
iPC1469cobra.metFormulas{1180, 1}=char('');
iPC1469cobra.metFormulas{1231, 1}=char('');
iPC1469cobra.metFormulas{1234, 1}=char('');
iPC1469cobra.metFormulas{1240, 1}=char('');
iPC1469cobra.metFormulas{1247, 1}=char('');
iPC1469cobra.metFormulas{1289, 1}=char('');
iPC1469cobra.metFormulas{1322, 1}=char('');
iPC1469cobra.metFormulas{1323, 1}=char('');
iPC1469cobra.metFormulas{1324, 1}=char('');
iPC1469cobra.metFormulas{1326, 1}=char('');
iPC1469cobra.metFormulas{1332, 1}=char('');
iPC1469cobra.metFormulas{1334, 1}=char('');
iPC1469cobra.metFormulas{1337, 1}=char('');
iPC1469cobra.metFormulas{1344, 1}=char('');
iPC1469cobra.metFormulas{1359, 1}=char('');
iPC1469cobra.metFormulas{1360, 1}=char('');
iPC1469cobra.metFormulas{1368, 1}=char('');
iPC1469cobra.metFormulas{1373, 1}=char('');
iPC1469cobra.metFormulas{1396, 1}=char('');
iPC1469cobra.metFormulas{1430, 1}=char('');
iPC1469cobra.metFormulas{1438, 1}=char('');
iPC1469cobra.metFormulas{1439, 1}=char('');
iPC1469cobra.metFormulas{1442, 1}=char('');
iPC1469cobra.metFormulas{1443, 1}=char('');
iPC1469cobra.metFormulas{1447, 1}=char('');
iPC1469cobra.metFormulas{1448, 1}=char('');
iPC1469cobra.metFormulas{1451, 1}=char('');
iPC1469cobra.metFormulas{1452, 1}=char('');
iPC1469cobra.metFormulas{1455, 1}=char('');
iPC1469cobra.metFormulas{1457, 1}=char('');
%writeCbModel(iPC1469cobra, 'format','sbml', 'fileName', 'iPC1469cobra.xml');
%iPC1469raven2=importModel('iPC1469cobra.xml');
%exportForGit(iPC1469raven2,'iPC1469raven2',...
%   '/Users/nachonase/Documents/GitHub',...
%  {'xlsx'});
%% STEP 2: refine the model
cd '/Users/nachonase/Documents/GitHub/Cordyceps_militaris-GSMM';
iPC1469raven3=importExcelModel('ComplementaryData/iPC1469raven2.xlsx')

finalValidateModel = iPC1469raven3;
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

iPC1469 = setParam(iPC1469raven3,'ub',{'glcIN'},[25]);
iPC1469 = setParam(iPC1469,'eq',{'bmOUT'},[1]);

finalValidateModel0 = setParam(iPC1469,'obj',{'cordycepinOUT'},1);
finalValidateModel1 = setParam(iPC1469,'obj',{'exc sphinganine'},1);
finalValidateModel2 = setParam(iPC1469,'obj',{'exc sphingosine'},1);
finalValidateModel3 = setParam(iPC1469,'obj',{'exc phytosphingosine'},1);

sol0 = solveLP(finalValidateModel0,1);
fprintf(['production rate of cordycepin' '\t' num2str(sol0.f*-1) ' mmol/g DW/h' '\n']);
sol1 = solveLP(finalValidateModel1,1);
fprintf(['production rate of sphinganine' '\t' num2str(sol1.f*-1) ' mmol/g DW/h' '\n']);
sol2 = solveLP(finalValidateModel2,1);
fprintf(['production rate of sphingosine' '\t' num2str(sol2.f*-1) ' mmol/g DW/h' '\n']);
sol3 = solveLP(finalValidateModel3,1);
fprintf(['production rate of phytosphingosine' '\t' num2str(sol3.f*-1) ' mmol/g DW/h' '\n']);

%% single gene deletion and mass balance analysis
iPC1469 = setParam(iPC1469raven3,'ub',{'glcIN'},[25]);
iPC1469 = setParam(iPC1469,'obj',{'bmOUT'},1);
iPC1469cobra3 = ravenCobraWrapper(iPC1469);
%[grRatio, grRateKO, grRateWT, hasEffect, delRxns, fluxSolution] = singleGeneDeletion(iPC1469cobra3);
%[massImbalance, imBalancedMass, imBalancedCharge, imBalancedRxnBool, elements, missingFormulaeBool, balancedMetBool] = checkMassChargeBalance(iPC1469cobra3);
outmodel = writeCbModel(iPC1469cobra3, 'format','sbml', 'fileName', 'CbModel/iPC1469cobra3.xml')
outmodel = writeCbModel(iPC1469cobra3, 'format','mat', 'fileName', 'CbModel/iPC1469cobra3.mat')


iPC1469raven4 = importModel('CbModel/iPC1469cobra3.xml');
exportForGit(iPC1469raven4,'iPC1469raven4');

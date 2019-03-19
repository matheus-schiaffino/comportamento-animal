%% Step 1: Creating training and test sets
%Training set
trainingParametros = [tabelaParametros1113a; tabelaParametros1820a; tabelaParametros1820b];
trainingRotulos = [tabelaRotulos1113a; tabelaRotulos1820a; tabelaRotulos1820b];
%Test set
testParametros = tabelaParametros1113b((1:1500),:);
testRotulos = tabelaRotulos1113b(1:1500);

[trainingParametros, testParametros, trainingRotulos, testRotulos] = ...
        binarySeparation(trainingRotulos, trainingParametros, testRotulos, testParametros, 8);
%% Step 2: Removing frames labeled with 0
for i = numel(trainingRotulos):-1:1
    if trainingRotulos(i) == 0
        trainingRotulos(i) = [];
        trainingParametros(i,:) = [];
    end
end

for i = numel(testRotulos):-1:1
    if testRotulos(i) == 0
        testRotulos(i) = [];
        testParametros(i,:) = [];
    end
end

clear i
%% Step 3: KNN
%Normaliza tabelas
trainingParametrosKNN = normalizaTabelaKNN(trainingParametros);
testParametrosKNN = normalizaTabelaKNN(testParametros);
%Cria classificador
classif = fitcknn(trainingParametrosKNN, trainingRotulos);
%Hyperparameter tuning
%{
crossvalLoss = zeros;
for i = 1:1000
    classif.NumNeighbors = i;
    %Cross validation
    crossVal = crossval(classif);
    crossValLoss(i) = kfoldLoss(crossVal);
end
plot(crossValLoss);
%}
classif.NumNeighbors = 11;
crossVal = crossval(classif);
crossValLoss = kfoldLoss(crossVal)
%Teste
predictedLabels = predict(classif, testParametrosKNN);
cp = classperf(testRotulos, predictedLabels);
cp.ErrorRate
%Limpa variáveis
clearvars testParametrosKNN trainingParametrosKNN classif crossVal ...
    previstos i crossValLoss 
%% Step 3: Decision tree
tree = fitctree(trainingParametros, trainingRotulos);
validCruzada = crossval(tree);
perdaValidCruzada = kfoldLoss(validCruzada)
predictedLabels = predict(tree, testParametros);
cp = classperf(testRotulos, predictedLabels);
cp.ErrorRate
%Discarding least significative parameters
numberDiscard = 15;
imp = predictorImportance(tree);
[~,ind] = sort(imp);
ind = ind(1:numberDiscard);
ind = sort(ind);

for i = numberDiscard:-1:1
    trainingParametros(:,i) = [];
    testParametros(:,i) = [];
end
clearvars tree validCruzada perdaValidCruzada imp ind i numberDiscard cp
%% Step 3: Naïve Bayes
naiveBayes = fitcnb(trainingParametros, trainingRotulos);
crossVal = crossval(naiveBayes);
crossValLoss = kfoldLoss(crossVal)
predictedLabels = predict(naiveBayes, testParametros);
cp = classperf(testRotulos, predictedLabels);
cp.ErrorRate
clearvars naiveBayes crossVal crossValLoss
%% Step 3: SVM
svm = fitcsvm(trainingParametros, trainingRotulos);
crossVal = crossval(svm);
crossValLoss = kfoldLoss(crossVal)
predictedLabels = predict(svm, testParametros);
cp = classperf(testRotulos, predictedLabels);
cp.ErrorRate
clearvars crossValLoss predictedLabels cp
%% Step 3: Ensemble
ensemble = fitcensemble(trainingParametros, trainingRotulos);
crossVal = crossval(ensemble);
crossValLoss = kfoldLoss(crossVal)
predictedLabels = predict(ensemble, testParametros);
cp = classperf(testRotulos, predictedLabels);
cp.ErrorRate
%% Step 3: Tree bagger
%% Step 2: (function) Binary separation of data
function [trainingParametros, testParametros, trainingRotulos, testRotulos] = ...
    binarySeparation(trainingRotulos, trainingParametros, testRotulos, testParametros, label)
    for i = numel(trainingRotulos):-1:1
        if trainingRotulos(i) ~= label
            trainingRotulos(i) = 0;
        else
            trainingRotulos(i) = 1;
        end
    end

    for i = numel(testRotulos):-1:1
        if testRotulos(i) ~= label
            testRotulos(i) = 0;
        else
            testRotulos(i) = 1;
        end
    end
    
    %How unbalanced is the dataset?
    unbTraining = sum(trainingRotulos)/numel(trainingRotulos);
    unbTest = sum(testRotulos)/numel(testRotulos);
    
    while unbTraining < 0.45
        line = randi([1 numel(trainingRotulos)], 1);
        if trainingRotulos(line) == 0
            trainingRotulos(line) = [];
            trainingParametros(line,:) = [];
            unbTraining = sum(trainingRotulos)/numel(trainingRotulos);
        end
    end
    
    while unbTest < 0.45
        line = randi([1 numel(testRotulos)], 1);
        if testRotulos(line) == 0
            testRotulos(line) = [];
            testParametros(line,:) = [];
            unbTest = sum(testRotulos)/numel(testRotulos);
        end
    end
    
end
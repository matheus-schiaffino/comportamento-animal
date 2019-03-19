function [trainingSet,testSet] = divideTrainingTest(setNormalizado, porcentagemTest)
%Divide dados em training e test, aleatoriamente. 
    numColunas = numel(setNormalizado(1,:));
    numElementos = numel(setNormalizado(:,1));
    numElementosTest = int32(numElementos*porcentagemTest);
    numElementosTraining = numElementos - numElementosTest;
    
    contadorTest = 1;
    contadorTraining = 1;
    
    trainingSet = zeros(numElementosTraining,numColunas);
    testSet = zeros(numElementosTest, numColunas);
    
    indicesTest = randperm(numElementos, numElementosTest);
    
    for i=1:numElementos
        if ismember(i, indicesTest)
            testSet(contadorTest,:) = setNormalizado(i,:);
            contadorTest = contadorTest + 1;
        else
            trainingSet(contadorTraining,:) = setNormalizado(i,:);
            contadorTraining = contadorTraining + 1;
        end
    end
end


function [acuracia, matrizConfusao] = testaKNN(trainingSet,testSet,n)
%Aplica o algoritmo kNN em cada elemento do testSet. Calcula erro.
    
    matrizConfusao = zeros(8,8);

    numeroErros = 0;
    erroMedio = 0;
    
    for j = 1:8
        testSetFiltrado = filtraTestSet(testSet, j);
        numElementosTest = numel(testSetFiltrado(:,1));
        for i = 1:numElementosTest
            classeKNN = kNN(testSetFiltrado(i,:), trainingSet, n);
            classeReal = j;
            matrizConfusao(classeKNN, classeReal) = matrizConfusao(classeKNN, classeReal) + 1;
            %classeReal = testSet(i,end);
            if classeKNN ~= classeReal
                numeroErros = numeroErros + 1;
            end
        end
        
        taxaErro = numeroErros/numElementosTest;
        erroMedio = erroMedio + taxaErro;
        numeroErros = 0;
        
    end
    
    erroMedio = erroMedio/8;
    matrizConfusao
    acuracia = trace(matrizConfusao)/sum(sum(matrizConfusao))
    
end


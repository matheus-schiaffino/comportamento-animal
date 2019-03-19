function [testSetFiltrado] = filtraTestSet(testSet, rotulo)
    indice = 1;
    numeroElementos = numel(testSet(:,1));
    numeroColunas = numel(testSet(1,:));
    testSetFiltrado = zeros(1,numeroColunas);
    for i=1:numeroElementos
       if testSet(i,numeroColunas)==rotulo
           %testSetFiltrado(i,numeroColunas)
           testSetFiltrado(indice,:) = testSet(i,:);
           indice = indice + 1;
       end
    end

end


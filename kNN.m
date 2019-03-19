function [classe] = kNN(ponto, trainingSet, n)
    numElementos = numel(trainingSet(:,1));
    numParametros = numel(trainingSet(1,:))-1;
    distancias = zeros(numElementos, 1);
    
    votos = zeros(8,1);
    
    %Calcula distância a todos pontos
    for cont = 1:numElementos
        for cont2 = 1:numParametros
            distancias(cont) = distancias(cont) + (ponto(cont2) ...
                - trainingSet(cont, cont2))*(ponto(cont2) - trainingSet(cont, cont2));
        end
        distancias(cont) = sqrt(distancias(cont));
    end

    [distanciasOrdenadas, indices] = sort(distancias, 'ascend');
   
    
    %Continuação: Fazer sistema de 'voto'
    %Testar se ordenamento do trainingSet funcionou
    
    trainingSetOrdenado(:,:) = trainingSet(indices,:);
    
    for cont3 = 1:n
        votos(trainingSetOrdenado(cont3, end)) = votos(trainingSetOrdenado(cont3, end)) + 1;
        %if trainingSetOrdenado(cont3, 4) == 1
        %    votos1 = votos1 + 1;
        %else
        %    votos0 = votos0 + 1;
        %end
    end
    
    [vizinhosOrdenados, indicesOrdenados] = sort(votos, 'descend');
    classe = indicesOrdenados(1);
    %if votos1>votos0
    %    classe = 1;
    %else
    %    classe = 0;
    %end
end


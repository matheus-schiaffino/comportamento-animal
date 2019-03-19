function [oversampledSetSmote] = smote(normalizedSet)
%Oversampling (SMOTE)
    numElements = zeros(8,1);
    oversampledSetSmote = normalizedSet;
    
    for j = 1:8
        filteredTestSet = filtraTestSet(normalizedSet, j);
        numElements(j) = numel(filteredTestSet(:,1));
    end
    largestSet = max(numElements);
    
    for j = 1:8
        
        if (j ~= 5) && (j ~= 7)
            
            if numElements(j) ~= largestSet
                filteredTestSet = filtraTestSet(normalizedSet, j);
                %Oversampling
                for k = 1:(largestSet - numElements(j))
                    randNumber = randi([1 numElements(j)]); %Pick random element from the list
                    distToNearestNeighbour = 99999;
                    calcDistance = 0;
                    nearestNeighbour = 1;
                    for l = 1:numElements(j)
                        if l ~= randNumber
                            for p = 1:(numel(normalizedSet(1,:))-1)
                                calcDistance = calcDistance + (filteredTestSet(l,p) - ...
                                    filteredTestSet(randNumber,p))*(filteredTestSet(l,p) - filteredTestSet(randNumber,p));
                            end
                        end
                        if calcDistance < distToNearestNeighbour
                            nearestNeighbour = l;
                        end
                    end
                    
                    randNumber01 = rand; %Pick random number between 0 and 1
                    newElement = zeros(1,numel(normalizedSet(1,:)));
                    
                    for p = 1:(numel(normalizedSet(1,:)) - 1)
                        newElement(1,p) = filteredTestSet(randNumber,p) - randNumber01*(filteredTestSet(randNumber,p) -...
                            filteredTestSet(nearestNeighbour,p));
                    end
                    
                    newElement(1,numel(normalizedSet(1,:))) = j;
                    
                    oversampledSetSmote(numel(oversampledSetSmote(:,1)) + 1, :) = newElement;
                    %Criar novo ponto, na reta que une os dois pontos acima
                    %Armazenar em oversampledSetSmote(numel+1,:)
                end
            end
        end
    end
    
    
end


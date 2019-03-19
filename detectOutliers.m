function detectOutliers(tabelaParametros)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    numberOutliers = 0;
    for j=2:numel(tabelaParametros(1,:))
        outliers = isoutlier(tabelaParametros(:,j), 'quartiles');
        numberOutliers = numberOutliers + sum(outliers);
    end
    numberOutliers
end


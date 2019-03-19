function [setNormalizado] = normalizaTabelaKNN(tabelaRotulos)
%Pega tabela com quadros na primeira coluna, dados nas colunas seguintes e
%rótulos na última. Normaliza os dados na faixa de 0 a 1

%setNormalizado = tabelaRotulos(:,(2:end));
setNormalizado = tabelaRotulos;
numColunas = numel(tabelaRotulos(1,:));

for i = 1:numColunas
    maxColuna = max(setNormalizado(:,i));
    minColuna = min(setNormalizado(:,i));
    setNormalizado(:,i) = (setNormalizado(:,i)-minColuna)/(maxColuna-minColuna);
end
end


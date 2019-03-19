extractedFeatures = ["Área", "Área convexa", "Solidez",...
    "Comprimento eixo maior", "Comprimento eixo menor", "Excentricidade",...
    "Ângulo", "Distância parede", "Perímetro", "X extremidades eixo maior 1",...
    "Y extremidades eixo maior 1", "X extremidades eixo maior 2",...
    "Y extremidades eixo maior 2", "Variação área", "Variação excentricidade",...
    "Velocidade angular", "Variação distância até paredes", "Velocidade instantânea",...
    "Ângulo da velocidade com o eixo maior", "Variação velocidade instantânea",...
    "Variação posição extremidades eixo maior x1", "Variação posição extremidades eixo maior y1",...
    "Variação posição extremidades eixo maior x2", "Variação posição extremidades eixo maior y2"];

for j=1:4
    for i=1:6
        subplot(2,3,i);
        plot(tabelaParametros1113a(:,(j-1)*6+i));title(extractedFeatures((j-1)*6+i))
        hold on;
        plot(tabelaParametros1113b(:,(j-1)*6+i));
        hold on;
        plot(tabelaParametros1820a(:,(j-1)*6+i));
        hold on;
        plot(tabelaParametros1820b(:,(j-1)*6+i));
        hold on;
        %plot(tabelaParametros1417a(:,(j-1)*6+i));
        %hold on;
        %plot(tabelaParametros1417b(:,(j-1)*6+i));
        %ylim([-1 2]);
        %hold on
    end
    drawnow;
    figure;
end

close


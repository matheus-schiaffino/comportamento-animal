extractedFeatures = ["�rea", "�rea convexa", "Solidez",...
    "Comprimento eixo maior", "Comprimento eixo menor", "Excentricidade",...
    "�ngulo", "Dist�ncia parede", "Per�metro", "X extremidades eixo maior 1",...
    "Y extremidades eixo maior 1", "X extremidades eixo maior 2",...
    "Y extremidades eixo maior 2", "Varia��o �rea", "Varia��o excentricidade",...
    "Velocidade angular", "Varia��o dist�ncia at� paredes", "Velocidade instant�nea",...
    "�ngulo da velocidade com o eixo maior", "Varia��o velocidade instant�nea",...
    "Varia��o posi��o extremidades eixo maior x1", "Varia��o posi��o extremidades eixo maior y1",...
    "Varia��o posi��o extremidades eixo maior x2", "Varia��o posi��o extremidades eixo maior y2"];

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


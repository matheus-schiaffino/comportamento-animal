%fundo = imread('C:\Users\Matheus\Desktop\Projeto\Rastreamento_CNN_regressao\fundo2.jpg');
%imagem = imread('238.jpg');
video = VideoReader('D:\Grooming\Grooming_Leva1\Originais\18-20.avi');
area = zeros;
centroide = zeros;
dCentroide = zeros;
comportamento = zeros;
eixoMaior = zeros;
eixoMenor = zeros;
orientacaoElipse = zeros; %Entre -90 e 90 graus
orientacaoVelocidade = zeros; %Entre 0 e 90 graus
anguloVelocidadeEixoMaior = zeros;
velocidadeAngular = zeros;
tabelaRotulos = zeros;
clear tabelaParametros;
clear tabelaParametrosReduzida;

i=0;

quadroInicial = input('Em qual quadro deseja iniciar a an�lise? ');
quadroFinal = input('At� qual quadro deseja continuar a an�lise? ');

tecla = 0;
for k=1:(quadroInicial - 1)
    %if k<110
    %    readFrame(video);
    %    continue;
    %end
    imagem = readFrame(video);
    if tecla == 0
        
        imshow(imagem);
        drawnow
        
        
        w = waitforbuttonpress;
        if w
            tecla = get(gcf, 'CurrentCharacter');
            if tecla == double('s')
                tecla = 1;
            else
                tecla = 0;
            end
        end
        
        %tecla = input('Fundo?');
        
        if tecla == 1
            %continue
            fundo = imagem;
            %imshow(fundo);hold on;
        end
    end
end

%fundo = fundoCopy;
imshow(fundo);
[x,y] = ginput(2);
fundo = imcrop(fundo, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
xFrame = size(fundo,1);
yFrame = size(fundo,2);
close;
imshow(fundo);
[xChao, yChao] = ginput(2);
%imshow(fundo);figure;

close;

i=quadroInicial-1;

%figure;

while(i<quadroFinal)
    i=i+1;
    imagem = readFrame(video);
    imagem = imcrop(imagem, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
    
    %Subtra��o do fundo e convers�o para escala de cinza
    subFundo = imagem - fundo;
    subFundo = rgb2gray(subFundo);
    %subFundo = imadjust(subFundo);
    
    
    %Closing
    %se = strel('disk', 4);
    %subFundo = imopen(subFundo, se);
    
    
    %Dilate
    se90 = strel('line', 9, 90);
    se0 = strel('line', 9, 0);
    subFundo = imerode(subFundo, [se90 se0]);
    subFundo = imdilate(subFundo, [se90 se0]);
    %subFundo = imdilate(subFundo, [se90 se0]);
    
    %Binariza��o, m�todo de Otsu
    level = graythresh(subFundo);
    BW = imbinarize(subFundo, level/2);
    
    %Crit�rio de �rea m�xima
    BW1 = bwpropfilt(BW, 'Area', 1, 'largest');
    BW2 = bwpropfilt(BW, 'Area', 2, 'largest');
    if bwarea(BW1)<1800
        BW = BW1;
    else
        BW = BW2 - BW1;
    end
    
    
    %Calcula par�metros
    area = bwarea(BW);
    
    if sum(sum(BW)) == 0
        tabelaParametros(i,:) = 0;
        
        
    else
        %Extrai propriedades
        c = regionprops(BW, 'centroid', 'MajorAxisLength', 'MinorAxisLength', ...
            'Orientation', 'Eccentricity', 'ConvexArea', 'Perimeter');
        
        %     eixoMaior(i) = c.MajorAxisLength;
        %     eixoMenor(i) = c.MinorAxisLength;
        
        %Calcula velocidade instant�nea
        centroide(i,1) = c.Centroid(1);
        centroide(i,2) = c.Centroid(2);
        velocidadeInstX = centroide(i,1)-centroide(i-1,1);
        velocidadeInstY = centroide(i,2)-centroide(i-1,2);
        velocidadeInst = sqrt(velocidadeInstX.^2 + velocidadeInstY.^2);
        
        %Calcula dist�ncia at� parede
        distanciaParede = min([(c.Centroid(1)-xChao(1)), (c.Centroid(2)-yChao(1)),...
            (xChao(2)-c.Centroid(1)), (yChao(2)-c.Centroid(2))]);
        
        %dCentroide(i) = velocidadeInst;
        
        %Calcula velocidade angular
        orientacaoElipse(i) = c.Orientation;
        velocidadeAngular(i) = orientacaoElipse(i) - orientacaoElipse(i-1);
        
        %Calcula �ngulo entre velocidade e eixo maior
        orientacaoVelocidade = atand(abs((centroide(i,2)-centroide(i-1,2))/(centroide(i,1)-centroide(i-1,1))));
        anguloVelocidadeEixoMaior = abs(orientacaoVelocidade - abs(orientacaoElipse(i)));
        
        %Calcula posi��o extremidades eixo maior
        xExtremidade1 = c.Centroid(1) + c.MajorAxisLength/2*cosd(c.Orientation);
        yExtremidade1 = c.Centroid(2) - c.MajorAxisLength/2*sind(c.Orientation);
        xExtremidade2 = c.Centroid(1) - c.MajorAxisLength/2*cosd(c.Orientation);
        yExtremidade2 = c.Centroid(2) + c.MajorAxisLength/2*sind(c.Orientation);
        
        %Verificar se tudo corre bem
        imshow(BW)
       
        %Atualiza tabela
        tabelaParametros(i,1) = i; %n�mero do frame
        tabelaParametros(i,2) = area;
        tabelaParametros(i,3) = c.ConvexArea; %area convexa
        tabelaParametros(i,4) = area/c.ConvexArea; %solidity
        tabelaParametros(i,5) = c.MajorAxisLength; %comprimento eixo maior
        tabelaParametros(i,6) = c.MinorAxisLength; %comprimento eixo menor
        tabelaParametros(i,7) = c.Eccentricity;
        tabelaParametros(i,8) = c.Orientation; %angulo
        tabelaParametros(i,9) = distanciaParede;
        tabelaParametros(i,10) = c.Perimeter; %perimetro
        tabelaParametros(i,11) = xExtremidade1; %x extremidades eixo maior 1
        tabelaParametros(i,12) = yExtremidade1; %y extremidades eixo maior 1
        tabelaParametros(i,13) = xExtremidade2; %x extremidades eixo maior 2
        tabelaParametros(i,14) = yExtremidade2; %y extremidades eixo maior 2
        tabelaParametros(i,15) = area - tabelaParametros(i-1,2); %varia��o �rea
        tabelaParametros(i,16) = c.Eccentricity - tabelaParametros(i-1,7); %varia��o excentricidade
        tabelaParametros(i,17) = c.Orientation - tabelaParametros(i-1,8); %velocidade angular
        tabelaParametros(i,18) = distanciaParede - tabelaParametros(i-1, 9); %varia��o dist�ncia at� paredes
        tabelaParametros(i,19) = velocidadeInst; %velocidade instant�nea
        tabelaParametros(i,20) = anguloVelocidadeEixoMaior; %coluna 3: �ngulo da velocidade com o eixo maior
        tabelaParametros(i,21) = velocidadeInst - tabelaParametros(i-1,19);
        tabelaParametros(i,22) = xExtremidade1 - tabelaParametros(i-1,11); %varia��o posi��o extremidades eixo maior 1
        tabelaParametros(i,23) = yExtremidade1 - tabelaParametros(i-1,12); %varia��o posi��o extremidades eixo maior 2
        tabelaParametros(i,24) = xExtremidade2 - tabelaParametros(i-1,13); %varia��o posi��o extremidades eixo maior 1
        tabelaParametros(i,25) = yExtremidade2 - tabelaParametros(i-1,14); %varia��o posi��o extremidades eixo maior 2
    end
end 
    %{
    %Plota pontos
    imshow(imagem);
    hold on;
    plot(c.Centroid(1), c.Centroid(2), 'r+', 'MarkerSize', 2);
    hold on;
    plot(xExtremidade1, yExtremidade1, 'r+', 'MarkerSize', 2);
    hold on;
    plot(xExtremidade2, yExtremidade2, 'r+', 'MarkerSize', 2);
    %hold on;
    %line([xChao(1) (xChao(1)+abs(distanciaParede))],[yChao(1) yChao(1)]);
    drawnow;
    %}
  %{  
    for j=1:(i-quadroInicial)
        tabelaParametrosReduzida(j,:) = tabelaParametros(j+quadroInicial,:);
    end
end

for j=2:(i-quadroInicial-1)
    for k=2:25
        %M�dia
        tabelaParametrosReduzida(j,k+24) = (tabelaParametrosReduzida(j-1,k)+...
            tabelaParametrosReduzida(j,k)+tabelaParametrosReduzida(j+1,k))/3;
        %M�ximo
        tabelaParametrosReduzida(j,k+48) = max([tabelaParametrosReduzida(j-1,k),...
            tabelaParametrosReduzida(j,k),tabelaParametrosReduzida(j+1,k)]);
        %M�nimo
        tabelaParametrosReduzida(j,k+72) = min([tabelaParametrosReduzida(j-1,k),...
            tabelaParametrosReduzida(j,k),tabelaParametrosReduzida(j+1,k)]);  
    end
end

clear tabelaParametros;
%tabelaParametros = normalizaTabelaKNN(tabelaParametrosReduzida);
tabelaParametros = tabelaParametrosReduzida;
tabelaParametros(:,1) = [];
%}
clearvars -except tabelaParametros*

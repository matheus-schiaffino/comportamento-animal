fundo = imread('C:\Users\Matheus\Desktop\Projeto\Rastreamento_CNN_regressao\fundo2.jpg');
%imagem = imread('238.jpg');
video = VideoReader('C:\Users\Matheus\Desktop\Projeto\grooming_1.avi');
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

i=0;

quadroInicial = input('Em qual quadro deseja iniciar a análise? ');
quadroFinal = input('Até qual quadro deseja continuar a análise? ');

for k=1:(quadroInicial - 1)
    readFrame(video);
end

i=k;

%figure;

while(i<quadroFinal)
    i=i+1;
    imagem = readFrame(video);
    imagem = imcrop(imagem, [145 57 399 399]);
    
    %Subtração do fundo e conversão para escala de cinza
    subFundo = imagem - fundo;
    subFundo = rgb2gray(subFundo);
    
    %Dilate
    se90 = strel('line', 9, 90);
    se0 = strel('line', 9, 0);
    subFundo = imerode(subFundo, [se90 se0]);
    subFundo = imdilate(subFundo, [se90 se0]);
    
    %Binarização, método de Otsu
    level = graythresh(subFundo);
    BW = imbinarize(subFundo, level/2);
    BW = bwpropfilt(BW, 'Area', 1, 'largest');
    
    %Calcula parâmetros
    area = bwarea(BW);
    
    %Extrai propriedades
    c = regionprops(BW, 'centroid', 'MajorAxisLength', 'MinorAxisLength', ...
        'Orientation', 'Eccentricity', 'ConvexArea', 'Perimeter');
    
    %     eixoMaior(i) = c.MajorAxisLength;
    %     eixoMenor(i) = c.MinorAxisLength;
    
    %Calcula velocidade instantânea
    centroide(i,1) = c.Centroid(1);
    centroide(i,2) = c.Centroid(2);
    velocidadeInstX = centroide(i,1)-centroide(i-1,1);
    velocidadeInstY = centroide(i,2)-centroide(i-1,2);
    velocidadeInst = sqrt(velocidadeInstX.^2 + velocidadeInstY.^2);
    
    %Calcula distância até parede
    distanciaParede = min([centroide(i,1), centroide(i,2), 400-centroide(i,1), 400-centroide(i,2)]);
    
    %dCentroide(i) = velocidadeInst;
    
    %Calcula velocidade angular
    orientacaoElipse(i) = c.Orientation;
    velocidadeAngular(i) = orientacaoElipse(i) - orientacaoElipse(i-1);
    
    %Calcula ângulo entre velocidade e eixo maior
    orientacaoVelocidade = atand(abs((centroide(i,2)-centroide(i-1,2))/(centroide(i,1)-centroide(i-1,1))));
    anguloVelocidadeEixoMaior = abs(orientacaoVelocidade - abs(orientacaoElipse(i)));
    
    %Calcula posição extremidades eixo maior
    xExtremidade1 = c.Centroid(1) + c.MajorAxisLength/2*cosd(c.Orientation);
    yExtremidade1 = c.Centroid(2) + c.MajorAxisLength/2*sind(c.Orientation);
    xExtremidade2 = c.Centroid(1) - c.MajorAxisLength/2*cosd(c.Orientation);
    yExtremidade2 = c.Centroid(2) - c.MajorAxisLength/2*sind(c.Orientation);
    
    %Atualiza tabela
    tabelaParametros(i,1) = i; %número do frame
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
    tabelaParametros(i,15) = area - tabelaParametros(i-1,2); %variação área
    tabelaParametros(i,16) = c.Eccentricity - tabelaParametros(i-1,7); %variação excentricidade
    tabelaParametros(i,17) = c.Orientation - tabelaParametros(i-1,8); %velocidade angular
    tabelaParametros(i,18) = distanciaParede - tabelaParametros(i-1, 9); %variação distância até paredes
    tabelaParametros(i,19) = velocidadeInst; %velocidade instantânea
    tabelaParametros(i,20) = anguloVelocidadeEixoMaior; %coluna 3: ângulo da velocidade com o eixo maior
    tabelaParametros(i,21) = velocidadeInst - tabelaParametros(i-1,19);
    tabelaParametros(i,22) = xExtremidade1 - tabelaParametros(i-1,11); %variação posição extremidades eixo maior 1
    tabelaParametros(i,23) = yExtremidade1 - tabelaParametros(i-1,12); %variação posição extremidades eixo maior 2
    tabelaParametros(i,24) = xExtremidade2 - tabelaParametros(i-1,13); %variação posição extremidades eixo maior 1
    tabelaParametros(i,25) = yExtremidade2 - tabelaParametros(i-1,14); %variação posição extremidades eixo maior 2
    
    for j=1:(i-quadroInicial)
        tabelaParametrosReduzida(j,:) = tabelaParametros(j+quadroInicial,:);
    end
end

for j=2:(i-quadroInicial-1)
    for k=2:25
        %Média
        tabelaParametrosReduzida(j,k+24) = (tabelaParametrosReduzida(j-1,k)+...
            tabelaParametrosReduzida(j,k)+tabelaParametrosReduzida(j+1,k))/3;
        %Máximo
        tabelaParametrosReduzida(j,k+48) = max([tabelaParametrosReduzida(j-1,k),...
            tabelaParametrosReduzida(j,k),tabelaParametrosReduzida(j+1,k)]);
        %Mínimo
        tabelaParametrosReduzida(j,k+72) = min([tabelaParametrosReduzida(j-1,k),...
            tabelaParametrosReduzida(j,k),tabelaParametrosReduzida(j+1,k)]);  
    end
end
    %{
Janeladas:
1-Média
2-Mínimo
3-Máximo
4-Desvio padrão
4.5-Diferença com valores da janela de antes e depois
5-Início, meio e fim
6-Valores de janelas
    %}
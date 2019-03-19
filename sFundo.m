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

for k=1:(quadroInicial - 1)
    readFrame(video);
end

i=k;

figure;

while(hasFrame(video))
i=i+1
imagem = readFrame(video);
imagem = imcrop(imagem, [145 57 399 399]);
    
%Subtração do fundo e conversão para escala de cinza    
subFundo = imagem - fundo;
subFundo = rgb2gray(subFundo);

%Abertura (erosão e dilatação)
%se = strel('disk', 5);
%fundo = imopen(subFundo, se);
%imshow(fundo);

%Testar se vale a pena usar dilate
se90 = strel('line', 9, 90);
se0 = strel('line', 9, 0);
subFundo = imerode(subFundo, [se90 se0]);
subFundo = imdilate(subFundo, [se90 se0]);

%Binarização, método de Otsu
level = graythresh(subFundo);
BW = imbinarize(subFundo, level/2);
BW = bwpropfilt(BW, 'Area', 1, 'largest');

%Área, centroide do rato
area = bwarea(BW);
c = regionprops(BW, 'centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Eccentricity');
centroide(i,1) = c.Centroid(1);
centroide(i,2) = c.Centroid(2);
eixoMaior(i) = c.MajorAxisLength;
eixoMenor(i) = c.MinorAxisLength;
orientacaoElipse(i) = c.Orientation;

%Mostra a imagem. Desenha eixos da elipse e trajetória dos últimos quadros
imshow(imagem);
hold on
plot(centroide(i,1), centroide(i,2), 'r+', 'LineWidth', 2, 'MarkerSize', 5);
hold on 
plot([centroide(i,1)+eixoMaior(i)/2*cosd(orientacaoElipse(i)) centroide(i,1)-eixoMaior(i)/2*cosd(orientacaoElipse(i))], [centroide(i,2)-eixoMaior(i)/2*sind(orientacaoElipse(i)) centroide(i,2)+eixoMaior(i)/2*sind(orientacaoElipse(i))], 'r', 'LineWidth', 1);
hold on 
plot([centroide(i,1)+eixoMenor(i)/2*cosd(orientacaoElipse(i)+90) centroide(i,1)-eixoMenor(i)/2*cosd(orientacaoElipse(i)+90)], [centroide(i,2)-eixoMenor(i)/2*sind(orientacaoElipse(i)+90) centroide(i,2)+eixoMenor(i)/2*sind(orientacaoElipse(i)+90)], 'r', 'LineWidth', 1);
hold on 
plot([centroide(i-1,1) centroide(i,1)], [centroide(i-1,2) centroide(i,2)], 'b', 'LineWidth', 1);
hold on 
plot([centroide(i-2,1) centroide(i-1,1)], [centroide(i-2,2) centroide(i-1,2)], 'b', 'LineWidth', 1);
hold on 
plot([centroide(i-3,1) centroide(i-2,1)], [centroide(i-3,2) centroide(i-2,2)], 'b', 'LineWidth', 1);
hold on
plot([centroide(i-4,1) centroide(i-3,1)], [centroide(i-4,2) centroide(i-3,2)], 'b', 'LineWidth', 1);
hold on 
plot([centroide(i-5,1) centroide(i-4,1)], [centroide(i-5,2) centroide(i-4,2)], 'b', 'LineWidth', 1);
hold on 
plot([centroide(i-6,1) centroide(i-5,1)], [centroide(i-6,2) centroide(i-5,2)], 'b', 'LineWidth', 1);


drawnow

rotulo = input('prompt');
%Rótulos
%0-NaN
%1-Walking
%2-Immobile sniffing
%3-Stretched sniffing
%4-Climbing
%5-Rearing
%6-Fore body grooming
%7-Hind body grooming
%8-Immobility


%if i==1000
%    break
%end

velocidadeInstX = centroide(i,1)-centroide(i-1,1);
velocidadeInstY = centroide(i,2)-centroide(i-1,2);
velocidadeInst = sqrt(velocidadeInstX.^2 + velocidadeInstY.^2);
dCentroide(i) = velocidadeInst;
velocidadeAngular(i) = orientacaoElipse(i) - orientacaoElipse(i-1); 
orientacaoVelocidade = atand(abs((centroide(i,2)-centroide(i-1,2))/(centroide(i,1)-centroide(i-1,1))));
anguloVelocidadeEixoMaior = abs(orientacaoVelocidade - abs(orientacaoElipse(i)));

tabelaRotulos(i,1) = i; %coluna 1: número do frame
tabelaRotulos(i,2) = velocidadeInst; %coluna 2: velocidade instantânea
tabelaRotulos(i,3) = anguloVelocidadeEixoMaior; %coluna 3: ângulo da velocidade com o eixo maior
tabelaRotulos(i,4) = c.Eccentricity; %coluna 4: excentricidade da elipse
tabelaRotulos(i,5) = area;
tabelaRotulos(i,6) = areaConvexa;
tabelaRotulos(i,7) = areaConvexa/area;
tabelaRotulos(i,8) = distanciaParede;


tabelaRotulos(i,100) = rotulo; %coluna 5: rótulo do quadro (nominal)


end


%dCentroide = diff(centroide);
%[s1, f1, t1] = spectrogram(dCentroide(:,1), 30, [], 1e3);
%[s2, f2, t2] = spectrogram(dCentroide(:,2), 30, [], 1e3);
%t1 = 1:1:1000;
%t2 = 1:1:1000;
%subplot(2,3,1);plot(centroide(:,1));title('Centroide1');xlim([310 1000]);
%subplot(2,3,4);plot(centroide(:,2));title('Centroide2');xlim([310 1000]);
%subplot(2,3,2);plot(dCentroide(:,1));title('dCentroide1');xlim([310 1000]);ylim([-25 25]);
%subplot(2,3,5);plot(dCentroide(:,2));title('dCentroide2');xlim([310 1000]);ylim([-25 25]);
%subplot(2,3,3);imagesc(t1, f1, abs(s1));title('Spectro dCentroide1');
%subplot(2,3,6);imagesc(t2, f2, abs(s2));title('Spectro dCentroide2');

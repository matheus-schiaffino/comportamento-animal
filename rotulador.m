%fundo = imread('C:\Users\Matheus\Desktop\Projeto\Rastreamento_CNN_regressao\fundo2.jpg');
%imagem = imread('238.jpg');
video = VideoReader('C:\Users\Matheus\Desktop\PPGN\Videos\Grooming\Originais\11-13.avi');
area = zeros;
centroide = zeros;
dCentroide = zeros;
%clear tabelaRotulosNumerica;


i=0;

quadroInicial = input('Em qual quadro deseja iniciar a an�lise? ');

%{
for k=1:(quadroInicial - 1)
    readFrame(video);
end
%}

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
            fundo = imagem;
            %imshow(fundo);hold on;
        end
    end
end

imshow(fundo);
[x,y] = ginput(2);
fundo = imcrop(fundo, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
close;
imshow(fundo);


i=k;

figure;

while(hasFrame(video))
i=i+1
imagem = readFrame(video);
imshow(imagem);

imagem = imcrop(imagem, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
    
%Subtra��o do fundo e convers�o para escala de cinza    
subFundo = imagem - fundo;
subFundo = rgb2gray(subFundo);

%Abertura (eros�o e dilata��o)
%se = strel('disk', 5);
%fundo = imopen(subFundo, se);
%imshow(fundo);
%{
%Testar se vale a pena usar dilate
se90 = strel('line', 9, 90);
se0 = strel('line', 9, 0);
subFundo = imerode(subFundo, [se90 se0]);
subFundo = imdilate(subFundo, [se90 se0]);

%Binariza��o, m�todo de Otsu
level = graythresh(subFundo);
BW = imbinarize(subFundo, level/2);
BW = bwpropfilt(BW, 'Area', 1, 'largest');

%�rea, centroide do rato
area = bwarea(BW);
c = regionprops(BW, 'centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Eccentricity');
centroide(i,1) = c.Centroid(1);
centroide(i,2) = c.Centroid(2);

%Mostra a imagem. Desenha eixos da elipse e trajet�ria dos �ltimos quadros
imshow(imagem);
hold on
plot(centroide(i,1), centroide(i,2), 'r+', 'LineWidth', 2, 'MarkerSize', 5);
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
%}

w = waitforbuttonpress;
if w
       keyP = get(gcf, 'CurrentCharacter');
       switch keyP
           case 48
               rotulo = 0
           case 49
               rotulo = 1
           case 50
               rotulo = 2
           case 51
               rotulo = 3
           case 52
               rotulo = 4
           case 53
               rotulo = 5
           case 54
               rotulo = 6
           case 55
               rotulo = 7
           case 56
               rotulo = 8
           otherwise
               rotulo = 0
       end
end
%rotulo = input('prompt');

tabelaRotulosNumerica(i, 1) = i; 
tabelaRotulosNumerica(i, 2) = rotulo; %R�tulo do quadro (num�rico)
%R�tulos
%0-NaN
%1-Walking
%2-Immobile sniffing
%3-Stretched sniffing
%4-Climbing
%5-Rearing
%6-Fore body grooming
%7-Hind body grooming
%8-Immobility


end

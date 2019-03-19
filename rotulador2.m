%fundo = imread('C:\Users\Matheus\Desktop\Projeto\Rastreamento_CNN_regressao\fundo2.jpg');
%imagem = imread('238.jpg');
video = VideoReader('C:\Users\Matheus\Desktop\PPGN\Videos\Grooming\Originais\18-20.avi');
videoAux = VideoReader('C:\Users\Matheus\Desktop\PPGN\Videos\Grooming\Originais\18-20.avi');

%centroide = zeros;
%clear tabelaRotulosNumerica;

i=0;

quadroInicial = input('Em qual quadro deseja iniciar a análise? ');

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
            %fundo = fundoCopy;
            %imshow(fundo);hold on;
        end
    end
end

for j=1:(quadroInicial - 5)
    readFrame(videoAux);
end

imshow(fundo);
[x,y] = ginput(2);
fundo = imcrop(fundo, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
close;
%imshow(fundo);


i=quadroInicial-1;

figure;

while(hasFrame(video))
    i=i+1
    imagem = readFrame(video);
    %imagemAux = readFrame(videoAux);
    %imshow(imagem);
    
    imagem = imcrop(imagem, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
    %imagemAux = imcrop(imagemAux, [x(1) y(1) (x(2)-x(1)) (y(2)-y(1))]);
    
    %{
    %Subtração do fundo e conversão para escala de cinza
    subFundo = imagem - fundo;
    subFundo = rgb2gray(subFundo);
    
    se90 = strel('line', 9, 90);
    se0 = strel('line', 9, 0);
    subFundo = imerode(subFundo, [se90 se0]);
    subFundo = imdilate(subFundo, [se90 se0]);
    %subFundo = imdilate(subFundo, [se90 se0]);
    
    %Binarização, método de Otsu
    level = graythresh(subFundo);
    BW = imbinarize(subFundo, level/2);
    
    %Critério de área máxima
    BW1 = bwpropfilt(BW, 'Area', 1, 'largest');
    BW2 = bwpropfilt(BW, 'Area', 2, 'largest');
    if bwarea(BW1)<1800
        BW = BW1;
    else
        BW = BW2 - BW1;
    end
    
    %Verificar se tudo corre bem
    %imshow(BW)
    %i
    
    %Calcula parâmetros
    
    if sum(sum(BW)) == 0
        centroide(i,1) = 0;
        centroide(i,2) = 0;
    else
        %Extrai propriedades
        c = regionprops(BW, 'centroid', 'MajorAxisLength', 'MinorAxisLength', ...
            'Orientation', 'Eccentricity', 'ConvexArea', 'Perimeter');
        centroide(i,1) = c.Centroid(1);
        centroide(i,2) = c.Centroid(2);
        %}
        %Mostra a imagem. Desenha eixos da elipse e trajetória dos últimos quadros
        %imshow(imagemAux);
        imshow(imagem);
        hold on
        plot(centroide(i,1), centroide(i,2), 'r+', 'LineWidth', 2, 'MarkerSize', 5);
        hold on
        plot([centroide(i+4,1) centroide(i+3,1)], [centroide(i+4,2) centroide(i+3,2)], 'b', 'LineWidth', 1);
        hold on
        plot([centroide(i+3,1) centroide(i+2,1)], [centroide(i+3,2) centroide(i+2,2)], 'b', 'LineWidth', 1);
        hold on
        plot([centroide(i+2,1) centroide(i+1,1)], [centroide(i+2,2) centroide(i+1,2)], 'b', 'LineWidth', 1);
        hold on
        plot([centroide(i+1,1) centroide(i,1)], [centroide(i+1,2) centroide(i,2)], 'b', 'LineWidth', 1);
        hold on
        plot([centroide(i,1) centroide(i-1,1)], [centroide(i,2) centroide(i-1,2)], 'b', 'LineWidth', 1);
        hold on
        plot([centroide(i-1,1) centroide(i-2,1)], [centroide(i-1,2) centroide(i-2,2)], 'b', 'LineWidth', 1);
        hold on
        %plot([centroide(i-2,1) centroide(i-3,1)], [centroide(i-2,2) centroide(i-3,2)], 'b', 'LineWidth', 1);
        %hold on
        %plot([centroide(i-3,1) centroide(i-4,1)], [centroide(i-3,2) centroide(i-4,2)], 'b', 'LineWidth', 1);
        %hold on
        %plot([centroide(i-4,1) centroide(i-5,1)], [centroide(i-4,2) centroide(i-5,2)], 'b', 'LineWidth', 1);
        
        drawnow
    
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
tabelaRotulosNumerica(i, 2) = rotulo; %Rótulo do quadro (numérico)
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


end

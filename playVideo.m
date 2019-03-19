video = VideoReader('D:\Grooming\Grooming_Leva1\Originais\14-17.avi');
i=0;
frameInicial = 1300;

for k=1:frameInicial
    readFrame(video);
end

while(hasFrame(video))
    frame = readFrame(video);
    k=k+1
    imshow(frame);
end
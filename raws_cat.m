
src=uigetdir('choose the dir');
cd(src);
width = 1920;
height = 1080;
files = dir('*.raw');
n = numel(files);
total_framenum = 0;
% outfilename = 'cat_raw.raw';

for k = 1:n
   frame_num = raw_num(files(k).name,width,height);
   total_framenum = total_framenum + frame_num;
end

frame_num_k = ones(n);
for k = 1:n
    frame_num = raw_num(files(k).name,width,height);
    frame_num_k(k) = frame_num;
    FileID = fopen(files(k).name,'rb');
    ReadRawImage = fread(FileID, width*height*frame_num, 'uint16');
    if k==1    
    total_buffer = ReadRawImage;
    else 
%     ss = width*height*frame_num_k(k-1)+ 1;
%     ee = width*height*frame_num_k(k-1)+ width*height*2*frame_num;
    total_buffer = cat(1,total_buffer,ReadRawImage);
    end
    fclose(FileID);
end
outfileID = fopen(['cat_',files(1).name], 'wb');
fwrite(outfileID, total_buffer, 'uint16'); 
fclose(outfileID);
function frame_num = raw_num(input,width,height)
    FileID = fopen(input,'rb');
    framesize = width*height*2;
    fseek(FileID, 0, 'eof');
    fsize = ftell(FileID);
    frame_num = fsize/framesize;
    fclose(FileID);
end
function decrypt(fileName, zz_len, doFrames)
    fprintf('Starting decrypting %s ...\n',fileName);
    encodeStruct = load('encode.mat');
    encode = encodeStruct.shuffleMat;

    oneD_ori_zig = [1:zz_len*zz_len];
    oriMat = dezigzag1dto2d(oneD_ori_zig);

    oneD_zig_sf = zigzag2dto1d(encode);
    
    if ~exist(fileName)
        error('Encrypting video seems do not exist!');
    end
    obj = VideoReader(fileName);
    numFrames = obj.NumberOfFrame ;
    doFrames = min(doFrames, numFrames);
    video = read(obj,[1,doFrames]); 
    height = size(video,1);
    width = size(video,2);
    if mod(height,zz_len) ~=0
        height = floor(height/zz_len)*zz_len;
    end
    if mod(width,zz_len) ~=0
        width = floor(width/zz_len)*zz_len;
    end
    video = video(1:height,1:width,:,:);

    % write video
    [~,b,~] = fileparts(fileName);
    deFile = [b(1:end-7),'decrypt.mp4'];
    vidObj = VideoWriter(deFile,'MPEG-4');
    vidObj.Quality = 100;
    open(vidObj);

    % Decode
    for nF = 1:doFrames
        enFrame = video(:,:,:,nF);
        hs = height/zz_len;
        ws = width/zz_len;
        deFrame = zeros(size(enFrame));
        fprintf('Decrypting %s frame %d/%d\n',fileName, nF,doFrames);
        for i = 1:hs
            for j = 1:ws
                patch = enFrame(((i-1)*zz_len+1):i*zz_len,((j-1)*zz_len+1):j*zz_len,:);
                newPatch = zeros(zz_len,zz_len,3);
    %             for ind = 1:zz_len*zz_len
    %                 ind_x = floor((ind-1)/zz_len)+1;
    %                 ind_y = ind - zz_len*(ind_x-1);
    %                  sfIndV = oneD_ori_zig(ind);   
    %                 [sfInd_in2D_x, sfInd_in2D_y] = find(encode == sfIndV); 
    %                 newPatch(ind_x, ind_y,:) = patch(sfInd_in2D_x,sfInd_in2D_y,:);
    %             end
                for ind_x = 1:zz_len
                    for ind_y = 1:zz_len
                        sfIndV = oriMat(ind_x,ind_y);  
                        [sfInd_in2D_x, sfInd_in2D_y] = find(encode == sfIndV); 
                        newPatch(ind_x, ind_y,:) = patch(sfInd_in2D_x,sfInd_in2D_y,:);
                    end
                end
                deFrame(((i-1)*zz_len+1):i*zz_len,((j-1)*zz_len+1):j*zz_len,:) = newPatch;
            end
        end
        imwrite(deFrame/256, ['./imgs/','decrypt_', 'video_',b,'_frame_', num2str(nF),'.jpg'])
        writeVideo(vidObj,deFrame/256);
    end

    close(vidObj);
end
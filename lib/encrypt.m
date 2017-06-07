%% zz_len: the length of zig-zag mat, default 8.
function enFile = encrypt(fileName, zz_len, doFrames)
    fprintf('Starting encrypting %s...\n',fileName);
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
    
    enFile = [b, '_', 'encrypt.mp4'];
    vidObj = VideoWriter(enFile,'MPEG-4');
    vidObj.Quality = 100;
    open(vidObj);

    oneD_ori_zig = [1:zz_len*zz_len];
    oriMat = dezigzag1dto2d(oneD_ori_zig);

    oneD_zig_sf = randperm(zz_len*zz_len);
    shuffleMat = dezigzag1dto2d(oneD_zig_sf);

    for nF = 1:doFrames
        iFrame = video(:,:,:,nF);
        hs = height/zz_len;
        ws = width/zz_len;
        sfFrame = zeros(size(iFrame));
        fprintf('Encrypting %s frame %d/%d\n',fileName, nF,doFrames);
        for i = 1:hs
            for j = 1:ws
                patch = iFrame(((i-1)*zz_len+1):i*zz_len,((j-1)*zz_len+1):j*zz_len,:);
                newPatch = zeros(zz_len,zz_len,3);
    %             for ind = 1:zz_len*zz_len
    %                 ind_x = floor((ind-1)/zz_len)+1;
    %                 ind_y = ind - zz_len*(ind_x-1);
    %                 sfIndV = oneD_zig_sf(ind);  
    %                 [oriInd_in2D_x, oriInd_in2D_y] = find(oriMat == sfIndV);
    %                 newPatch(ind_x,ind_y,:) = patch(oriInd_in2D_x,oriInd_in2D_y,:); 
    %             end
                for ind_x = 1:zz_len
                    for ind_y = 1:zz_len
                        sfIndV = shuffleMat(ind_x, ind_y);   
                        [oriInd_in2D_x, oriInd_in2D_y] = find(oriMat == sfIndV); 
                        newPatch(ind_x,ind_y,:) = patch(oriInd_in2D_x,oriInd_in2D_y,:); 
                    end
                end
                sfFrame(((i-1)*zz_len+1):i*zz_len,((j-1)*zz_len+1):j*zz_len,:) = newPatch;
            end
        end
        imwrite(sfFrame/256, ['./imgs/','encrypt_', 'video_',b,'_frame_', num2str(nF),'.jpg'])
        writeVideo(vidObj,sfFrame/256);
    end

    close(vidObj);
    save('encode.mat','shuffleMat');
end
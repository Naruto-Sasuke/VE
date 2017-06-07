addpath(genpath('./.'));
zz_len = 8;     % window size
doFrames = 24;  % default 24f/s
oriFile = '2.mp4';  % video name
enFile = encrypt(oriFile,zz_len,doFrames);
decrypt(enFile,zz_len,doFrames);
% % De-zig-zag of 1D vector into 2D array

% % INPUT
% % Z: 1D zig-zag vector

% % OUTPUT
% % A: 2D array, restored from 1D zig-zag vector to original pattern

function A=dezigzag1dto2d(Z)

ind = zigzag4(sqrt(length(Z))); 

A=[];
for k=1:length(Z)
    A( ind(k,1),ind(k,2) )=Z(k);
end    

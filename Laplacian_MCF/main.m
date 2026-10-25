close all; clear all; clc;
% Fusion using MCF + Laplacian (Color Version)
cov_wsize = 5;     % window size for edge strength weights
pyr_levels = 4;    % number of pyramid levels
% Mean-Curvature Filter Parameters
mc_iters = 25;     % iterations (tune for smoothness)
mc_dt    = 0.18;   % time-step
arr = ['A';'B'];
for m = 1:2
    string = arr(m);
    inp_image = strcat('images\507_', string, '.tif');
    x{m} = imread(inp_image);
    
    if size(x{m},3) ~= 3
        x{m}=rgb2gray(x{m});
    end
    
    x{m} = double(x{m});
end
[M,N,~] = size(x{1});
xfused = zeros(M, N, 3);  % Preallocate fused color image
tic
% Process each color channel independently
for c = 1:3
    xA = x{1}(:,:,c);
    xB = x{2}(:,:,c);
    [lapA, lowA] = meancurve_laplacian_pyramid(xA, pyr_levels, mc_iters, mc_dt);
    [lapB, lowB] = meancurve_laplacian_pyramid(xB, pyr_levels, mc_iters, mc_dt);
    for l = 1:pyr_levels-1
        detail{1} = lapA{l};
        detail{2} = lapB{l};
        fusedLap{l} = fusef({lapA{l}, lapB{l}}, {detail{1}, detail{2}}, cov_wsize);
    end
    fusedLap{pyr_levels} = 0.5*(lowA + lowB);
    xfused(:,:,c) = reconstruct_from_meancurve_laplacian_pyramid(fusedLap, mc_iters, mc_dt);
end
toc
xfused8 = uint8(xfused);
%matrices_new(xfused8, x);
figure, imshow(uint8(x{1})), title('Input A');
figure, imshow(uint8(x{2})), title('Input B');
figure, imshow(xfused8), title('Fused Color Image (MCF + Laplacian Pyramid)');

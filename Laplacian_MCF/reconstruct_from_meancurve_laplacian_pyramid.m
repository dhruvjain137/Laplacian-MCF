function im = reconstruct_from_meancurve_laplacian_pyramid(lap_pyr, mc_iters, mc_dt)
levels = numel(lap_pyr);
im = lap_pyr{levels};
for l = levels-1:-1:1
    up = imresize(im, size(lap_pyr{l}), 'bilinear');
    up = mean_curvature_filter(up, 2, mc_dt); % light smoothing
    im = up + lap_pyr{l};
end
end
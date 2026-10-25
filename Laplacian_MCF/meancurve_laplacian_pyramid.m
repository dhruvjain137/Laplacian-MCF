function [lap_pyr, low] = meancurve_laplacian_pyramid(im, levels, mc_iters, mc_dt)
% Build Laplacian pyramid using mean-curvature filter
cur = im;
lap_pyr = cell(levels,1);
for l = 1:levels-1
    smooth = mean_curvature_filter(cur, mc_iters, mc_dt);
    small = imresize(smooth, 0.5, 'bilinear');
    up = imresize(small, size(cur), 'bilinear');
    up = mean_curvature_filter(up, max(2,round(mc_iters/6)), mc_dt);
    lap_pyr{l} = cur - up;
    cur = small;
end
low = cur;
lap_pyr{levels} = low;
end

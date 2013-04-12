function land2 = luminance(img)
% LUMINANCE detects whether an image is a landscape or not.
%
% This is the second of two tests to determine whether an image is a landscape. 
% It accounts for instances in which the sky is not primarily blue (such as
% with a sunset). The luminance horizon is more accurate than the blue
% horizon, but it risks including images (like family portraits) that also
% have a sharp decrease in luminance. Thus very strict additional tests are
% run to ensure that the top part of the image (the sky) is smoother than
% the bottom part in texture. 

%   IMG is a RGB image of any size.
%
%   The output argument LAND2 is a boolean indicating whether the image is a
%   landscape or not


%% LUMINANCE HORIZON TEST
% Similar 
u = rgb2ntsc(img);
lum1 = u(:,:,1);

meaned = mean(lum1, 2);
[v, y] = min(gradient(meaned));

% Use the minimum value of the gradient to create a horizon.
% The min of the gradient indicates the point at which the image changes
% from an area of high luminance (sky) to an area of low luminance
% (background)
horizon = y;
height = size(img, 1);
width = size (img, 2);

%If the horizon is in the top sixth or the bottom fifth of the image, it is
%not a horizon.
if ((horizon < (height / 5)) || (horizon > (4/5)*height))
    land2 = false;
    return
end

figure, imshow(img), hold on
plot (0:size(img,2), horizon)

%% SECONDARY TEST

% First, divide the image into two:
I1 = imcrop(img, [0 0 width horizon]);
I2 = imcrop(img, [0 horizon width height]);
e1 = entropy(I1);
e2 = entropy(I2);

% Next, compare complexity in texture by measuring entropy:
textureComp = 0;
if (e1 < e2)
   textureComp = 1;
end

% Run one more test of complexity by analyzing total pixels in
% edge image. This extra texture test cuts out false positives in family
% portraits, etc.
edge1 = mean2(edge(rgb2gray(I1), 'canny', 0.3));
edge2 = mean2(edge(rgb2gray(I2), 'canny', 0.3));

texture2Comp = 0;
if (edge1 < edge2)
    texture2Comp = 1;
end


if (textureComp || texture2Comp)
    land2 = true;
    return
else
    land2 = false;
    return
end
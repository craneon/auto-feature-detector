function land = landscape(img)
% LANDSCAPE detects whether an image is a landscape or not.
% This algorithm seeks a "blue horizon" - a horizon determined by a blue
% area in the upper part of the region. It then runs two subsequent tests to
% ensure that the image is a landscape - an entropy (texture) test, and a
% luminance test. 
%
%   IMG is a RGB image of any size.
%
%   The output argument LAND is a boolean indicating whether the image is a
%   landscape or not

%% BLUE HORIZON TEST: Detect whether there is a horizon line in the image. 
% This is the main indicator of landscape. To do this, break image into sky/ground
% using color-based region growing that detects the sky (assuming blue).

% Divide the color image into the blue color-channel image
blueImage = img(:,:,3);

% Binarize the image by applying a threshold of 125.
blueBinary = blueImage > 125;

% Label connected components in the binary image using region-growing
% function bwlabel. Connectivity is set to 8 to incorporate
% diagonally-connected pixels.
[taggedB,blueObjects] = bwlabel(blueBinary, 8);

% Eliminate all the noise from the tagged images by removing all connected 
% components that have fewer than n pixels with the command bwareaopen
taggedB = bwareaopen(taggedB, 100);

% Visualize the tagged regions with label2rgb, applying an appropriate color map.
% The parameter 'k' sets zero values to black.
figure
imshow(label2rgb (taggedB, 'cool', 'k'));

% Uses regionprops function to calculate the statistics (the area,
% centroid, and bounding box) from each group of colored objects. These
% stats can be called to fill out the values of the table with the
% functions stats.Centroid, etc.
statsBlue = regionprops(taggedB);


%% HORIZON: Now identify the horizon line in the image based on the blue region

% Set the horizon equal to the point at which the blue region starts
% deteriorating past the point where 70% of a row is blue.
detector = find((mean(blueBinary, 2)) >= 0.7);
horizon = detector(end);
height = size(img, 1);
width = size (img, 2);

%If the horizon is in the top sixth or the bottom fifth of the image, it is
%not a horizon.
if ((horizon < (height / 6)) || (horizon > (4/5)*height))
    land = false;
    return
end

figure, imshow(img), hold on
plot (0:size(img,2), horizon)

%% SECONDARY TESTS
% If the detector passes the first (main) test, then proceed onward to
% confirm that the horizon boundary actually indicates a sky. This relies
% on two assumptions: 1) the luminance of the sky is greater than that of
% the landscape, and 2) the detail (texture) of the landscape is more
% complex than that of the sky.

% First, divide the image into two:
I1 = imcrop(img, [0 0 width horizon]);
I2 = imcrop(img, [0 horizon width height]);

% Next, compare complexity in texture by measuring entropy:
textureComp = 0;
if (entropy(I1) < entropy(I2))
   textureComp = 1; 
end

% Next, measure relative luminance:
u = rgb2ntsc(I1);
lum1 = u(:,:,1);
v = rgb2ntsc(I2);
lum2 = v(:,:,1);

luminanceComp = 0;
if (mean2(I1) > mean2(I2))
    luminanceComp = 1;
end

% The above-horizon part must past both of the secondary tests in order to 
% be labeled a landscape sky.

if (luminanceComp && textureComp)
    land = true;
    return
else
    land = false;
    return
end


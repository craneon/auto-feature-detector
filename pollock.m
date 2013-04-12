function poll = pollock(img)
% POLLOCK Checks whether the image is a Pollock

% Reduce the number of colors in an image to 4 by creating an indexed image
% and a new colormap. Matlab documentation available here:
% http://www.mathworks.com/help/images/reducing-the-number-of-colors-in-an-image.html
% (Researching how to do this part took the longest amount of time -
% alternatives including using a histogram to detect major colors in the
% image, but this method is faster and less processor-intensive)

[x, newmap]= rgb2ind(img,4,'nodither');
figure, imshow(x, newmap);


% Create binary images for each color (8)
binary0 = (x == 0);
binary1 = (x == 1);
binary2 = (x == 2);
% binary3 = (x == 3);

% Use region-growing to detect segmented color splotches
[tagged0,objects0] = bwlabel(binary0, 8);
[tagged1,objects1] = bwlabel(binary1, 8);
[tagged2,objects2] = bwlabel(binary2, 8);
% [tagged3,objects3] = bwlabel(binary3, 8);


% Visualize different color splotches
figure, imshow(label2rgb (tagged0, 'autumn', 'k'));
figure, imshow(label2rgb (tagged1, 'spring', 'k'));
figure, imshow(label2rgb (tagged2, 'winter', 'k'));
% figure, imshow(label2rgb (tagged3, 'summer', 'k'));

%% TEST ONE: Object Prevalence
% Detect the number of salient objects produced from the region-growing
% algorithm above. When the color space is reduced to three colors by the
% color reduction function above, more salient objects indicates a huge
% variance in the location of the color splotches, indicating a
% splatter-paint method.
splatterTest = 0;
if (objects0 > 1000 && objects1 > 1000 && objects2 > 1000)
    splatterTest = 1;
end

%% TEST TWO: Edge Complexity
% While a high degree of object salience is related to edge complexity, one
% additional test is used to look for a huge number of edges within the
% image. A high threshold is used with the Canny edge detector so that
% other images with relatively complex edges will have to reach a higher
% barrier

edgeTest = 0;
edges = mean2(edge(rgb2gray(img), 'canny', 0.3));
if (edges > 0.1)
    edgeTest = 1;
end

% Combining tests
if (splatterTest && edgeTest)
    poll = true;
    return
else
    poll = false;
    return
end






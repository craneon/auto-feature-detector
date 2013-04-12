#Computational Vision Feature Detector#

##Files Included##

###Landscape Detector###

**LANDSCAPE** detects whether an image is a landscape or not.
This algorithm seeks a "blue horizon" - a horizon determined by a blue area in the upper part of the region. It then runs two subsequent tests to ensure that the image is a landscape - an entropy (texture) test, and a luminance test. This relies on two assumptions: 1) the luminance of the sky is greater than that of the landscape, and 2) the detail (texture) of the landscape is more complex than that of the sky.

**LUMINANCE** detects whether an image is a landscape or not.
This is the second of two tests to determine whether an image is a landscape. It accounts for instances in which the sky is not primarily blue (such as with a sunset). The luminance horizon is more accurate than the blue horizon, but it risks including images (like family portraits) that also have a sharp decrease in luminance. Thus very strict additional tests are run to ensure that the top part of the image (the sky) is smoother than the bottom part in texture. 

###Pollock Detector###

**POLLOCK** Checks whether the image is a Pollock

This algoritm first reduces the number of colors in an image to 4 by creating an indexed image and a new colormap. Matlab documentation available here: http://www.mathworks.com/help/images/reducing-the-number-of-colors-in-an-image.html (Alternatives including using a histogram to detect major colors in the image, but this method is faster and less processor-intensive).

It then runs two tests: object prevalence, and 

The Object Prevalence test detects the number of salient objects produced from the region-growing algorithm. When the color space is reduced to three colors by the color reduction function above, more salient objects indicates a huge variance in the location of the color splotches, indicating a splatter-paint method. 

Test two is Edge Complexity: While a high degree of object salience is related to edge complexity, one additional test is used to look for a huge number of edges within the image. A high threshold is used with the Canny edge detector so that other images with relatively complex edges will have to reach a higher threshold.

%% Here to calculate the waviness of fiber-like structure in a 2D context.
% This is the main program

%% Here to load the image of fiber-like structure.
clear;
rawimg = imread('D:\col waviness\MATLAB code of waviness calculation\examples\10.tif'); % modify 1 
% Set the path of the folder where fiber images are saved.
grayimg = im2gray(rawimg);
FibImg = double(grayimg);
sz1 = size(FibImg,1);
sz2 = size(FibImg,2);
% 'rawimg' is the raw intensity image.
% 'FibImg' is the grayscale fiber image used for waviness analysis.
% 'sz1' and 'sz2' is the size of the fiber image.

%% Here to calculate the pixel-wise fiber orientation 
armd = 3; % modify 2
% The width of window for orientation calculation is '2*armd+1'.
% 'armd' is chosen based on the diamater of fibers. Typically '2*armd+1'
% is 2 to 3 times the diameter of fiber so as to provide optimal accuracy.
filton = 1;
% 'filton' is a binary variable that tells program whether to filter the
% data prior to analysis. 1: filtering; 0: no filtering.
[aS] = calcfibangspeed(FibImg,armd,filton);
aSDE = aS*180/pi;
% 'calcfibangspeed.m' is the function which calculates the pixel-wise
% orientation of a fiber image. 'aS' is the output of the orientation
% matrix in the radian form(range from 0-pi) while 'aSDE' the angle 
% form(range from 0-180).

%% Here to create the mask selecting fiber regions
threshint = 10;  % modify 3 
% 'threshint' is the raw background intensity acquired by averaging 
% intensity of several regions identified as background.
maska3d = FibImg > threshint; 
% 'maska3d' is a raw binary mask based on the raw background intensity
meanint = mean(FibImg(maska3d)); 
% Calculate the mean intensity within the raw binary mask.
threshinta = 0.45*meanint; % modify 4 
% 'threshinta' is an inmproved intensity threshold, and the factor '0.45' 
% can be adjusted according to different sample.
maska3da = FibImg > threshinta;
% 'maska3da' is an improved binary mask
finalmaska = maska3d.*maska3da;
% 'finalmaska' is the binary mask acquired based on the above two masks
Maskf1 = finalmaska; 
Maskf2 = miprmdebrisn(Maskf1,15);
% 'miprmdebrisn.m' is a function which is able to remove very tiny structures
finalmask = logical(Maskf2);
% 'finalmask' is the final binary mask selecting the fiber-only regions.

%% Here to calculate the pixel-wise fiber waviness.
wavarmdx = 10;% modify 5 
wavarmdy = 10;% modify 6 
% The width of window for waviness calculation in 'x' and 'y' dimensions
% is '2*wavarmdx+1' and '2*wavarmdy+1', and normally these two value remain
% the same. 'wavarmdx' and 'wavarmdx' are chosen based on the diamater 
% of fibers. Typically '2*wavarmdx/wavarmdy+1' is 5 to 6 times the diameter of fiber.
[wavmatr] = wavwin_cal2D(wavarmdy,wavarmdx,aSDE,double(finalmask),sz1,sz2);
Meanwav = mean(wavmatr(finalmask));
% 'wavwin_cal.m' is the function which calculates the pixel-wise
% waviness of a fiber image. Width of window 'wavarmdx' and 'wavarmdy', 
% orientation matrix 'aSDE', size of the fiber image 'sz1' and 'sz2' are
% the input parameters for the waviness calculation function.
%'wavmatr' is the output waviness matrix. 'Meanwav' is the mean waviness of 
% all the fiber pixels selected  by 'finalmask' in the image.

%% Here to do post-processing.
% For post-processing, we prepare the 'pretty' images of orientation and
% waviness. In these 'pretty' images, the raw intensity image 
% is used to provide the contrast of fiber features, and the orientation or
% waviness maps are labeled by different colors to show the orientation 
% or waviness information

% first, prepare the pretty waviness map
fibimgre = FibImg;
fibimgre = fibimgre/max(max(max(fibimgre)));

uplim = 1;
botlim = 0;
bright = 0.99;
dark = 0.01;
prettywav = prettymap(wavmatr,fibimgre,'none',jet(64),uplim,botlim,bright,dark);
% 'prettymap.m' is the function used to create 'pretty' maps.
% 'wavmatr' is the input waviness matrix, 'fiberimgre' is the  normalized 
% raw fiber image.'jet(64)' designates the color scheme. 'uplim' and 'botlim' 
% are the upper and bottom limits of the orientation metric. The range 
% of waviness is 0-1. 'bright' and 'dark' are used to enhance the contrast 
% of the image. 'prettywav' is the output waviness map labeled by different 
% colors to show waviness information.

uplim = 180;
botlim = 0;
prettyori = prettymap(aSDE,fibimgre,'none',hsv(64),uplim,botlim,bright,dark);
% 'aSDE' is the input orientation matrix, and the range of orientation is
% 0-180. 'prettyori' is the output orientation map labeled by different 
% colors to show orientation information.
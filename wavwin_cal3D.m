function [wavmatr] = wavwin_cal3D(ywin,xwin,zwin,orimatr,finalmask)
% This function calculates the voxel-wise waviness. The output and input
% indices are explained in the main program

% Here to set up the parameters.
[sz1,sz2,sz3] = size(orimatr);
oriwin = zeros(2*ywin+1 , 2*xwin+1 , 2*zwin+1);
wavmatr = zeros(sz1,sz2,sz3);
oripad = zeros(sz1,sz2,sz3+2*zwin);
fmpad = zeros(sz1,sz2,sz3+zwin);
for k = 1:zwin
    oripad(:,:,k) = orimatr(:,:,1);
    oripad(:,:,zwin+sz3+k) = orimatr(:,:,sz3);
    fmpad(:,:,k) = finalmask(:,:,1);
    fmpad(:,:,zwin+sz3+k) = finalmask(:,:,sz3);
end
oripad(:,:,zwin+1 : zwin+sz3) = orimatr;
fmpad(:,:,zwin+1 : zwin+sz3) = finalmask;
oripad = padarray(oripad,[ywin,xwin],'replicate');
fmpad = padarray(fmpad,[ywin,xwin],'replicate');

% Here to calculate the fiber waviness voxel by voxel.
for z = 1 : sz3
    for r = 1 : sz1
        for c = 1 : sz2
            if finalmask(r,c,z) == 1
                oriwin = oripad(r : r+2*ywin , c : c+2*xwin , z : z+2*zwin);
                fmwin = fmpad(r : r+2*ywin , c : c+2*xwin , z : z+2*zwin);
                wavmatr(r,c,z) = angdiff_filt(oriwin,fmwin,orimatr(r,c,z));
                % 'angdiff_filt.m' is the function to do cross-correlation
                % between the two windows extracted from binary mask 'finalmask' 
                % and orientation matrix 'orimatr'. The input parameters for
                % this function is the two window 'oriwin' and 'fmwin', and the
                % orientation of the center window voxel.
            else
                wavmatr(r,c,z) = 0;
            end
        end
    end
end
wavmatr = wavmatr/90;

end

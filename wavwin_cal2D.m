function [wavmatr] = wavwin_cal2D(xwin,ywin,orimatr,finalmask,sz1,sz2)
% This function calculates the pixel-wise waviness. The output and input
% indices are explained in the main program

% Here to set up the parameters.
oriwin = zeros(2*xwin+1 , 2*ywin+1); 
wavmatr = zeros(sz1,sz2);
oripad = padarray(orimatr,[xwin,ywin],'replicate');
fmpad = padarray(finalmask,[xwin,ywin],'replicate');
% Here to calculate the fiber waviness pixel by pixel.
for r = 1:sz1
    for c = 1:sz2
        if finalmask(r,c) == 1        
            oriwin = oripad(r : r+2*xwin , c : c+2*ywin);
            fmwin = fmpad(r : r+2*xwin , c : c+2*ywin);
            wavmatr(r,c) = angdiff_filt(oriwin,fmwin,orimatr(r,c));
            % 'angdiff_filt.m' is the function to do cross-correlation
            % between the two windows extracted from binary mask 'finalmask' 
            % and orientation matrix 'orimatr'. The input parameters for
            % this function is the two window 'oriwin' and 'fmwin', and the
            % orientation of the center window pixel.
        else
            wavmatr(r,c) = 0;
        end
    end
end
wavmatr = wavmatr/90;

end
function [oridiff] = angdiff_filt(oriwin,fmwin,ct_ori)
% This function processes the cross-correlation.
fib_ind = find(fmwin~=0);
oriwin(fib_ind) = abs(oriwin(fib_ind) - ct_ori);
ind_erro = find(oriwin>90);
oriwin(ind_erro) = 180-oriwin(ind_erro);
oridiff = sum(oriwin(fib_ind))/(max(size(fib_ind))-1);
end
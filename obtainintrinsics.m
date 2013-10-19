count=0;
go_calib_optim
%Obtains the focal length of the camera
intrinsics_fc=fc';
fprintf('The focal length is:\n')
intrinsics_fc
%Obtains the Principle point of the camera
fprintf('Principle Poinr is: \n')
intrinsics_cc=cc';
intrinsics_cc
%Obtains the skew
intrinsics_alpha_c=alpha_c;
fprintf('Skew is:\n')
intrinsics_alpha_c
%obtains the Distortion
fprintf('Distortion')
intrinsics_kc=kc';
intrinsics_kc;
%Obtains the pixel error
intrinsics_err=fc_error';
fprintf('Pixel Error: ')
intrinsics_err


%obtains 201 frames of both depth and rgb
if exist('vid')
    closepreview(vid)
end
Obtainframesfromcallibrationdance
%selects 29 random frames
choose_n_images(imcolour,29)
%generates the final frame for tranform
rgb=uint8(imcolour(:,:,:,201));
imwrite(rgb,strcat('rgb_',num2str(30),'.jpg'));
%runs a modified raddocc calibration and puts the intrinsic data into the 
%required form
obtainintrinsics
%creates 30 4 by 4 transformation matrices based on the values provided
%from calibration
extrinsictranformation
Callibration=1;
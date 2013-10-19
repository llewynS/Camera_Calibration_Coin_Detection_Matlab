%Takes an image for colour callibration
fprintf('Starting Colour Calibration...')
if exist('vid')
    closepreview(vid)
end
coloure
%cakcukate the rgb, hsv and YCbrCb colour valuse for all 24 squares of the
%Gretag-Macbethh colour chart
RGBHSVYCRCB
fprintf('\n RGB value for #12 is')
RGBChart_12
fprintf('\n HSV value for #12 is')
HSV_12
fprintf('\n YCbCr value for #12 is')
YCbCr_12
fprintf('\n RGB value for #21 is')
RGBChart_21
fprintf('\n HSV value for #21 is')
HSV_21
fprintf('\n YCbCr value for #21 is')
YCbCr_21
fprintf('\n')
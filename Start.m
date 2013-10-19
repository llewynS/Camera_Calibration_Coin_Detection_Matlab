%function calib_gui_normal,


cell_list = {};


%-------- Begin editable region -------------%
%-------- Begin editable region -------------%


fig_number = 1;

title_figure = 'Kinect Calibration and Coin detection';

clear fc cc kc KK
kc = zeros(5,1);
clearwin;
Callibration=0;
cell_list{1,1} = {'Open Feed','openfeed;'};
cell_list{2,1} = {'Close Feed','closefeed;'};
cell_list{1,2} = {'Colour Calibration','METR4202ColourCallibration;'};
cell_list{2,2} = {'Calibrate Camera','METR4202Callibration;'};
cell_list{1,3} = {'Coin Counter','METR4202CoinCounting;'};
cell_list{2,3} = {'Exit',['disp(''Bye. To run again, type Start.''); close(' num2str(fig_number) ');']}; %{'Exit','calib_gui;'};



show_window(cell_list,fig_number,title_figure,130,18,0,'clean',12);


%-------- End editable region -------------%
%-------- End editable region -------------%

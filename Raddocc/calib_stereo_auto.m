% calib_stereo
% Script for Calibrating a stereo rig (two cameras, internal and external calibration):
%
% It is assumed that the two cameras (left and right) have been calibrated with the pattern at the same 3D locations, and the same points
% on the pattern (select the same grid points). Therefore, in particular, the same number of images were used to calibrate both cameras.
% The two calibration result files must have been saved under Calib_Results_left.mat and Calib_Results_right.mat prior to running this script.
% This script is not fully documented, therefore use it at your own risks. However, it should be rather straighforward to run.
%
% INPUT: Calib_Results_left.mat, Calib_Results_right.mat -> Generated by the standard calibration toolbox on the two cameras individually)
% OUTPUT: Calib_Results_stereo.mat -> The saved result after global stereo calibration
% 
% Main result variables stored in Calib_Results_stereo.mat:
% om, R, T: relative rotation and translation of the right camera wrt the left camera
% fc_left, cc_left, kc_left, alpha_c_left, KK_left: New intrinsic parameters of the left camera
% fc_right, cc_right, kc_right, alpha_c_right, KK_right: New intrinsic parameters of the right camera
% 
% Both sets of intrinsic parameters are equivalent to the classical {fc,cc,kc,alpha_c,KK} described online at:
% http://www.vision.caltech.edu/bouguetj/calib_doc/parameters.html
%
% Note: If you do not want to recompute the intinsic parameters, through stereo calibration you may want to set
% recompute_intrinsic_right and recompute_intrinsic_left to zero. Default: 1
%
% Definition of the extrinsic parameters: R and om are related through the rodrigues formula (R=rodrigues(om)).
% Consider a point P of coordinates XL and XR in the left and right camera reference frames respectively.
% XL and XR are related to each other through the following rigid motion transformation:
% XR = R * XL + T
% R and T (or equivalently om and T) fully describe the relative displacement of the two cameras.
%
%
% If the Warning message "Disabling view kk - Reason: the left and right images are found inconsistent" is encountered, that probably
% means that for the kkth pair of images, the left and right images are found to have captured the calibration pattern at two
% different locations in space. That means that the two views are not consistent, and therefore cannot be used for stereo calibration.
% When capturing your images, make sure that you do not move the calibration pattern between capturing the left and the right images.
% The pattwern can (and should) be moved in space only between two sets of (left,right) images.
% Another reason for inconsistency is that you selected a different set of points on the pattern when running the separate calibrations
% (leading to the two files Calib_Results_left.mat and Calib_Results_left.mat). Make sure that the same points are selected in the
% two separate calibration. In other words, the points need to correspond.

% (c) Jean-Yves Bouguet - Intel Corporation
% October 25, 2001 -- Last updated April 12, 2002


fprintf(1,'\n\nStereo Calibration script (for more info, try help calib_stereo)\n\n');

if (exist('Calib_Results_left.mat')~=2)|(exist('Calib_Results_right.mat')~=2),
    fprintf(1,'Error: Need the left and right calibration files Calib_Results_left.mat and Calib_Results_right.mat to run stereo calibration\n');
    return;
end;

if ~exist('recompute_intrinsic_right'),
    recompute_intrinsic_right = 1;
end;


if ~exist('recompute_intrinsic_left'),
    recompute_intrinsic_left = 1;
end;


%% Load data
fprintf(1,'Loading the left camera calibration result file Calib_Results_left.mat...\n');

clear calib_name

load Calib_Results_left;

fc_left = fc;
cc_left = cc;
kc_left = kc;
alpha_c_left = alpha_c;
KK_left = KK;

center_optim_left = center_optim;
est_alpha_left = est_alpha;
est_dist_left = est_dist;
est_fc_left = est_fc;
est_aspect_ratio_left = est_aspect_ratio;
active_images_left = active_images;


if exist('calib_name')
    calib_name_left = calib_name;
    format_image_left = format_image;
    type_numbering_left = type_numbering;
    image_numbers_left = image_numbers;
    N_slots_left = N_slots;
else
    calib_name_left = '';
    format_image_left = '';
    type_numbering_left = '';
    image_numbers_left = '';
    N_slots_left = '';
end    

for kk = 1:n_ima,
   
   if active_images(kk),
       X_left{kk}=eval(['X_',num2str(kk)]);
       xi_left{kk}=eval(['x_',num2str(kk)]);
       omc_left{kk}=eval(['omc_',num2str(kk)]);
       Rc_left{kk}=eval(['Rc_',num2str(kk)]);
       Tc_left{kk}=eval(['Tc_',num2str(kk)]);
       x_left{kk}=Rc_left{kk}*X_left{kk}+repmat(Tc_left{kk},1,size(X_left{kk},2));
   end
end




fprintf(1,'Loading the right camera calibration result file Calib_Results_right.mat...\n');

clear calib_name

load Calib_Results_right;

fc_right = fc;
cc_right = cc;
kc_right = kc;
alpha_c_right = alpha_c;
KK_right = KK;

if exist('calib_name')
    calib_name_right = calib_name;
    format_image_right = format_image;
    type_numbering_right = type_numbering;
    image_numbers_right = image_numbers;
    N_slots_right = N_slots;
else
    calib_name_right = '';
    format_image_right = '';
    type_numbering_right = '';
    image_numbers_right = '';
    N_slots_right = '';
end

center_optim_right = center_optim;
est_alpha_right = est_alpha;
est_dist_right = est_dist;
est_fc_right = est_fc;
est_aspect_ratio_right = est_aspect_ratio;
active_images_right = active_images;

for kk = 1:n_ima,
   
   if active_images(kk),
       
       X_right{kk}=eval(['X_',num2str(kk)]);
       xi_right{kk}=eval(['x_',num2str(kk)]);
       omc_right{kk}=eval(['omc_',num2str(kk)]);
       Rc_right{kk}=eval(['Rc_',num2str(kk)]);
       Tc_right{kk}=eval(['Tc_',num2str(kk)]);
       x_right{kk}=Rc_right{kk}*X_right{kk}+repmat(Tc_right{kk},1,size(X_right{kk},2));
   end
end


%% Get Initial Estimate

om_ref_list = [];
for ii = 1:n_ima
    if active_images(ii)
        % Align the structure from the first view:
        R_ref = rodrigues(omc_right{ii}) * rodrigues(omc_left{ii})';
        om_ref = rodrigues(R_ref);
        om_ref_list = [om_ref_list om_ref];
    end
end

rot = median(om_ref_list,2);

planes1=GetCameraPlanes2('Calib_Results_left.mat');
planes2=GetCameraPlanes2('Calib_Results_right.mat');

delta0=[0;0;0];
% rot0=[0;0;0];

% change to radians
% rot0=deg2rad(rot0);
% phi0=angvec2dcm(rot0);


% options = optimset('LargeScale','on','Display','off');
% options = optimset(options, 'MaxFunEvals', 10000000);
% options = optimset(options, 'MaxIter', 1000);
% options = optimset('LevenbergMarquardt','on');

%Uses the Rodrigues parametrisation

% rot0=rodrigues(phi0);
% [rot,res] = lsqnonlin(@(rot)phierror(planes1,planes2,rot),rot0,[],[],options);

A=(planes2./repmat(sqrt(sum(planes2.^2)),3,1))';
b=sqrt(sum(planes2.^2))-sqrt(sum(planes1.^2));
b=b';
delta = A\b;
phi=rodrigues(rot);

disp('Initial Estimate');
disp('Delta:');
disp(delta);
disp('Phi:');
disp(rad2deg(rot));

%% Match Points

% loop until convergence
rpts=0;
lpts=0;
rptspre=rpts+1;
lptspre=lpts+1;

% testing
% delta=[-330;-1;17];

while ~isequal(rpts,rptspre) || ~isequal(lpts,lptspre)
    rptspre=rpts;
    lptspre=lpts;
    rpts=[];
    lpts=[];
    for cntr=1:size(x_left,2);
        [matc,err]=matchpts(x_right{cntr},x_left{cntr},delta,phi);
        lptinds=find(matc);
        rptinds=matc(lptinds);        
        lpts=[lpts,x_left{cntr}(:,lptinds)];
        rpts=[rpts,x_right{cntr}(:,rptinds)];
    end
%     find solution
    deltarot0=[delta;rodrigues(phi)];
    options=optimset('LargeScale','on','Display','off');
%     options = optimset('LevenbergMarquardt','on','Display','off');
    deltarot=lsqnonlin(@(deltarot)sterroptfn(rpts,lpts,deltarot),deltarot0,[],[],options);
    delta=deltarot(1:3);
    rot=deltarot(4:6);
    phi=rodrigues(rot);
    disp('Delta:');
    disp(delta);
    disp('Phi:');
    disp(rad2deg(rot));
end

% change naming conventions
T=delta;
om=rot;

% take common rectangle from each view

for cntr=1:size(x_left,2);
    [matc,err]=matchpts(x_right{cntr},x_left{cntr},delta,phi);
    lptinds=find(matc);
    rptinds=matc(lptinds);        
    X_left{cntr}=X_left{cntr}(:,lptinds);
    X_right{cntr}=X_right{cntr}(:,rptinds);
    x_left{cntr}=x_left{cntr}(:,lptinds);
    x_right{cntr}=x_right{cntr}(:,rptinds);
    xi_left{cntr}=xi_left{cntr}(:,lptinds);
    xi_right{cntr}=xi_right{cntr}(:,rptinds);
end

% show on images to make sure there are no discrepancies

% figure;
% for cntr=1:size(x_left,2)
%     clf;
%     subplot 121;
%     hold on;
%     imshow(GetImage2('Calib_Results_left.mat',cntr),[]);
%     plot(xi_left{cntr}(1,:),xi_left{cntr}(2,:),'o');
%     subplot 122;
%     hold on;
%     imshow(GetImage2('Calib_Results_right.mat',cntr),[]);
%     plot(xi_right{cntr}(1,:),xi_right{cntr}(2,:),'ro');
%     pause;
% end


%% Re-optimize now over all the set of extrinsic unknows (global optimization) and intrinsic parameters:


if ~recompute_intrinsic_left,
    fprintf(1,'No recomputation of the intrinsic parameters of the left camera (recompute_intrinsic_left = 0)\n');
    center_optim_left = 0;
    est_alpha_left = 0;
    est_dist_left = zeros(5,1);
    est_fc_left = [0;0];
    est_aspect_ratio_left = 1; % just to fix conflicts
end;

if ~recompute_intrinsic_right,
    fprintf(1,'No recomputation of the intrinsic parameters of the right camera (recompute_intrinsic_left = 0)\n');
    center_optim_right = 0;
    est_alpha_right = 0;
    est_dist_right = zeros(5,1);
    est_fc_right = [0;0];
    est_aspect_ratio_right = 1; % just to fix conflicts
end;




threshold = 50; %1e10; %50; 

active_images = active_images_left & active_images_right;

history = [];

fprintf(1,'\nMain stereo calibration optimization procedure - Number of pairs of images: %d\n',length(find(active_images)));
fprintf(1,'Gradient descent iteration: ');
    
for iter = 1:12;
    
    
    fprintf(1,'%d...',iter);
    
    % Jacobian:
    
    J = [];
    e = [];
    
    param = [fc_left;cc_left;alpha_c_left;kc_left;fc_right;cc_right;alpha_c_right;kc_right;om;T];
    
    
    for kk = 1:n_ima,
        
        if active_images(kk),
            
            % Project the structure onto the left view:
            
            Xckk=X_left{kk};
            omckk=omc_left{kk};
            Tckk=Tc_left{kk};
            
            xlkk=xi_left{kk};
            xrkk=xi_right{kk};
            
            param = [param;omckk;Tckk];
            
            % number of points:
            Nckk = size(Xckk,2);
            
            
            Jkk = sparse(4*Nckk,20+(1+n_ima)*6);
            ekk = zeros(4*Nckk,1);
            
            
            if ~est_aspect_ratio_left,
                [xl,dxldomckk,dxldTckk,dxldfl,dxldcl,dxldkl,dxldalphal] = project_points2(Xckk,omckk,Tckk,fc_left(1),cc_left,kc_left,alpha_c_left);
                dxldfl = repmat(dxldfl,[1 2]);
            else
                [xl,dxldomckk,dxldTckk,dxldfl,dxldcl,dxldkl,dxldalphal] = project_points2(Xckk,omckk,Tckk,fc_left,cc_left,kc_left,alpha_c_left);
            end;
        
            
            ekk(1:2*Nckk) = xlkk(:) - xl(:);
            
            Jkk(1:2*Nckk,6*(kk-1)+7+20:6*(kk-1)+7+2+20) = sparse(dxldomckk);
            Jkk(1:2*Nckk,6*(kk-1)+7+3+20:6*(kk-1)+7+5+20) = sparse(dxldTckk);
            
            Jkk(1:2*Nckk,1:2) = sparse(dxldfl);
            Jkk(1:2*Nckk,3:4) = sparse(dxldcl);
            Jkk(1:2*Nckk,5) = sparse(dxldalphal);
            Jkk(1:2*Nckk,6:10) = sparse(dxldkl);
            
            
            % Project the structure onto the right view:
            
            [omr,Tr,domrdomckk,domrdTckk,domrdom,domrdT,dTrdomckk,dTrdTckk,dTrdom,dTrdT] = compose_motion(omckk,Tckk,om,T);
            
            if ~est_aspect_ratio_right,
                [xr,dxrdomr,dxrdTr,dxrdfr,dxrdcr,dxrdkr,dxrdalphar] = project_points2(Xckk,omr,Tr,fc_right(1),cc_right,kc_right,alpha_c_right);
                dxrdfr = repmat(dxrdfr,[1 2]);
            else
                [xr,dxrdomr,dxrdTr,dxrdfr,dxrdcr,dxrdkr,dxrdalphar] = project_points2(Xckk,omr,Tr,fc_right,cc_right,kc_right,alpha_c_right);
            end;
            
            
            ekk(2*Nckk+1:end) = xrkk(:) - xr(:);
            
            
            dxrdom = dxrdomr * domrdom + dxrdTr * dTrdom;
            dxrdT = dxrdomr * domrdT + dxrdTr * dTrdT;
            
            dxrdomckk = dxrdomr * domrdomckk + dxrdTr * dTrdomckk;
            dxrdTckk = dxrdomr * domrdTckk + dxrdTr * dTrdTckk;
            
            
            Jkk(2*Nckk+1:end,1+20:3+20) =  sparse(dxrdom);
            Jkk(2*Nckk+1:end,4+20:6+20) =  sparse(dxrdT);
            
            
            Jkk(2*Nckk+1:end,6*(kk-1)+7+20:6*(kk-1)+7+2+20) = sparse(dxrdomckk);
            Jkk(2*Nckk+1:end,6*(kk-1)+7+3+20:6*(kk-1)+7+5+20) = sparse(dxrdTckk);
            
            Jkk(2*Nckk+1:end,11:12) = sparse(dxrdfr);
            Jkk(2*Nckk+1:end,13:14) = sparse(dxrdcr);
            Jkk(2*Nckk+1:end,15) = sparse(dxrdalphar);
            Jkk(2*Nckk+1:end,16:20) = sparse(dxrdkr);
            
            
            emax = max(abs(ekk));
            
            if emax < threshold,
                
                J = [J;Jkk];
                e = [e;ekk];           
                
            else
                
                fprintf(1,'Disabling view %d - Reason: the left and right images are found inconsistent (try help calib_stereo for more information)\n',kk);
                
                active_images(kk) = 0;
                
            end;
            
        else
            
            param = [param;NaN*ones(6,1)];
            
        end;
        
    end;
    
    history = [history param];
    
    ind_Jac = find([est_fc_left & [1;est_aspect_ratio_left];center_optim_left*ones(2,1);est_alpha_left;est_dist_left;est_fc_right & [1;est_aspect_ratio_right];center_optim_right*ones(2,1);est_alpha_right;est_dist_right;ones(6,1);reshape(ones(6,1)*active_images,6*n_ima,1)]);
    
    ind_active = find(active_images);
    
    J = J(:,ind_Jac);
    J2 = J'*J;
    J2_inv = inv(J2);
    
    param_update = J2_inv*J'*e;
    
    
    param(ind_Jac) = param(ind_Jac) + param_update;
    
    fc_left = param(1:2);
    cc_left = param(3:4);
    alpha_c_left = param(5);
    kc_left = param(6:10);
    fc_right = param(11:12);
    cc_right = param(13:14);
    alpha_c_right = param(15);
    kc_right = param(16:20);
    
    
    if ~est_aspect_ratio_left,
        fc_left(2) = fc_left(1);
    end;
    if ~est_aspect_ratio_right,
        fc_right(2) = fc_right(1);
    end;
    
    
    om = param(1+20:3+20);
    T = param(4+20:6+20);
    
    
    for kk = 1:n_ima;
        
        if active_images(kk),
            
            omckk = param(6*(kk-1)+7+20:6*(kk-1)+7+2+20);
            Tckk = param(6*(kk-1)+7+3+20:6*(kk-1)+7+5+20);
            
            eval(['omc_left_' num2str(kk) ' = omckk;']);
            eval(['Tc_left_' num2str(kk) ' = Tckk;']);
            
        end;
        
    end;
    
    
end;

% fprintf(1,'done\n');


history = [history param];

inconsistent_images = ~active_images & (active_images_left & active_images_right);


sigma_x = std(e(:));
param_error = zeros(20 + (1+n_ima)*6,1);
param_error(ind_Jac) =  3*sqrt(full(diag(J2_inv)))*sigma_x;

for kk = 1:n_ima;
    
    if active_images(kk),
        
        omckk_error = param_error(6*(kk-1)+7+20:6*(kk-1)+7+2+20);
        Tckk = param_error(6*(kk-1)+7+3+20:6*(kk-1)+7+5+20);
        
        eval(['omc_left_error_' num2str(kk) ' = omckk;']);
        eval(['Tc_left_error_' num2str(kk) ' = Tckk;']);
        
    else
        
        eval(['omc_left_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['Tc_left_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['omc_left_error_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['Tc_left_error_' num2str(kk) ' = NaN*ones(3,1);']);
        
    end;
    
end;

fc_left_error = param_error(1:2);
cc_left_error = param_error(3:4);
alpha_c_left_error = param_error(5);
kc_left_error = param_error(6:10);
fc_right_error = param_error(11:12);
cc_right_error = param_error(13:14);
alpha_c_right_error = param_error(15);
kc_right_error = param_error(16:20);

if ~est_aspect_ratio_left,
    fc_left_error(2) = fc_left_error(1);
end;
if ~est_aspect_ratio_right,
    fc_right_error(2) = fc_right_error(1);
end;


om_error = param_error(1+20:3+20);
T_error = param_error(4+20:6+20);


KK_left = [fc_left(1) fc_left(1)*alpha_c_left cc_left(1);0 fc_left(2) cc_left(2); 0 0 1];
KK_right = [fc_right(1) fc_right(1)*alpha_c_right cc_right(1);0 fc_right(2) cc_right(2); 0 0 1];


R = rodrigues(om);



fprintf(1,'\n\nIntrinsic parameters of left camera:\n\n');
fprintf(1,'Focal Length:          fc_left = [ %3.5f   %3.5f ] � [ %3.5f   %3.5f ]\n',[fc_left;fc_left_error]);
% fprintf(1,'Principal point:       cc_left = [ %3.5f   %3.5f ] � [ %3.5f   %3.5f ]\n',[cc_left;cc_left_error]);
fprintf(1,'Skew:             alpha_c_left = [ %3.5f ] � [ %3.5f  ]   => angle of pixel axes = %3.5f � %3.5f degrees\n',[alpha_c_left;alpha_c_left_error],90 - atan(alpha_c_left)*180/pi,atan(alpha_c_left_error)*180/pi);
fprintf(1,'Distortion:            kc_left = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] � [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc_left;kc_left_error]);   


fprintf(1,'\n\nIntrinsic parameters of right camera:\n\n');
fprintf(1,'Focal Length:          fc_right = [ %3.5f   %3.5f ] � [ %3.5f   %3.5f ]\n',[fc_right;fc_right_error]);
% fprintf(1,'Principal point:       cc_right = [ %3.5f   %3.5f ] � [ %3.5f   %3.5f ]\n',[cc_right;cc_right_error]);
fprintf(1,'Skew:             alpha_c_right = [ %3.5f ] � [ %3.5f  ]   => angle of pixel axes = %3.5f � %3.5f degrees\n',[alpha_c_right;alpha_c_right_error],90 - atan(alpha_c_right)*180/pi,atan(alpha_c_right_error)*180/pi);
fprintf(1,'Distortion:            kc_right = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] � [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc_right;kc_right_error]);   


fprintf(1,'\n\nExtrinsic parameters (position of right camera wrt left camera):\n\n');
fprintf(1,'Rotation vector:             om = [ %3.5f   %3.5f  %3.5f ] � [ %3.5f   %3.5f  %3.5f ]\n',[om;om_error]);
fprintf(1,'Translation vector:           T = [ %3.5f   %3.5f  %3.5f ] � [ %3.5f   %3.5f  %3.5f ]\n',[T;T_error]);


fprintf(1,'\n\nNote: The numerical errors are approximately three times the standard deviations (for reference).\n\n')


fprintf(1,'Saving the stereo calibration results in Calib_Results_stereo.mat\n\n');

string_save = 'save Calib_Results_stereo om R T recompute_intrinsic_right recompute_intrinsic_left calib_name_left format_image_left type_numbering_left image_numbers_left N_slots_left calib_name_right format_image_right type_numbering_right image_numbers_right N_slots_right fc_left cc_left kc_left alpha_c_left KK_left fc_right cc_right kc_right alpha_c_right KK_right active_images dX dY nx ny n_ima active_images_right active_images_left inconsistent_images center_optim_left est_alpha_left est_dist_left est_fc_left est_aspect_ratio_left center_optim_right est_alpha_right est_dist_right est_fc_right est_aspect_ratio_right history param param_error sigma_x om_error T_error fc_left_error cc_left_error kc_left_error alpha_c_left_error fc_right_error cc_right_error kc_right_error alpha_c_right_error';

for kk = 1:n_ima,
    if active_images(kk),
        string_save = [string_save ' X_left'  ' omc_left_' num2str(kk) ' Tc_left_' num2str(kk) ' omc_left_error_' num2str(kk) ' Tc_left_error_' num2str(kk)  ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk)];
    end;
end;
eval(string_save);


% Plot the extrinsic parameters:
ext_calib_stereo;


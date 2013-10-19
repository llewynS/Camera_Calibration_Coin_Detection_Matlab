I=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
for i=1:30
    eval(['TI_' num2str(i) ' =I;']);
    eval(['Tic_' num2str(i) ' =Tc_' num2str(i) ';'])
    eval(['Tic_' num2str(i) '(4,:)= 1;'])
    eval(['TI_' num2str(i) '(:,4) = Tic_' num2str(i) ';'])
    eval(['Ric_' num2str(i) '=Rc_' num2str(i) ';']);
    eval(['Ric_' num2str(i) '(4,:)=0;'])
    eval(['Ric_' num2str(i) '(:,4)=[0 0 0 1];']);
    eval(['RT_' num2str(i) '=TI_' num2str(i) '*Ric_' num2str(i) ';']);
    eval(['extrinsics_transformation_matrices(:,:,' num2str(i) ')=RT_' num2str(i) ';'])
end
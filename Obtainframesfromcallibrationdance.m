%Creates video streams
vid = videoinput('winvideo',1,'RGB24_1280x720');
%Set the frams per trigger to be 1
vid.FramesPerTrigger = 1;
%set the trigger repeat for both devices to 200, inorder to acquire 201
%frames from both the color sensor and the depthsensor.
vid.TriggerRepeat = 200;
%Configure the camera for manual triggering for both sensors.
triggerconfig(vid,'manual');
%Start both video objects.
start(vid);
%Trigger the devices to get the aquired frames and metadata
preview(vid)
for i = 1:200
    % Trigger both objects. 
    trigger(vid)
    % Get the acquired frames and metadata.
    [imgColour, ts_colour, metaData_Colour] = getdata(vid);
    imcolour(:,:,:,i)=imgColour;
end
fprintf('Place Camera in final position...')
pause(1);
fprintf('You have 10 seconds till last photo')
pause(1);
fprintf('You have 9 seconds till last photo')
pause(1);
fprintf('You have 8 seconds till last photo')
pause(1);
fprintf('You have 7 seconds till last photo')
pause(1);
fprintf('You have 6 seconds till last photo')
pause(1);
fprintf('You have 5 seconds till last photo')
pause(1);
fprintf('You have 4 seconds till last photo')
pause(1);
fprintf('You have 3 seconds till last photo')
pause(1);
fprintf('You have 2 seconds till last photo')
pause(1);
fprintf('You have 1 seconds till last photo')
pause(1);
fprintf('Taking photo')

trigger(vid)
% Get the acquired frames and metadata.
[imgColour, ts_colour, metaData_Colour] = getdata(vid);
imcolour(:,:,:,201)=imgColour;
closepreview(vid)
stop(vid)

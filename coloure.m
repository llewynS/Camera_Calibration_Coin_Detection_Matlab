vid=videoinput('winvideo',1,'RGB24_1280x720');
vid.FramesPerTrigger = 1;
vid.TriggerRepeat = 1;
triggerconfig(vid,'manual');
start(vid);
trigger(vid)
[imgColoure, ts_coloure, metaData_Coloure] = getdata(vid);
stop(vid)
rgb=uint8(imgColoure);
imwrite(rgb,strcat('rgb_','coloure','.jpg'));
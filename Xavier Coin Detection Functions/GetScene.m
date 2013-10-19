vid=videoinput('kinect',1);
vid.FramesPerTrigger = 1;
vid.TriggerRepeat = 1;
triggerconfig(vid,'manual');
start(vid);
trigger(vid)
[imgCoins, ts_Coins, metaData_Coins] = getdata(vid);
stop(vid)
rgb=uint8(imgCoins);
imwrite(rgb,strcat('rgb_','scene','.jpg'));
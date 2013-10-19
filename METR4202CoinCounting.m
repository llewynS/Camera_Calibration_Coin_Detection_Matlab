if exist('x_30')
    Callibration=1;
end
if Callibration
    if exist('vid')
        closepreview(vid)
    end
    METR4202CoinCounter;
else
    fprintf('You need to calibrate first please :)')
end
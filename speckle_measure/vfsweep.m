close all
clear all

global param
global vidobj
param = set_parameters;

%% Initiate camera
% vidobj = videoinput('qimaging'); % Firewire 1334 camera
vidobj = videoinput('pmimaq2016b_1_0_34', 1, 'PM-Cam 1920x1460'); % New camera
vidobj.ReturnedColorSpace = 'grayscale';
src = getselectedsource(vidobj);
% param.exp = 0.050;
param.exp = 50;
src.Exposure = param.exp;
vidobj.ROIPosition = [230 0 1460 1460]; % This just crops the video size to a square (to save space on the HDD)
src.AutoContrast = 'OFF';
% src.Offset = 400;
src.PortSpeedGain = 'Port0-Speed0-17.5439MHz-Gain1-16bit';
% src.PP1ENABLED = 'NO';
vidpre = preview(vidobj);
disp('Camera initiated succesfully')
param.bitDepth = 14;
param.maxPixel = 2^param.bitDepth - 1;

% An image object of the same size as the video is used to store and
% display incoming frames.
% param.imageRes = fliplr(vidobj.VideoResolution);
param.imageRes = [1460 1460];

%% Initiate Figure
param.sn=getsnapshot(vidobj);

try
    % Automatically find spot centre and searchsize
    param = autofindcentre(param);
    if param.y + param.searchsize/2 > size(param.sn,1) || param.y - param.searchsize/2 < 1 || param.x + param.searchsize/2 > size(param.sn,2) || param.x - param.searchsize/2 < 1
        aaa
    end
    
    [fig] = make_figure;
    fig.cameraimg.CData=param.sn;
    
catch
    disp('WARNING: Cannot find laser spot automatically, please locate manually.');
    param.searchsize = 200;
    [fig] = make_figure;
    fig.cameraimg.CData=param.sn;
    
    [param.x,param.y]=ginput(1);
    disp([num2str(param.x),' ',num2str(param.y)])
    param.x=round(param.x); param.y=round(param.y);
    disp([num2str(param.x),' ',num2str(param.y)])
end

a=1;
%% Live capture and analysis
% n = 0;
while param.isrunning
    try
        tic
        param.sn=getsnapshot(vidobj);
        if a
            param = autofindcentre(param);
        end
        a=0;
        param = analyseImage(param);
        fig.cameraimg.CData=param.snmarked; % Give image data to figure
        fig.histogram.Data=param.sn3;
        fig.textdisp.String=['SC = ',num2str(round(param.sc,2)),' | Int = ',num2str(round(param.m,0)),];
        
%         addpoints(fig.plotint,n,param.m);
%         addpoints(fig.plotsc,n,param.sc);
%         meansc(n)=param.sc; meanrm(n)=param.rm;
        
        
%         n = n+1;
        
        drawnow;
    catch
        disp('vidobj has been deleted')
        fprintf(param.afg,'OUTPUT1:STAT OFF'); fprintf(param.afg,'OUTPUT2:STAT OFF');
        closepreview
        return
    end
end

function [param] = autofindcentre (param)
%     Got a weird bug that crashes when it can't find the centre
%     automatically (looking for gaussian beam shape) so forcing it to
%     centre for square beam experiments

%     meanx = mean(param.sn,1)';
%     meany = mean(param.sn,2);
%     fx = fit([1:length(meanx)]',meanx,'gauss1');
%     fy = fit([1:length(meany)]',meany,'gauss1');
%     
%     param.x = round(fx.b1);
%     param.y = round(fy.b1);
%     param.fwhmx = round(fx.c1); 
%     param.searchsize = 2*round(param.fwhmx/4);

    param.x = 730; param.y = 730; param.searchsize = 400;
end
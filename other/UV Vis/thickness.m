
% thickness.m
% Calculate thickness of blank slide from UV-VIS data using Fabry-Perot fringes
%
% Input: script prompts for a filename with a dialog box
% Output: Thickness in m.
%
% Author: J.A.J. Fells
% Version: 1.0
% Date: 10/6/16


c=299792458;    % speed of light
n=1.0002772;    % refractive index of air
START=160;      % start data point (discard points before this)
STOP=630;       % end data point (discard data point after this)
PSTART=5;       % start peak number (discard peaks before this)
PSTOP=20;       % end peak nunber (discard peaks before this)

% load data. Note UV-VIS ouputs data in non-standard UTF-16 data format
[fname,path]=uigetfile('*.csv');
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid=fopen([path fname],'r','n','UTF-16');
a=cell2mat(textscan(fid,'%f %f %f','Delimiter',',','Headerlines',2));
fclose(fid);
warning('on','MATLAB:iofun:UnsupportedEncoding');

lambda=a(START:STOP,1)*1e-9;
tr=10.^(-a(START:STOP,2));
y=10.^(-movav(a(START:STOP,2)));
f=(ones(size(lambda))*c)./(lambda*n);
f=flip(f);
tr=flip(tr);
y=flip(y);
fstep=(f(2)-f(1))/30;
f2=[f(1):fstep:f(end)];
y2=spline(f,y,f2);      % interpolate data to find actual peak
[peaks,locs]=findpeaks(y2,'MinPeakProminence',0.1);

px=[0:length(locs)-1]';
py=f2(locs)';
py=py-py(1);
b1=px\py;
px2=[0:0.1:max(px)];
py2=px2*b1;
f1=figure(1);
%plot(f/1e12,y,f2/1e12,y2,f2(locs)/1e12,y2(locs),'xk','MarkerSize',18)
plot(f/1e12,y,f2/1e12,y2,f2(locs)/1e12,y2(locs),'xk')
% axis([360,860,0.4,0.9])
xlabel('Frequency, THz')
ylabel('Transmission A.U.')
%f1.Children.FontSize=18;
f2=figure(2);
plot(px,py/1e12,'x',px2,py2/1e12)
xlabel('Peak Number')
ylabel('\Deltaf, THz')
%f2.Children.FontSize=18;
d=c/(2*b1)  %output thickess



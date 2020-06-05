% Calculate the thicknes of your cell using interference fringes. Run this
% script, then select the .csv file from the UV Vis that you wish to test.
% Code outputs a graph of transmission against lambda (with detected peaks
% shown) and plots DeltaN against lambda^-1 (from which the thickness is
% calculated). You are then told how many peaks there are in total and
% asked to select the first and last peak form which to make the
% calculation. Select only the peaks that reflect consecutive peaks from
% the transmission graph, thus forming a good straight line on DeltaN
% graph. Thickness measurement will be accurate when peaks are correctly
% chosen. Thickness is output in µm, make a note of it!

START=160;      % start data point (discard points before this)
STOP=630;       % end data point (discard data point after this)

% load data. Note UV-VIS ouputs data in non-standard UTF-16 data format
[fname,path]=uigetfile('*.csv');
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid=fopen([path fname],'r','n','UTF-16');
a=cell2mat(textscan(fid,'%f %f %f','Delimiter',',','Headerlines',2));
fclose(fid);
warning('on','MATLAB:iofun:UnsupportedEncoding');

% Select points in range selected above
lambda=a(START:STOP,1);
tr=100*10.^(-a(START:STOP,2));

tr2 = movavg(tr,'simple',2); % Creating moving average line to get smooth peaks
[pks, locs] = findpeaks(tr2,'MinPeakProminence',0.1); % Find peaks with at least 0.5 prominence
lpks = lambda(locs);

plot(lambda, tr, '-r')
hold on
plot(lpks, pks,'o','Color','w','MarkerFaceColor', 'b')
plot(lambda,tr2,'g')
hold off

xlabel 'Wavelength (nm)'
ylabel 'Transmission (%)'
title 'Transmission spectrum of empty 20\mum cell'
ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
set(gcf, 'Position', get(0, 'Screensize'));

disp(['There are ',num2str(length(pks)),' peaks selected. Select a minimum and maximum wavelength for analysis to occur over and hit ENTER'])
[x,y]=ginput;
A = (lpks < x(2) & lpks > x(1));

close all

pks=pks(A);
lpks=lpks(A);

Ypks=1e3./lpks;
n=[0:length(pks)-1]';
f = fit( n, Ypks, 'a*x + b');

figure
plot([0,n(end)],[f.b,f.a*n(end)+f.b],'-','Color','r')
hold on
plot(n,Ypks,'o','Color','w','MarkerFaceColor', 'b')
hold off
xlabel '\DeltaN'
ylabel 'Wavelength^{-1} (\lambda^{-1} x10^6)'

ax=gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;

t = round(-1/(2*f.a),2) % Thickness in um
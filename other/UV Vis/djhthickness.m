% See OneNote>Lab Book>Diary>180105: cell thickness maths for derivation of
% maths. This code simply takes CSV file and turns it into a transmission
% against wavelength graph with the peaks highlighted
clear all
close all
set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

START=160;      % start data point (discard points before this)
STOP=630;       % end data point (discard data point after this)

% load data. Note UV-VIS ouputs data in non-standard UTF-16 data format
[fname,path]=uigetfile('*.csv');
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid=fopen([path fname],'r','n','UTF-16');
a=cell2mat(textscan(fid,'%f %f %f','Delimiter',',','Headerlines',2));
fclose(fid);
warning('on','MATLAB:iofun:UnsupportedEncoding');

lambda=a(START:STOP,1);
tr=100*10.^(-a(START:STOP,2));

tr2 = movav(tr);
[pks, locs] = findpeaks(tr2,'MinPeakProminence',1);
lpks = lambda(locs);
plot(lambda, tr, '-r')
hold on
plot(lpks, pks,'o','Color','w','MarkerFaceColor', 'b')
hold off


%{
s=30;
[pks, locs] = findpeaks(tr);
locs = locs(length(locs)-s+1:end);
pks = pks(length(pks)-s+1:end);
lpks = lambda(locs);
plot(lambda, tr, '-r')
hold on
plot(lpks, pks,'o','Color','w','MarkerFaceColor', 'b')
hold off
%}

xlabel 'Wavelength (nm)'
ylabel 'Transmission (%)'
title 'Transmission spectrum of empty 20\mum cell'

Ypks=1e3./lpks;
n=[0:length(pks)-1]';
f = fit( n, Ypks, 'a*x + b');

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

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

t = -1/(2*f.a) % Thickness in um

disp(['There are ',num2str(length(pks)),' peaks selected.'])
pk1 = input('Input first peak');
pk2 = input('Input last peak');
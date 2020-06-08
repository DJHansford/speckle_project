% Make a FT plot with wavelengths in nm across x axis

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

graph = 'n_o = 1.525, n_e = 1.675';

% x=exp;
x_name = 'Wavelength';
x_unit = 'nm';
% x_hi = 2;

% y=sc;
y_name = 'Intensity';
y_unit = 'AU';
% y_hi = 1;

% create square wave with period of 20um
% y=abs(round(sin(linspace(0,10*pi,4096))/2 + 0.5));
% y_fft=abs(fft(y));
figure
subplot(3,1,1)
plot(x_f_abs(1:500,1),'r')
xticks(100:100:500)
xticklabels(round(20e3./((100:100:500)*0.1),1)) % 20*1000 is 20um in nm, 0.1 = 50(number of peaks for 20um square wave)/500(range of FT plot)
% title(graph)
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

subplot(3,1,2)
plot(x_f_abs(1:500,2),'r')
xticks(100:100:500)
xticklabels(round(20e3./((100:100:500)*0.1),1)) % 20*1000 is 20um in nm, 0.1 = 50(number of peaks for 20um square wave)/500(range of FT plot)
% title(graph)
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

subplot(3,1,3)
plot(x_f_abs(1:500,3),'r')
xticks(100:100:500)
xticklabels(round(20e3./((100:100:500)*0.1),1)) % 20*1000 is 20um in nm, 0.1 = 50(number of peaks for 20um square wave)/500(range of FT plot)
% title(graph)
xlabel([x_name,' (',x_unit,')'])
ylabel([y_name,' (',y_unit,')'])

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

% saveas(gcf,[graph,'.svg'])
% saveas(gcf,[graph,'.fig'])
% save(graph)
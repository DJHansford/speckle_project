% E7 values:
no=1.517473
ne=1.7349

% [filename,path]=uigetfile('*.csv');
% uvvis=readuvvis([path filename]);
% [~,fname,fext] = fileparts(filename);
% 
% lambda=uvvis(210:809,1)*1e-9;
% tx=100*10.^-uvvis(210:809,2); %transmission %

gtx=movav(movav(gradient(tx,lambda)));

[~,peak]=max(gtx);
lambdal=lambda(peak)
pitch=(lambdal/ne)

i=figure;
plot(lambda/1e-9,tx,'g',lambdal/1e-9,tx(peak),'bx')
xlabel('Wavelength, nm')
ylabel('Transmission, %');
grid
f.Children.FontSize=18;
% saveas(f,[path,fname,' PBGc=',num2str(round(meanlambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm.emf'])
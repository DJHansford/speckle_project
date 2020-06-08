% E7 values:
no=1.517473;
ne=1.7349;
nmean=(ne+no)/2;

[filename,path]=uigetfile('*.csv');
uvvis=readuvvis([path filename]);
[~,fname,fext] = fileparts(filename);

lambda=uvvis(210:899,1)*1e-9;
tx=100*10.^-uvvis(210:899,2); %transmission %


pitchtype='PBGl';
gtx=movav(movav(gradient(movav(tx),lambda)));
[~,peakmax]=max(gtx);
[~,peakmin]=min(gtx);
lambdal=lambda(peakmax)
lambdas=lambda(peakmin)
peakmean=round(((peakmax+peakmin)/2),0);
lambdamean=lambda(peakmean)
pitch=(lambdamean/nmean)


f=figure;
plot(lambda/1e-9,tx,'g',lambdamean/1e-9,tx(peakmean),'bx')
xlabel('Wavelength, nm')
ylabel('Transmission, %');
grid
f.Children.FontSize=18;
% saveas(f,[path,fname,' ',pitchtype,'=',num2str(round(marklambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm.emf'])

no=1.517473
ne=1.7349

[filename,path]=uigetfile('*.csv');
uvvis=readuvvis([path filename]);
[~,fname,fext] = fileparts(filename);

lambda=uvvis(311:900,1)*1e-9;
tx=uvvis(311:900,2);
gtx=movav(gradient(tx,lambda));
[~,pklocs1]=findpeaks(gtx,'MinPeakProminence',max(gtx)/5);
pklocs1=pklocs1(gtx(pklocs1)>0);
[~,maxpkloc1]=max(tx(pklocs1));
lambda1=lambda(pklocs1(maxpkloc1));
tx1=tx(pklocs1(maxpkloc1));
[~,pklocs2]=findpeaks(-gtx,'MinPeakProminence',max(gtx)/5);
pklocs2=pklocs2(gtx(pklocs2)<0);
[~,maxpkloc2]=max(tx(pklocs2));
lambda2=lambda(pklocs2(maxpkloc2));
tx2=tx(pklocs2(maxpkloc2));

f=figure;
plot(lambda/1e-9,tx,'g',lambda1/1e-9,tx1,'bx',lambda2/1e-9,tx2,'rx')
xlabel('Wavelength, nm')
ylabel('Reflectance, a.u.');
grid
f.Children.FontSize=18;
% saveas(f,[path,fname,'.emf'])

%plot(lambda,gtx,lambda(pklocs2),gtx(pklocs2),'x')

lambdas=lambda1
lambdal=lambda2
%lambdas=635.6503e-9
%lambdal=730.6324e-9

%lambdas=707.9711e-9
%lambdal=812.3974e-9


dn=ne-no
pl=lambdal/ne
ps=lambdas/no
meanpitch=mean([pl ps])
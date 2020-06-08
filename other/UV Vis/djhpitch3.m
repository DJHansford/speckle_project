% E7 values:
no=1.517473
ne=1.7349

[filename,path]=uigetfile('*.csv');
uvvis=readuvvis([path filename]);
[~,fname,fext] = fileparts(filename);

type = input('Enter PBG type (l: long only, b: both, s:short only): ','s');

lambda=uvvis(210:910,1)*1e-9;
tx=100*10.^-uvvis(210:910,2); %transmission %

if type=='b'
    pitchtype='PBGc';
    n=100;
    tophat=zeros(n,1);
    tophat(n/10:9*n/10)=100;
    invtx=100.-tx;
    norminvtx=invtx-min(invtx);
    norminvtx=norminvtx/max(norminvtx);
    tconv=conv(norminvtx,tophat);
    [~,peak]=max(tconv);
    peak=peak-(n/2);
    marklambda=lambda(peak)
    nmean=(ne+no)/2;
    pitch=(marklambda/nmean)
else if type=='l'
        pitchtype='PBGl';
        gtx=movav(movav(gradient(tx,lambda)));
        [~,peak]=max(gtx);
        marklambda=lambda(peak)
        pitch=(marklambda/ne)
    end
end



f=figure;
plot(lambda/1e-9,tx,'g',marklambda/1e-9,tx(peak),'bx')
xlabel('Wavelength, nm')
ylabel('Transmission, %');
grid
f.Children.FontSize=18;
% saveas(f,[path,fname,' ',pitchtype,'=',num2str(round(marklambda*1e9,0)),'nm pitch=',num2str(round(pitch*1e9,0)),'nm.emf'])
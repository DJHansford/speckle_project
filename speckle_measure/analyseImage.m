function[param] = analyseImage(param)

% Remove dark pixel value
param.sn=param.sn-401; % This is specific to the camera we are using. If you cover the camera sensor, what is the average intensity value it records? We should subtract this to get a true value.

param.snmarked=param.sn;
% Mark search square for analysis
param.snmarked(param.y-param.searchsize/2-3:param.y-param.searchsize/2-1,param.x-param.searchsize/2-3:param.x+param.searchsize/2+3)=param.maxPixel;
param.snmarked(param.y+param.searchsize/2+1:param.y+param.searchsize/2+3,param.x-param.searchsize/2-3:param.x+param.searchsize/2+3)=param.maxPixel;
param.snmarked(param.y-param.searchsize/2-3:param.y+param.searchsize/2+3,param.x-param.searchsize/2-3:param.x-param.searchsize/2-1)=param.maxPixel;
param.snmarked(param.y-param.searchsize/2-3:param.y+param.searchsize/2+3,param.x+param.searchsize/2+1:param.x+param.searchsize/2+3)=param.maxPixel;
% Crop to search square and resize
param.sn2=double(param.sn(param.y-param.searchsize/2:param.y+param.searchsize/2-1,param.x-param.searchsize/2:param.x+param.searchsize/2-1,1));
param.sn3=reshape(param.sn2,param.searchsize^2,1);
param.maxcount=sum(param.sn2(:) == param.maxPixel);
% Analyse search square
param.m=mean(param.sn3);
param.s=std(param.sn3);
param.sc=param.s/param.m;
param.rm=param.m*10^param.ndf;
param.tran=param.rm/param.HeNerm;
param.spre=1-(param.sc/param.HeNesc);
end
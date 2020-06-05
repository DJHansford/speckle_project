% Use this to make a transmission colourmap. param struct must be in the
% workspace already. Use savetwo to save the figure.

param.trans2D = cell2mat(reshape(param.results(:,16),length(param.v.range),length(param.f.range)));
plotcmap(param.trans2D,param.f.range,param.v.range)
set(gca,'CLim',[0 1])
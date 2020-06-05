function plotcmap(data,xrange,yrange,cap)
%PLOTCMAP(data,xrange,yrange,cap)
%  data:   2D array of speckle contrast values (param.results2D)
%  xrange: Frequency values used (param.f.range)
%  yrange: Field values used (param.v.range)
%  cap:    Caption (optional)
% 
% This will turn your quick and peak tests into colourmaps. The Field axis
% will only label every other field value to avoid over-cramping the axis.

% Create figure
figure('OuterPosition',[300,300,450,420]);

% Create image
imagesc(data,[0 0.625]);
colormap(jet(64));

% Set x and y axes labels
xlabel('Frequency (Hz)','FontWeight','bold','FontName','Cambria');
set(gca,'XTick',1:length(xrange),'XTickLabel',xrange);

ylabel('Field Amplitude (V/µm)','FontWeight','bold','FontName','Cambria');
set(gca,'YTick',1:2:length(yrange),'YTickLabel',yrange(1:2:end));

set(gca,'CLim',[0 0.625],'FontName','Cambria','FontSize',18,'LineWidth',1);

% Create colorbar
colorbar(gca);

if nargin == 4
    annotation(gcf,'textbox',[0.18 0.8 0.6 0.1],'Color',[1 1 1],'String',{cap},'EdgeColor','none','FontSize',18,'FontName','Cambria');
end

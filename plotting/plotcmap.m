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
xn = 1; % How many field values do you want to skip when plotting? (Avoid overcramping)
set(gca,'XTick',1:xn:length(xrange),'XTickLabel',xrange(1:xn:end));

ylabel('Field Amplitude (V/µm)','FontWeight','bold','FontName','Cambria');
yn = 2; % How many field values do you want to skip when plotting? (Avoid overcramping)
set(gca,'YTick',1:yn:length(yrange),'YTickLabel',yrange(1:yn:end));

set(gca,'CLim',[0 0.625],'FontName','Cambria','FontSize',18,'LineWidth',1);

% Create colorbar
colorbar(gca);

if nargin == 4
    annotation(gcf,'textbox',[0.18 0.8 0.6 0.1],'Color',[1 1 1],'String',{cap},'EdgeColor','none','FontSize',18,'FontName','Cambria');
end

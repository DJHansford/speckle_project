% Resize plot size, font style and weight for plots to use in publications
% Use 'savetwo' function to save as .fig and .png if you're happy with the
% result!

% Makes a plot that is approax 8.5cm x 11.5cm
set(gcf,'OuterPosition',[300,300,450,420]);

h = gca;

box(h,'on');

% Set the remaining axes properties
set(h,'FontName','Cambria','FontSize',18,'LineWidth',1,'FontWeight','normal');
h.YLabel.FontWeight = 'bold';
h.XLabel.FontWeight = 'bold';

% This ensures that the printed version is the same size as the onscreen version
set(gcf, 'PaperPositionMode', 'auto');
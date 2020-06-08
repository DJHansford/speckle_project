function plot_dbl_y(X1, Y1, Y2)
%PLOT_DBL_Y(X1, Y1, Y2)
%  X1:  vector of x data
%  Y1:  vector of y data
%  Y2:  vector of y data

% Create figure
figure1 = figure('OuterPosition',[1250 403 464 429]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Activate the left side of the axes
yyaxis(axes1,'left');
% Create plot
plot(X1,Y1,'MarkerSize',18,'Marker','.','LineWidth',2,'Color',[1 0 0]);

% Create ylabel
ylabel('Speckle Contrast (C)','FontWeight','bold','FontName','Cambria',...
    'Color',[1 0 0]);

ylim(axes1,[0 0.35]);

% Set the remaining axes properties
set(axes1,'YColor',[1 0 0]);

% Activate the right side of the axes
yyaxis(axes1,'right');
% Create plot
plot(X1,Y2,'MarkerSize',18,'Marker','.','LineWidth',2,'Color',[0 1 0]);

% Create ylabel
ylabel('Transmission (%)','FontWeight','bold','FontName','Cambria',...
    'Color',[0 1 0]);
ylim(axes1,[0 20]);

% Set the remaining axes properties
set(axes1,'YColor',[0 1 0]);
% Create xlabel
xlabel('Concentration of CTAB (wt.%)','FontWeight','bold',...
    'FontName','Cambria');

xlim(axes1,[0 1]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',18,'LineWidth',2);

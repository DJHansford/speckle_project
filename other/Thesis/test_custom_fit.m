set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

%% Fit: 'untitled fit 1'.
xData = x;
yData = y;
% [xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'a*x^-0.5+c', 'independent', 'x', 'dependent', 'y' );
excludedPoints = excludedata( xData, yData, 'Indices', 1 );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.911601402589103 0.546405299751214];
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
plot(fitresult)
hold on
plot(xData,yData,'o','Color','w','MarkerFaceColor', 'b')
% plot( fitresult, xData, yData, excludedPoints );
% Label axes
xlabel 'Integration Time (s)'
ylabel 'Speckle Contrast (C)'
grid off
xlim([0 2])
ylim([0 1])
legend off
title 'Speckle dependence on integration time'

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

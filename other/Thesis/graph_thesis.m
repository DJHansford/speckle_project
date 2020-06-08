% Make plots of sc, trans, V/um, freq against pitch
% Needs 'data', 'data_head', 'data_headings'
% data: 'conc','pitch','field','freq','sc','sc_range','trans','trans_range'
% Make this using 'read_steadystate.m' in a steady state 5mins folder
% Works out 'data_limits'
% Just change yn to make the 4 graphs
% clear all
% load('All temp data.mat');
% hold on
xn = 3;
yn = 2; % 1:Conc 3:Field 4:Freq 5:SC 7:Trans 9:Thresh V

% meas = 3:4; % which runs could be measured with the UV-Vis?

x=data(:,xn);
y=data(:,yn);
% y=data(:,yn).*(100.-data(:,yn+2))/100; % For STC graph
% err=data(:,8);

% x=x(data(:,9) == 1);
% y=y(data(:,9) == 1);
% err=err(data(:,9) == 1);

% f = fit(x,y, 'power2');
% f1 = fit(x(data(:,9) == 1),y(data(:,9) == 1),'a*x^b + c');
% f2 = fit(x(data(:,9) == 2),y(data(:,9) == 2),'a*x^b + c');
% f3 = fit(x(data(:,9) == 3),y(data(:,9) == 3),'a*x^b + c');
% f1 = fit(x,y,'a*x^-1');
% f1 = fit(x(data(:,9) == 1),y(data(:,9) == 1),'a*x^-0.5');
% f2 = fit(x(data(:,9) == 2),y(data(:,9) == 2),'a*x^-0.5');
% f3 = fit(x(data(:,9) == 3),y(data(:,9) == 3),'a*x^-0.5');
% f4 = fit(x(data(:,9) == 4),y(data(:,9) == 4),'a*x^-0.5');
% f1 = fit(x(data(:,9) == 1),y(data(:,9) == 1),'a*x^-1');
% f2 = fit(x(data(:,9) == 2),y(data(:,9) == 2),'a*x^-1');
% f1 = fit(x(data(:,9) == 1),y(data(:,9) == 1),'gauss1');
% f2 = fit(x(data(:,9) == 2),y(data(:,9) == 2),'gauss1');
% f3 = fit(x(data(:,9) == 3),y(data(:,9) == 3),'gauss1');

data_head={'conc','pitch','field','freq','sc','sc_range','trans','tr_range','','thres'};
% data_head={'pitch','temp','field','freq','sc','sc_range','trans','tr_range'};
data_headings = {'Concentration of chiral dopant (wt.%)','Pitch (nm)','Field amplitude (V/\mum)','Frequency (Hz)','Speckle contrast (C)','Speckle contrast range (C)','Transmission (%)','Transmission range (%)','','Threshold Voltage (V/\mum)'};
% data_headings = {'Pitch (nm)','Temperature (°C)','Field amplitude (V/\mum)','Frequency (Hz)','Speckle contrast (C)','Speckle contrast range (C)','Transmission (%)','Transmission range (%)'};
data_limits={[0 ceil(max(data(:,1)))],[0 3000],[0 ceil(max(data(:,3)/10))*10],[0 ceil(max(data(:,4)/20))*20],[0 1],[0 1],[0 100],[],[],[0 10]};
% data_limits={[0 ceil(max(data(:,1)))],[15 120],[0 ceil(max(data(:,3)/10))*10],[0 ceil(max(data(:,4)/20))*20],[0 1],[0 1],[0 100]};
graph = [data_head{yn},' ',data_head{xn},' 3'];

y_name = data_headings{yn};

switch yn
    case 1
        xn=1; yn=2;
        x=data(:,xn);
        y=1./(data(:,yn)/1000);
        f = fit(x,y,'a*x');
        
        near = 5; % Round xhi to nearest...
%         xlo = floor(min(data(:,1)/near))*near;
        xhi = ceil(max(data(:,1)/near))*near;
%         ylo=xlo*f.a+f.b;
        yhi=xhi*f.a+f.b;
        figure
        plot([0,xhi],[0,yhi],'-','Color','r')
        hold on
        plot(x(meas),y(meas),'o','Color','w','MarkerFaceColor', 'b')
        plot(x(~ismember(x,x(meas))),y(~ismember(x,x(meas))),'o','Color','w','MarkerFaceColor', 'g')
        hold off
%         xlim([0 xhi])
%         ylim([0 yhi])
        y_name = 'Pitch^{-1} (\mum^{-1})';
    case {3,4,5,7,10}
        figure
%         plot(f)
        
        PlotOpts.Marker='o';
        PlotOpts.MarkerEdgeColor='w';
        PlotOpts.LineStyle='-';
        PlotOpts.MarkerSize=5;
        
%         p1 = plot(x(data(:,9) == 1),y(data(:,9) == 1),PlotOpts,'MarkerFaceColor','r');
        p1 = plot(x(data(:,9) == 1),y(data(:,9) == 1),'xr','MarkerFaceColor', 'r', 'MarkerSize',6);
        hold on
%         fx = linspace(300,2100,1000);
%         plot(fx,f1.a./fx + f1.b,'--r')
%         plot(fx,f1.a./fx,'--r')
%         p2 = plot(x(data(:,9) == 2),y(data(:,9) == 2),'xg','MarkerFaceColor', 'r', 'MarkerSize',6);
%         plot(fx,f2.a./fx + f2.b,'--b')
%         plot(fx,f2.a./fx,'--b')
%         p3 = plot(x(data(:,9) == 3),y(data(:,9) == 3),'xb','MarkerFaceColor', 'b', 'MarkerSize',6);
%         p4 = plot(x(data(:,9) == 4),y(data(:,9) == 4),'xc','MarkerFaceColor', 'b', 'MarkerSize',6);
%         plot(x(data(:,9) == 5),y(data(:,9) == 5),'xr','MarkerSize',7);
%         plot(x(data(:,9) == 6),y(data(:,9) == 6),'xb','MarkerSize',7);
%         plot(x(data(:,9) == 5),y(data(:,9) == 5),'ok','MarkerSize',7);
%         plot(x(data(:,9) == 6),y(data(:,9) == 6),'ok','MarkerSize',7);
%         plot(x(2:3),y(2:3),'--r');
%         plot(x(5:6),y(5:6),'--b');

%         x1=linspace(min(x),max(x),1000);
%         p5 = plot(x1,f1.a*x1.^-0.5,'--k')
        plot(f1,'--k')
%         plot(x1,f1.a1*exp(-((x1-f1.b1)/f1.c1).^2),'--r')
%         x2=linspace(min(x(data(:,9) == 2)),max(x(data(:,9) == 2)),1000);
%         plot(x2,f2.a*x2.^f2.b + f2.c,'--b')
%         plot(x2,f2.a1*exp(-((x2-f2.b1)/f2.c1).^2),'--b')
%         x3=linspace(min(x(data(:,9) == 3)),max(x(data(:,9) == 3)),1000);
%         plot(x3,f3.a*x3.^f3.b + f3.c,'--g')
%         plot(x3,f3.a1*exp(-((x3-f3.b1)/f3.c1).^2),'--g')

%         plot(f1,'r')
%         plot(f2,'b')
%         plot(f3,'g')

%         plot(x,y,'o','Color','b','MarkerFaceColor', 'b')
%         errorbar(x,y,5*ones(1,length(y)),'o','Color','b','MarkerSize',3,'MarkerFaceColor', 'b')
        
%         e1 = errorbar(x(data(:,9) == 1),y(data(:,9) == 1),err(data(:,9) == 1),'o','Color','r','MarkerSize',3,'MarkerFaceColor', 'r');
%         e2 = errorbar(x(data(:,9) == 2),y(data(:,9) == 2),err(data(:,9) == 2),'o','Color','b','MarkerSize',3,'MarkerFaceColor', 'b');
%         e3 = errorbar(x(data(:,9) == 3),y(data(:,9) == 3),err(data(:,9) == 3),'o','Color','g','MarkerSize',3,'MarkerFaceColor', 'g');

%         e1 = errorbar(x(data(:,9) == 1),y(data(:,9) == 1),0.5*ones(1,length(y(data(:,9) == 1))),'o','Color','r','MarkerSize',3,'MarkerFaceColor', 'r');
%         e2 = errorbar(x(data(:,9) == 2),y(data(:,9) == 2),0.5*ones(1,length(y(data(:,9) == 2))),'o','Color','b','MarkerSize',3,'MarkerFaceColor', 'b');
%         e3 = errorbar(x(data(:,9) == 3),y(data(:,9) == 3),0.5*ones(1,length(y(data(:,9) == 3))),'o','Color','g','MarkerSize',3,'MarkerFaceColor', 'g');
%         e4 = errorbar(x(data(:,9) == 4),y(data(:,9) == 4),0.2*ones(1,length(y(data(:,9) == 4))),'o','Color','m','MarkerSize',3,'MarkerFaceColor', 'm');
        hold off
        xlim(data_limits{xn})
        ylim(data_limits{yn})
%         legend('E7 + BDH1281','E7 + R811','BL006 + R811','BL006 + R5011')
%         legend([p1 p2 p3 p4],{'Base mix','Base + 5.3 wt.% BL006','Base + 9.5 wt.% BL006','Base + 14.5 wt.% BL006'})
%         legend('5CB + BDH1281','E7 + BDH1281','BL006 + R5011')
        legend([p1 p2 p3 p4],{'E7 + BDH1281','E7 + R811','BL006 + R811','BL006 + R5011'})
        legend 'Location' 'NorthEast'
%         legend off
    case {0}
        % Individual graphs with shaded error areas
        lo = y - err;
        hi = y + err;
        
        figure
        hl = plot(x(data(:,9) == 1),y(data(:,9) == 1),'-o','Color','r','MarkerFaceColor', 'r', 'MarkerSize', 4);
        hold on;
%         hp = patch([x; x(end:-1:1); x(1)], [lo; hi(end:-1:1); lo(1)], 'b');
%         hl = plot(x,y,'o','Color','w','MarkerFaceColor', 'b', 'MarkerSize', 4);
        h2 = plot(x(data(:,9) == 2),y(data(:,9) == 2),'-o','Color','b','MarkerFaceColor', 'b', 'MarkerSize', 4);
        hold off
%         legend('off')
        legend([hl h2],{'BL006 + R811','BL006 + R811 + CTAB'})
%         set(hp, 'facecolor', [0.8 0.8 1], 'edgecolor', 'b');
        xlim(data_limits{xn})
        ylim(data_limits{yn})
    case {0}
        % Group graph with joined points and no error
        figure
        plot(x(data(:,9) == 1),y(data(:,9) == 1),'x-r')
        hold on
        plot(x(data(:,9) == 2),y(data(:,9) == 2),'x-b')
        plot(x(data(:,9) == 3),y(data(:,9) == 3),'x-g')
        plot(x(data(:,9) == 4),y(data(:,9) == 4),'x-m')
        hold off
        legend('E7 + BDH1281','E7 + R811','BL006 + R811','BL006 + R5011')
        xlim(data_limits{xn})
        ylim(data_limits{yn})
end

x_name = data_headings{xn};

% ylim([0 10])
% xlim([300 2100])

xlabel(x_name)
ylabel(y_name)

ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

export_fig([graph,'.png'], '-transparent', '-r600')
saveas(gcf,[graph,'.fig'])
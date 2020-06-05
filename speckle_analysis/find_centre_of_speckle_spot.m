% Point at a directory which has a set of images taken under the same
% conditions. The name of the folder will be the title on the graph. The
% code finds the laser spot by matching it to a gaussian curve in the x and
% y dimension. The FWHM of the x gaussian is used to measure the size of
% the spot. It then tests each image with a range of searchboxes from 0 to
% 2 times the FWHM in size . It then compares that range of C values across all
% images and plots the average C values and the range of C values.

% THE POINT IS TO SEE WHAT SIZE OF SEARCHBOX IS BEST! LOOKS LIKE 0.5*FWHM
% IS BEST

% close all
clear all

path = strsplit(pwd, '\');
name = path{end};

files = dir('*.jpg');
filenames = {files.name};

for k = 1:length(filenames)
    
    sn = imread(filenames{k});
    
    % sn=imread('03 13.6Vµm 75Hz.jpg');
    %Dimension 1 is centrex
    meanx = mean(sn,1)';
    meany = mean(sn,2);
    fx = fit([1:length(meanx)]',meanx,'gauss1');
    fy = fit([1:length(meany)]',meany,'gauss1');
    
    centrex = round(fx.b1);
    centrey = round(fy.b1);
    % fwhmx(k) = round(fx.c1*1.665);
    fwhmx(k) = round(fx.c1);
    search_suggest(k) = 2*round(fwhmx(k)/4); %round to nearest even number
    
    % sn(centrey,:)=255;
    % sn(:,centrex)=255;
    % figure
    % imshow(sn);
    
    % searchsizes = search_suggest;
    searchsizes = 2*round(linspace(0.01,2,100)'.*fwhmx(k)/2);
    for i = 1:length(searchsizes)
        searchsize = searchsizes(i);
        
        if searchsize > min([centrex, length(sn)-centrex])
            break
        end
        
        % Mark original image with searchsize
        snmarked=sn;
        snmarked(centrey-searchsize/2-3:centrey-searchsize/2-1,centrex-searchsize/2-3:centrex+searchsize/2+3)=255;
        snmarked(centrey+searchsize/2+1:centrey+searchsize/2+3,centrex-searchsize/2-3:centrex+searchsize/2+3)=255;
        snmarked(centrey-searchsize/2-3:centrey+searchsize/2+3,centrex-searchsize/2-3:centrex-searchsize/2-1)=255;
        snmarked(centrey-searchsize/2-3:centrey+searchsize/2+3,centrex+searchsize/2+1:centrex+searchsize/2+3)=255;
%         figure
%         imshow(snmarked);
        
        % Crop and reshape to suggested searchsize
        sn2=double(sn(centrey-searchsize/2:centrey+searchsize/2-1,centrex-searchsize/2:centrex+searchsize/2-1,1));
        sn3=reshape(sn2,searchsize^2,1);
        maxcount(i)=sum(sn2(:) == 255);
        
        % Speckle Contrast
        sc(i,k)=std(sn3)/mean(sn3);
        
    end
end

meansc = mean(sc,2);
error = max(sc,[],2)-min(sc,[],2);
meanfwhmx = mean(fwhmx);

set(0,'DefaultAxesFontName', 'Calibri light')
set(0,'DefaultTextFontName', 'Calibri light')

figure
x_C = searchsizes(1:length(sc))/meanfwhmx;
y_C = meansc;
plot(x_C,y_C,'o','Color','w','MarkerFaceColor', 'b','MarkerSize',4);
hold on
f_C = fit(x_C,y_C,'power2');
plot(f_C)

% boundedline(x,y,e, '-rx')

legend('off')
title([name,': Average speckle contrast'])
xlabel('Size of search box normalised by c')
xlim([0 2])
ylim([0,1]);
ylabel('Speckle Contrast')
ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

% saveas(gcf,'Box size test C.svg')
% saveas(gcf,'Box size test C.fig')

figure
x_err = searchsizes(1:length(sc))/meanfwhmx;
y_err = error;
plot(x_err,y_err,'o','Color','w','MarkerFaceColor', 'b','MarkerSize',4);
hold on
f_err = fit(x_err,y_err,'power2');
plot(f_err)
legend('off')
title([name,': Range of C values'])
xlabel('Size of search box normalised by c')
xlim([0 2])
ylabel('Range of Speckle Contrast')
ax=gca;
ax.Title.FontSize = 14;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;

% saveas(gcf,'Box size test Error.svg')
% saveas(gcf,'Box size test Error.fig')

% disp(['(',num2str(centrex),',',num2str(centrey),') | searchsize = ',num2str(searchsize),' | C = ',num2str(sc)])
% figure
% plot(searchsizes,sc)
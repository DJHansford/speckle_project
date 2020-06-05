% Create a param.mat file for old set of data that only has the Excel
% 'Data' sheet.

clear all

[~, ~, data1] = xlsread('Data.xlsx','Sheet1');
[~, ~, data2] = xlsread('Data.xlsx','Sheet2');
[x1,y1]=size(data1); [x2,y2]=size(data2);
param.titles=data1(1,:);
param.results=data1(2:x1,:);
param.results2D=cell2mat(data2(2:x2,2:y2));
param.v.range=cell2mat(data2(2:x2,1))';
param.f.range=cell2mat(data2(1,2:y2));
param.cellt=cell2mat(data1(2,1));
param.ndf=cell2mat(data1(2,8));

loc=pwd;
a = regexp(loc,'\');
param.testname=loc(a(length(a))+13:length(loc));

save('param.mat','param')
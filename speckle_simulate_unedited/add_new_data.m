clear all
data_name = '180125_0132 eighth_pi_max_change_screen ALL.mat';
loc = 'C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\';

load([loc,'180127_1144 eighth_pi_max_change_screen.mat'],'data');
data1 = data;
load([loc,data_name]);

data = cat(1,data,data1);
save([loc,data_name],'data','screen')
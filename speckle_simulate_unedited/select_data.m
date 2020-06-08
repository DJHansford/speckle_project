function[data_out]=select_data(data, vals, col)
% This function selects the rows from 'data' (output from Steve simulation)
% that match the  parameters in 'vals' - an 11-long vector with NaN wherever
% a value is allowed to vary. 'Col' is the column to re-order by

% Example call:
% vals = [NaN, 20, NaN, 10, 20, 632.8, 1.5, 1.7];

ind1 = data(:,1) == vals(1);
ind2 = data(:,2) == vals(2);
ind3 = data(:,3) == vals(3);
ind4 = data(:,4) == vals(4);
ind5 = data(:,5) == vals(5);
ind6 = data(:,6) == vals(6);
ind7 = data(:,7) == vals(7);
ind8 = data(:,8) == vals(8);
ind9 = data(:,9) == vals(9);
ind10 = data(:,10) == vals(10);
ind11 = data(:,11) == vals(11);
indt = ind1+ind2+ind3+ind4+ind5+ind6+ind7+ind8+ind9+ind10+ind11;
ind = indt == max(indt);
data_1 = data(ind,:);
data_out = sortrows(data_1,col);
end
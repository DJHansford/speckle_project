load 'param.mat'
d = zeros(1,6);
d(1) = param.v.now;
d(2) = param.f.now;
d(3) = mean(cell2mat(param.results(2:end,14)));
d(4) = max(cell2mat(param.results(2:end,14)))-min(cell2mat(param.results(2:end,14)));
d(5) = mean(cell2mat(param.results(2:end,16)))*100;
d(6) = (max(cell2mat(param.results(2:end,16)))-min(cell2mat(param.results(2:end,16))))*100;
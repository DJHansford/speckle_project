% Plot and save all the repeat tests with captions

total = length(param.results3D(1,1,:));

for n = 1:total
    cap = ['Run ',num2str(n)];
    plotcmap(param.results3D(:,:,n),param.f.range,param.v.range,cap)
    savetwo([param.scantype,' ',num2str(n)])
end
clear all
p=dir('*complex.mat');
load(p.name,'x')
yhi=max(max(abs(x)));
for i=1:10
subplot(10,1,i)
plot(abs(x(:,i)))
ylim([0 yhi])
end
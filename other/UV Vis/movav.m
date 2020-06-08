function p = movav(x)
a=[-3:3];
coeff=exp(-(a/2).^2);
p=mean([x(1:end-6)*coeff(1),x(2:end-5)*coeff(2),x(3:end-4)*coeff(3),x(4:end-3)*coeff(4),x(5:end-2)*coeff(5),x(6:end-1)*coeff(6),x(7:end)*coeff(7)]')';
p=[x(1);x(2);x(3);p/mean(coeff);x(end-2);x(end-1);x(end)];
end
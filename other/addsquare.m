function sn = addsquare(sn, centrex, centrey, size)

x1 = centrex - round(size/2,0);
x2 = centrex + round(size/2,0);
y1 = centrey - round(size/2,0);
y2 = centrey + round(size/2,0);

sn(y1:y2,x1)=255;
sn(y1:y2,x2)=255;
sn(y1,x1:x2)=255;
sn(y2,x1:x2)=255;

end
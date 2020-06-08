function p=readuvvis(fname);
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid=fopen(fname,'r','n','UTF-16');
p=cell2mat(textscan(fid,'%f %f %f','Delimiter',',','Headerlines',2));
fclose(fid);
warning('on','MATLAB:iofun:UnsupportedEncoding');
end
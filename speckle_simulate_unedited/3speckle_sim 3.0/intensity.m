clear all
loc='C:\Users\bras2756\Google Drive\Uni Work\Simulation\SimData\'; %Different for work PC and laptop
cd(loc)
screen_name = 'eighth_pi_max_change_screen';
q=dir([loc,'*\*\speckle ',screen_name,' data.mat']);
qname={q.name};
qfolder={q.folder};
params = cellfun(@(x) x(length(loc)+2:end), qfolder, 'un', 0);

n=8192;
mid = n*4;
search = n*2;

data=zeros(length(q),14);
a=round(linspace(1,length(q),11),0);

for i = 1:length(q)
    A = load([qfolder{i},'\',qname{i}]);
    b = dir([qfolder{i},'\','*complex.mat']);
    load([qfolder{i},'\',b.name],'x');
    data(i,1:length(str2double(strsplit(params{i},{'\','-','_','t','w'})))) = str2double(strsplit(params{i},{'\','-','_','t','w'}));
    data(i,13)=A.cumSC(end);
    data(i,12)=A.fcumSC.c;
    data(i,14) = 100*(sum(sum(A.loopIall(:,mid-search:mid+search)))/100)/5.19504096344176e+19;
    data(i,15) = abs(max(max(real(x))));
    
    [num, per] = ismember(i,a(2:end));
    if num
        disp([num2str(per*10),'% through'])
    end

end

for i = 1:length(q)
disp(num2str(i))
[num, per] = ismember(i,a(2:end));
if num
disp([num2str(per*10),'% through'])
end
end
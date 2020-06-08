function[newcopy] = copynewfiles(oldloc, newloc, search, filetype)
%COPYNEWFILES(oldloc, newloc, search)
%  oldloc: Location (folder) to copy new files from
%  newloc: Location (folder) to copy new files into
%  search: text string required in filenames for them to be copied
%  filetype: Filetype to be included in the search
% 
% This code looks in oldloc for any files with 'search' in their name,
% checks if they exist already in newloc and copies them over if they
% don't. It will display the number of files found and copied. It will also
% preserve the folder structure within oldloc in newloc and create any
% required new folders. ONLY WORKS WITH MATLAB 2017 AND BEYOND.

oldfiles = dir([oldloc,'**\*',search,'*.',filetype]);
newfiles = dir([newloc,'**\*',search,'*.',filetype]);

oldnames = {oldfiles.name}.';
oldfolders = {oldfiles.folder}.';
oldsubfolders = cellfun(@(x) x(length(oldloc)+1:end), oldfolders, 'un', 0);
oldsubnames = join(horzcat(oldsubfolders, oldnames).','\',1).';
oldfullnames = join(horzcat(oldfolders, oldnames).','\',1).';

newnames = {newfiles.name}.';
newfolders = {newfiles.folder}.';
newsubfolders = cellfun(@(x) x(length(newloc)+1:end), newfolders, 'un', 0);
newsubnames = join(horzcat(newsubfolders, newnames).','\',1).';
newfullnames = join(horzcat(newfolders, newnames).','\',1).';

makesubfolders = setdiff(oldsubfolders,newsubfolders);
makefiles = setdiff(oldsubnames,newsubnames);

for I=1:length(makesubfolders)
    mkdir([newloc,makesubfolders{I}]);
%     newdir{I} = [newloc,makesubfolders{I}];
end
for I=1:length(makefiles)
    copyfile ([oldloc,makefiles{I}], [newloc,makefiles{I}])
%     oldcopy{I} = [oldloc,makefiles{I}];
    newcopy{I} = [newloc,makefiles{I}]; % This is a list of all the newly created files!
end

disp([num2str(length(oldfiles)),' new files found.'])
disp([num2str(length(makesubfolders)),' folders created.'])
disp([num2str(length(makefiles)),' files copied.'])

end
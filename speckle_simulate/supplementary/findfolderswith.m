function[folders] = findfolderswith(location, search_string, filetype)
% FINDFOLDERSWITH returns a list of folders in the directory 'location'
%   that contain a file with 'search_string' in their name and are the
%   correct 'filetpe'.
%   
%   A = FINDFOLDERSWITH('C:\Users\bras2756\Documents','test','txt')
%       Output is a list of folders that contain any file with 'test' in
%       the name that are of type .txt
% 
%   Use search_string '*' to list all directories that contain any files of
%   your chosen filetype
% 
%   Use filetype '*' to list all directories that contain files of any
%   filetype that match your chosen search_string

p=dir([location,'\**\']);
q=dir([location,'\**\*',search_string,'*.',filetype]);

pfol={p.folder}.';
qfol={q.folder}.';
folders=intersect(pfol,qfol);

end
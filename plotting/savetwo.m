function savetwo(name)
%SAVETWO(name)
%  name: Filename for saving
% 
% Use this to save two copies of the open figure: 'name'.fig and 'name'.png

% This ensures that the printed version is the same size as the onscreen version
set(gcf, 'PaperPositionMode', 'auto');

saveas(gcf,[name,'.fig'])
saveas(gcf,[name,'.png'])
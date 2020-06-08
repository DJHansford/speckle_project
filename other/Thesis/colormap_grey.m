run=1;

% graph = ['517nm 20µm Run ',num2str(run)];
graph = '250nm 100°C';
type=3;

switch type
    case 1
        % Double up rows
%         A=A';
%         [x,y]=size(A);
%         A(x+1:2*x,:)=A;
%         A=reshape(A,x,2*y)';
        
        data = A;
        [dx, dy] = size(data);

        Z = zeros(26,5);
        Z(1:dx,1:dy) = data;
        imagesc(Z,[0 0.625]);
        
        set(gca, 'YTick', 1:4:44, 'YTickLabel', 10:2:22)
        set(gca, 'XTick', 1:1:5, 'XTickLabel', 20:20:100)
        
        % Add grey rectangle for CTAB cells that can't be pushed to 20Vum
        patch([0,36,36,0],[22.5,22.5,27,27],[0.6 0.6 0.6],'EdgeColor','[0.6 0.6 0.6]')
    case 2
        data = A;
        [dx, dy] = size(data);
        
        Z = zeros(25,9);
        Z(1:dx,1:dy) = data;
        imagesc(Z,[0 0.625]);
        
        set(gca, 'YTick', 1:4:44, 'YTickLabel', 10:2:22)
        set(gca, 'XTick', 1:2:9, 'XTickLabel', 20:20:100)
        
        % Add grey rectangle for CTAB cells that can't be pushed to 20Vum
        patch([0,36,36,0],[21.5,21.5,27,27],[0.6 0.6 0.6],'EdgeColor','[0.6 0.6 0.6]')
    case 3
%         run = 1;
        %load param.mat
        data = param.results2D(:,:,run);
%         data = A;
        [dx, dy] = size(data);
        
        Z = zeros(20,10);
        Z(1:dx,1:dy) = data;
        imagesc(Z,[0 0.625]);
        
        set(gca, 'YTick', 2:2:20, 'YTickLabel', 2:2:20)
        set(gca, 'XTick', 2:2:11, 'XTickLabel', 300:300:1650)
        
        % Add grey rectangle for CTAB cells that can't be pushed to 20Vum
%         patch([10.5,76,76,10.5],[0,0,21,21],[0.6 0.6 0.6],'EdgeColor','[0.6 0.6 0.6]')
end

colormap jet;
colorbar;

xlabel 'Frequency (Hz)'
ylabel 'Field amplitude (V/\mum)'

export_fig([graph,'.png'], '-transparent', '-r600')
saveas(gcf,[graph,'.fig'])
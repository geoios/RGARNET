function plotHist(DataArray)
%% 函数说明
%功能：画直方图
%% 功能代码
[y,x] = hist(DataArray,10);
h = bar(x,y,0.8,'EdgeColor',[255/255 255/255 255/255]);hold on;
ylabel('Frequency')
set(h,'edgecolor','none');
set(gca,'FontSize',18,'Fontname','Times new roman','FontWeight','bold','linewidth',0.75,'tickdir','in');
box on;
set(gcf,'Units','centimeter','Position',[5 5 9 6])
set(0,'defaultfigurecolor','w');
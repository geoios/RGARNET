function [statsInfo_garp,statsInfo_prop] = plotHist_sessp(diffE,diffN,diffU)
%% 函数说明
%功能：绘自构声速剖面精度直方图及输出精度
%% 功能代码
%绘E误差直方图
subplot(1,3,1)
[StatsInfoE1,yE1,xE1] = plotHist_subsSessp(diffE(:,1));
[StatsInfoE2,yE2,xE2] = plotHist_subsSessp(diffE(:,2));
b = bar(xE1,yE1,0.8,'EdgeColor',[255/255 255/255 255/255]);hold on;
set(b,'edgecolor','none');
b = bar(xE2,yE2,0.6,'EdgeColor',[255/255 255/255 255/255]);hold on;
set(b,'edgecolor','none');
xlabel([{''};{'E'}]);
ylabel('Frequency')
set(gca,'FontSize',18,'Fontname','Times new roman','FontWeight','bold','linewidth',0.75,'tickdir','in');box on;
%绘N误差直方图
subplot(1,3,2)
[StatsInfoN1,yN1,xN1] = plotHist_subsSessp(diffN(:,1));
[StatsInfoN2,yN2,xN2] = plotHist_subsSessp(diffN(:,2));
b = bar(xN1,yN1,0.8,'EdgeColor',[255/255 255/255 255/255]);hold on;
set(b,'edgecolor','none');
b = bar(xN2,yN2,0.6,'EdgeColor',[255/255 255/255 255/255]);hold on;
set(b,'edgecolor','none');
pos = axis;
xlabel([{'Difference (cm)'};{'N'}])
set(gca,'FontSize',18,'Fontname','Times new roman','FontWeight','bold','linewidth',0.75,'tickdir','in');box on;
legend('Difference between the GARPOS solutions','Difference between the proposed solutions','box','on','position',[0.47 0.92 0.1 0.1],'Orientation','horizon','FontSize',10)
%绘500~1727.80误差直方图
subplot(1,3,3)
[StatsInfoU1,yU1,xU1] = plotHist_subsSessp(diffU(:,1));hold on;
[StatsInfoU2,yU2,xU2] = plotHist_subsSessp(diffU(:,2));hold on;
b = bar(xU1,yU1,0.8,'EdgeColor',[255/255 255/255 255/255]);hold on;
set(b,'edgecolor','none');
b = bar(xU2,yU2,0.6,'EdgeColor',[255/255 255/255 255/255]);hold on;
set(b,'edgecolor','none');
xlabel([{''};{'U'}]);
set(gca,'FontSize',18,'Fontname','Times new roman','FontWeight','bold','linewidth',0.75,'tickdir','in');box on;

set(gcf,'Units','centimeter','Position',[5 5 25 10]);

statsInfo_garp = [StatsInfoE1;StatsInfoN1;StatsInfoU1];
statsInfo_prop = [StatsInfoE2;StatsInfoN2;StatsInfoU2];

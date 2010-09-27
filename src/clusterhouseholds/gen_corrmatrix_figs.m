% Generate Fig. 4 from the DEV paper 

clf
width = 2;
height = 2;
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[width height]);
set(gcf,'PaperPosition',[0 0 width height]);

imagesc(Cinit_fig);
set(gca,'position',[.02 .02 .96 .96]);
set(gca,'xtick',[],'ytick',[],'linewidth',2)
box on
colormap gray
saveas(gcf,'Cinit.png');

imagesc(Cfinal_fig);
set(gca,'position',[.02 .02 .96 .96],'linewidth',2);
set(gca,'xtick',[],'ytick',[])
box on
colormap gray
saveas(gcf,'Cfinal.png');

clf
width = 10;
height = 4;
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[width height]);
set(gcf,'PaperPosition',[0 0 width height]);

eb = std(scores(1:25,:,1),1);
m = mean(scores(1:25,:,1),1);
confplot(1:1000,m,2*eb,2*eb)
set(gca,'ylim',[0 .8])
xlabel('Number of iterations');
ylabel('o');
box off
saveas(gcf,'cluster-objective-function.eps');

treeplot([0 1 1 2 2 7 5 4 5 4 9 6 8 8 7 9 3 3 6]);
axis off
width = 10;
height = 10;
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[width height]);
set(gcf,'PaperPosition',[0 0 width height])
set(gca,'linewidth',2)
saveas(gcf,'tree.eps');

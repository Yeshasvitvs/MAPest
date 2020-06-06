function plotData(input_data, linkNames, lineStyle, legendString, datasetName, figTitle, figTitleExpression)

%% Plot parameters
fontSize = 20;
lineWidth = 2;
colors = get(groot,'DefaultAxesColorOrder');

fH = figure('units','normalized','outerposition',[0 0 1 1]);

for i = 1:size(input_data, 2)
    
    subplot(5,5,i);
    
    for j = 1:size(input_data{i}, 2)
        
        plot(input_data{i}(:,j), 'LineWidth', lineWidth,...
            'LineStyle', lineStyle, 'Color', colors(j, :));
        hold on;
    end
    
    set(findobj(gcf,'type','axes'),'FontSize',fontSize,'LineWidth', lineWidth);
    
    t = title(linkNames{i},'Interpreter', 'latex');
    t.FontSize = fontSize;
    
    if i == 1
        legend(legendString, 'Interpreter', 'latex', 'FontSize',fontSize,...
               'Location','bestoutside', 'NumColumns',12, 'Position',[0.2 0.855 0.1 0.2]);
        legend('boxoff')
        hold on;
    end

end

a = axes;
t = title(strcat(datasetName, " - ", figTitle, " - ", figTitleExpression),'Interpreter', 'latex', 'Position', [0.5, 1.025, 0]);
hold on;
t.FontSize = fontSize;
a.Visible = 'off' ;
t.Visible = 'on' ;

%% Save figure
save2pdf(strcat(datasetName, " - ", figTitle), fH,300);

end
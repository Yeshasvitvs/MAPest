% clc
% close all;
% clear all;

%% Plot parameters
fontSize = 20;
lineWidth = 2;

numOfLinks =  size(suit.links, 1);
velocityLegend = ["$v_x$", "$v_y$", "$v_z$", "$\omega_x$", "$\omega_y$", "$\omega_z$"];
accelerationLegend = ["$\dot{v}_x$", "$\dot{v}_y$", "$\dot{v}_z$", "$\dot{\omega}_x$", "$\dot{\omega}_y$", "$\dot{\omega}_z$"];

fH = figure('units','normalized','outerposition',[0 0 1 1]);

for i = 1:numOfLinks
    
    subplot(8,4,i);
    plot(suit.links{i,1}.meas.velocity', 'LineWidth', lineWidth);
    hold on;
    plot(suit.links{i,1}.meas.angularVelocity', 'LineWidth', lineWidth);
    hold on;
    
    set(findobj(gcf,'type','axes'),'FontSize',fontSize,'LineWidth', lineWidth);
    
    t = title(suit.links{i,1}.label,'Interpreter', 'latex');
    t.FontSize = fontSize;
    
    if i == 1
        legend(velocityLegend, 'Interpreter', 'latex', 'FontSize',fontSize,...
               'Location','bestoutside', 'NumColumns',6, 'Position',[0.2 0.855 0.1 0.2]);
        legend('boxoff')
        hold on;
    end

end

a = axes;
t = title("Measured Link Velocity $ {}^{A}\mathrm{v}_{A,L}$",'Interpreter', 'latex');
hold on;
t.FontSize = fontSize;
a.Visible = 'off' ;
t.Visible = 'on' ;

fH = figure('units','normalized','outerposition',[0 0 1 1]);

for i = 1:numOfLinks
    
    subplot(8,4,i);
    plot(suit.links{i,1}.meas.acceleration', 'LineWidth', lineWidth);
    hold on;
    plot(suit.links{i,1}.meas.angularAcceleration', 'LineWidth', lineWidth);
    hold on;
    
    set(findobj(gcf,'type','axes'),'FontSize',fontSize,'LineWidth', lineWidth);
    
    t = title(suit.links{i,1}.label,'Interpreter', 'latex');
    t.FontSize = fontSize;
    
    if i == 1
        legend(accelerationLegend, 'Interpreter', 'latex', 'FontSize',fontSize,...
            'Location','bestoutside', 'NumColumns',6, 'Position',[0.2 0.855 0.1 0.2]);
        legend('boxoff')
        hold on;
    end

end

a = axes;
t = title("Measured Link Acceleration $ {}^{A}\dot{\mathrm{v}}_{A,L}$",'Interpreter', 'latex');
t.FontSize = fontSize;
a.Visible = 'off' ;
t.Visible = 'on' ;


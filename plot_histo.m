function plot_histo(folder)
    hold on;
    figure(2);
    load_factor_max_csv = [folder '\max_factors.csv'];
    pdf_file = [folder '\norm.pdf'];
    max_Values = importdata(load_factor_max_csv);
    std_values = std(max_Values);
    mean_values = mean(max_Values);
    max_Values = round(max_Values,1);
    mean_str = num2str(mean_values);
    std_str = num2str(std_values);
    dim = [0.2 0.5 0.3 0.3];
    text = {['Std = ' std_str],['Mean = ' mean_str]};
    annotation('textbox',dim,'String',text,'FitBoxToText','on');
    histogram(max_Values);
    norm=histfit(max_Values,10, 'normal');
    xlabel('Load Factor');
    ylabel('Relative frequency [%]');
    title('Load factor frequency distribution');
    disp(norm);
    figure(3);
    new_mean = 1; % scegli la nuona media.
    new_std = 0.15; % scegli la nuova std dev.
    traslation_values = new_mean + (max_Values - mean_values) * (new_std / std_values) ;
    text = {['Std = ' num2str(round(new_std, 2))],['Mean = ' num2str(round(new_mean, 2))]};
    annotation('textbox',dim,'String',text,'FitBoxToText','on');
    h = histfit(traslation_values);
    delete(h(1));
    xlabel('Load Factor');
    ylabel('Relative frequency [%]');
    title('Normalized load factor frequency distribution');
    hold off;

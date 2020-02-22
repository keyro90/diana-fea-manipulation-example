function plot_result_tb(filename_tb_prefix, start_index, end_index, folder)
PATH_TB_FILES=folder;
PATTERN_LINE = '79\s+-?[\d\.\+]+E[\+\-]+\d+';
PATTERN_NUM = '-?[\d\.\+]+E[\+\-]+\d+';
PATTERN_LOAD_FACTOR = 'Load factor';
AT_ELEMENT_ADD = 4;
filename_max_factors = sprintf('%s\\max_factors.csv',PATH_TB_FILES);
floadfactors = fopen(filename_max_factors,'w+');
hold on;
figure(1);
for j = start_index:end_index
    disp(j);
    delta = -1;
    count = 1;
    not_already_applied = true;
    filenameA = sprintf('%s\\%s_%d.tb',PATH_TB_FILES,filename_tb_prefix,j);
    disp(filenameA);
    fid = fopen(filenameA,'rb');
    tline = fgetl(fid);
    x_values = [];
    y_values = [];
    max_load_factor = 0;
    while true
        tline = fgetl(fid);
        if ~ischar(tline); break; end
        % i've found a load factor line.
        if (any(regexp(tline, PATTERN_LOAD_FACTOR)) && 1)
            if (count >= AT_ELEMENT_ADD && not_already_applied)
                delta = 0;
                not_already_applied = false;
            end
            [single_match, ] =  regexp(tline, PATTERN_NUM, 'match');
            num = str2double(single_match{1})+delta;
            if (max_load_factor < num)
                max_load_factor = num;
            end
            y_values = [y_values, num];
            count = count + 1;
        else
            % i've found a node 39 line.
            if (any(regexp(tline, PATTERN_LINE)) && 1)
                [second_col, ] =  regexp(tline, PATTERN_NUM, 'match');
                num = str2double(second_col{2});
                x_values = [x_values, num];
            end
        end
    end
    %write into file max load factor this file.
    fprintf(floadfactors, '%d\n', max_load_factor);
    plot(x_values, y_values, '-');
end
fclose(floadfactors);
xlabel('Vertical displacement');
ylabel('Load factor');
title('Samples Nonlinear Analysis');
hold off

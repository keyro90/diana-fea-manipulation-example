clc
clear
fclose 'all';

% ************ Constant Variables ************
% Please set your configuration.

% Name of folder where script will put all files.
FOLDER_SAMPLE = 'Samples_def_3';
% DAT File
CASE_STUDY_FILE = 'CaseStudy1_Definitive.dat';
% DCF File
ANALYSIS_FILE = 'Analysis2D.dcf';
% dialogin.bat -> Tipically, it's on your DIANA folder.
PATH_FILE_DIALOGIN='"C:\Program Files\Diana 10.3\dialogin.bat"';
% Base File BAT.
BAT_FILE='launch_diana.bat';
% Suffix name for each generation.
SUFFIX_FILE='filename';
% How many elements you wants to generate.
N_ELEMS_TO_GENERATE = 1;
% create folder. Depending on your Matlab version, you could check its
% existance. In this case, if folder exists, script will throw an
% exception.
mkdir(FOLDER_SAMPLE);
%generating the 100 samples for each relevant random variable
sp=N_ELEMS_TO_GENERATE;
A=lhsnorm (3.8e7,4.6e6^2,sp);
B=lhsnorm (0.4925,0.0088^2,sp);
C=lhsnorm (5.3e7,4.8e6^2,sp);
D=lhsnorm (560e6,30e6^2,sp);
E5=lhsnorm (142.750,2.86^2,sp);
E6=lhsnorm (49.7600,0.995^2,sp);
E7=lhsnorm (138.230,2.76^2,sp);
E8=lhsnorm (18.8500,0.377^2,sp);
E9=lhsnorm (28.2700,0.565^2,sp);
E10=lhsnorm (12.0600,0.241^2,sp);
E11=lhsnorm (58.9000,1.18^2,sp);
F=lhsnorm(1257.5e6,31.5e6^2,sp);
M = [A,B,C,D,E5,E6,E7,E8,E9,E10,E11,F];
xlswrite ('HypercubeLatin',M)
% Regex to match number in scientific format. E.g. 5.1235e+003
PATTERN_NUM = '-?[\d\.\+]+E[\+\-]+\d+';
% your number formato to write into new file.
FORMAT_NUM = '%1.5E';
% assignment of the values to the correct string
for q=1:N_ELEMS_TO_GENERATE
    data.textdata{1812,2} = num2str(M(q,1));
    data.textdata{1821,4} = num2str(M(q ,2));
    data.textdata{1793,2} = num2str(M(q,3));
    data.textdata{1774,2} = num2str(M(q,4));
    data.textdata{1775,2} = num2str(M(q,4));
    data.textdata{1885,2} = num2str(M(q,5)/1000);
    data.textdata{1889,2} = num2str(M(q,6)/1000);
    data.textdata{1881,2} = num2str(M(q,7)/1000);
    data.textdata{1877,2} = num2str(M(q,8)/1000);
    data.textdata{1873,2} = num2str(M(q,9)/1000);
    data.textdata{1869,2} = num2str(M(q,10)/1000);
    data.textdata{1865,2} = num2str(M(q,11)/1000);
    data.textdata{1761,2} = num2str(M(q,12));
    data.textdata{1762,2} = num2str(M(q,12));
    %import data and print    
    fid = fopen(CASE_STUDY_FILE);
    tline = fgetl(fid);
    count_lines = 0;
    % string filename_{...}.dat, filename_{...}.dcf, filename_{...}.bat
    % etc.
    filename_prefix=[FOLDER_SAMPLE '\' SUFFIX_FILE];
    filename_wo_ext = sprintf('%s_%d', filename_prefix, q);
    filename=sprintf('%s.dat', filename_wo_ext);
    filename_dcf = sprintf('%s.dcf',filename_wo_ext);
    filename_bat = sprintf('%s.bat',filename_wo_ext);
    % creation dcf file with same name.
    copyfile(ANALYSIS_FILE, filename_dcf);
    copyfile(BAT_FILE, filename_bat);
    fout=fopen(filename,'wt');
    % inserting the values of the 100
    % Check if I'm in a specific line and apply a regex replace with new value. 
    while ischar(tline)
        count_lines = count_lines + 1;
        if count_lines == 1812
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,1), FORMAT_NUM));
        end
        if count_lines == 1821
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,2), FORMAT_NUM), 3);
        end
        if count_lines == 1793
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,3),FORMAT_NUM));
        end
        if count_lines == 1774
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,4),FORMAT_NUM));
        end
        if count_lines == 1775
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,4),FORMAT_NUM));
        end
        if count_lines == 1885
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,5)/10000,FORMAT_NUM));
        end
        if count_lines == 1889
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,6)/10000,FORMAT_NUM));
        end
        if count_lines == 1881
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,7)/10000,FORMAT_NUM));
        end
        if count_lines == 1877
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,8)/10000,FORMAT_NUM));
        end
        if count_lines == 1873
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,9)/10000,FORMAT_NUM));
        end
        if count_lines == 1869
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,10)/10000,FORMAT_NUM));
        end
        if count_lines == 1865
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,11)/10000,FORMAT_NUM));
        end
        if count_lines == 1761
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,12),FORMAT_NUM));
        end
        if count_lines == 1762
            tline = regexprep(tline, PATTERN_NUM, num2str(M(q,12),FORMAT_NUM));
        end
        fprintf(fout, '%s\n', tline);
        tline = fgetl(fid);
    end
    % Execute diana bat which generates ff and out file. Watch out!
    % diana.ff (FILOS file) must be autogenerated from dcf file. For doing that, add
    % this text in dcf file's head:
    % *FILOS
    % INITIA
    % *INPUT
    % more information in this page: https://dianafea.com/manuals/d93/GetStart/node94.html
    % diana.ff will be generate into current directory and will be removed
    % after analysis.
    cmd = sprintf('%s %s %s', filename_bat, filename_wo_ext, PATH_FILE_DIALOGIN);
    disp(cmd);
    system(cmd);
    fclose(fout);
   
end

disp('Im going to plot results.');
plot_result_tb(SUFFIX_FILE, N_ELEMS_TO_GENERATE,FOLDER_SAMPLE);
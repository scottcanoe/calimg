mice = {'330873-A', '330873-C'};
dates = {'2018-05-14', '2018-05-15', '2018-05-16', '2018-05-17', '2018-05-18'};
expnum = '1';

for ii=1:length(mice)
    for jj=1:length(dates)
        process_exp01_SequentialGratings(mice{ii}, dates{jj}, expnum)
    end
end
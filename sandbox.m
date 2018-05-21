mice = {'330873-A', '330873-C'};
for ii=1:numel(mice)
    sesDirs = listSessionDirs(mice{ii});
    for jj=1:numel(sesDirs)
        source = fullfile(sesDirs{jj}, 'mov', 'Plane1');
        dest = fullfile(sesDirs{jj}, 'mov');
        if exist(source)
            rmdir(source)
        end
%         files = listFiles(source);
%         for kk=1:length(files)
%             fname = fullfile(source, files{kk});
%             status = movefile(fname, dest);
%             rmdir(source);
%         end
    end
end
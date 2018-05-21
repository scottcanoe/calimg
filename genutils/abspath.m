function fullpath = abspath(filename)
% ABSPATH Returns fully resolved absolute path. Works for all operating systems.
% 
narginchk(1, 1);
% Handle home directory ~ sign.
if strcmp(filename(1), '~')
  if length(filename) == 1
      filename = homedir;
  else
      filename = fullfile(homedir, filename(3:end));
  end
end

file = java.io.File(filename);
if file.isAbsolute()
  fullpath = filename;

else
  filename = fullfile(pwd, filename);
  file = java.io.File(filename);
  fullpath = char(file.getCanonicalPath());
end
    
end
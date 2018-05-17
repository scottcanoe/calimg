function fullpath = abspath(filename)
% Returns resolved, absolute path.
% 

  % Handle home directory ~ sign.
  if strcmp(filename(1), '~')
      if length(filename) == 1
          filename = homedir;
      else
          filename = [homedir filename(3:end)];
      end
  end
  
  file = java.io.File(filename);
  if file.isAbsolute()
      fullpath = filename;
  
  else
      filename = [asdir(pwd) filename];
      file = java.io.File(filename);
      fullpath = char(file.getCanonicalPath());
  end
  
  % Add a trailing backslash if its an existing directory.
  if exist(fullpath, 'dir') == 7
      fullpath = asdir(fullpath);
  end
  
end
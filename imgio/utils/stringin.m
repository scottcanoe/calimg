function tf = stringin(string, cellArrayOfStrings)
%STRINGIN Summary of this function goes here
%   Detailed explanation goes here
for ii=1:length(cellArrayOfStrings)
    if strcmp(string, cellArrayOfStrings{ii})
        tf = true;
        return
    end
tf = false;    
end


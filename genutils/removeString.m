function newArr = removeString(arr, toRemove)
% REMOVECELL Returns all elements of 'arr' that are not 'toRemove'. 
% 'toRemove' may be one or more strings. Useful for dropping a string from
% a list of strings.

narginchk(2, 2);
if ischar(toRemove)
    toRemove = {toRemove};
end

nElts = 0;
newArr = cell(1, numel(arr));
for ii=1:numel(arr)
    if ~ismember(arr{ii}, toRemove)
        newArr{nElts+1} = arr{ii};
        nElts = nElts + 1;
    end
end

if nElts == 0
    newArr = {};
else
    newArr = newArr(1:nElts);
end
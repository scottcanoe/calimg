function numBits = dtypeBits(dtypeString)
%BITSPERDTYPE Summary of this function goes here
%   Detailed explanation goes here
assert(ischar(dtypeString));

if strcmp(dtypeString, 'logical')
    numBits = 1;
elseif stringin(dtypeString, {'int8', 'uint8'})
    numBits = 8;
elseif stringin(dtypeString, {'int16', 'uint16'})
    numBits = 16;
elseif stringin(dtypeString, {'int32', 'uint32', 'single'})
    numBits = 32;    
elseif stringin(dtypeString, {'int64', 'uint64', 'double'})
    numBits = 64;    
else
    error('Unrecognized datatype');
end

end


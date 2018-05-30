function tf = isclose(a, b, tolerance)
% ISCLOSE Test for floating point equality. Works for any combination of
% scalars and vectors, meaning that 'a' and 'b' can by any combination of
% scalars or vectors.

narginchk(2, 3);
if nargin == 2
    tolerance = 10^-10;
end

if and(isscalar(a), isscalar(b))
    if abs(a - b) <= tolerance
        tf = true;
    else
        tf = false;
    end
    return
end

if isscalar(a)
    a = a * ones(1, length(b));
end

if isscalar(b)
    b = b * ones(1, length(a));
end

tf = zeros(1, length(b), 'logical');
for ii=1:length(b)
    if abs(a(ii) - b(ii)) <= tolerance
        tf(ii) = true;
    else
        tf(ii) = false;
    end
end

end
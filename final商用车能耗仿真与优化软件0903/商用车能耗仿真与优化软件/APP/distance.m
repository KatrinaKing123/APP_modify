
function D = distance(v)
s = zeros(1, length(v));
for i = 1 : length(v) - 1
   s(i) = (v(i) + v(i+1)) / 2 / 3.6;
end
D = sum(s);
D = D/1000;
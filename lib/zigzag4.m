function Z = zigzag4(N)

if ~exist('N')
  N = 8;
end

Z = zeros(N*N,2);
u = 0; v = 2; inc = 1;

for n = 1:N*N
  v = v - inc; u = u + inc;
  if (u > N)
    v = v + 2; u = N; inc = -1;
  elseif (v == 0)
    v = 1; inc = -1;
  elseif (v > N)
    u = u + 2; v = N; inc = 1;
  elseif (u == 0)
    u = 1; inc = 1;
  end
  Z(n,:) = [v u];
end

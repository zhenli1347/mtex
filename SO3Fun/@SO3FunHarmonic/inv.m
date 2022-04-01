function SO3F = inv(SO3F)      
% Define the inverse function $g$ of an SO3FunHarmonic $f$ by $g(R^{-1}) = f(R)$
% for all rotations $R\in SO3(3)$.
%
% Syntax
%   SO3F = inv(F)
%
% Input
%  F - @SO3FunHarmonic
%
% Output
%  SO3F - @SO3FunHarmonic
%  

if SO3F.bandwidth == 0 || SO3F.antipodal==true
  return
end

ind = zeros(deg2dim(SO3F.bandwidth+1),1);
for l = 0:SO3F.bandwidth
  localind = reshape(deg2dim(l+1):-1:deg2dim(l)+1,2*l+1,2*l+1)';
  ind(deg2dim(l)+1:deg2dim(l+1)) = localind(:);
end
SO3F.fhat(:,:) = SO3F.fhat(ind,:);

end
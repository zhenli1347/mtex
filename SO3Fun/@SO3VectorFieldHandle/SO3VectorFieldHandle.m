classdef (InferiorClasses = {?SO3FunBingham,?SO3FunCBF,?SO3FunComposition, ...
    ?SO3FunHandle,?SO3FunHarmonic,?SO3FunHomochoric,?SO3FunRBF,?SO3FunSBF})...
    SO3VectorFieldHandle < SO3VectorField
% a class representing a vector field on SO(3)
  
properties
  fun
  antipodal = false
  SLeft  = specimenSymmetry
  SRight = specimenSymmetry
  bandwidth = 96
end
  
methods
  function SO3VF = SO3VectorFieldHandle(fun,varargin)
    
    SO3VF.fun = fun;
    
    [SRight,SLeft] = extractSym(varargin);
    SO3VF.SRight = SRight;
    SO3VF.SLeft = SLeft;
    
  end
  
  function f = eval(SO3VF,ori,varargin)

    % change evaluation method to quadratureSO3Grid/eval
    if isa(ori,'quadratureSO3Grid')
      f = eval(SO3VF,ori,varargin);
      return
    end

%     if isa(ori,'orientation')
%       ensureCompatibleSymmetries(SO3VF,ori)
%     end

    f = SO3VF.fun(ori);
    if check_option(varargin,'right')
      f = inv(ori).*f;
    end
  end
  
end

end

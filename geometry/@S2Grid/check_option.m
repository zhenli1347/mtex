function out = check_option(obj,option,varargin)
% return options

if nargin == 1
  out = obj.options;
else
  out = check_option(obj(1).options,option,varargin{:});
end

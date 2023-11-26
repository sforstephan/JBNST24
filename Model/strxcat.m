function string = strxcat(varargin)
%Verkettung von Strings und Zahlen zu einem String
% A variable number of strings or numbers are concatenated into the output string.
% 
% INPUT : n strings or numbers
% OUTPUT: string

string = [];
nbarg = length(varargin);
if nbarg == 0
  return
end

for arg_i = 1:nbarg
  substr = varargin{arg_i}(:)';
  string = [string num2str(substr)];
end


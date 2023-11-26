function uasdiff = UAS_diff(x)
%Derivation of the agent's utility function
syms a;
f=inline(char(diff(UAS(x(1),a,x(3),x(4),x(6),x(10)),a)));
uasdiff=f(x(2));
clear a;
clear x;
end

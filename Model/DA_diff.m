function dadiff = DA_diff( x )
%Derivation of the agent's disutility function
syms a;
f=inline(char(diff(DA(a,x(7),x(9)),a)));
dadiff=f(x(2));

clear a;
clear f;
clear x;
end


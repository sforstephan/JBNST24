function estimate_a = Estimate_a(x)
%Function for calculating the optmal effort level
syms a;
tmp=solve(diff(DA(a,x(7),x(9)),a)==diff(UAS(x(1),a,x(3),x(4),x(6),x(10)),a),a);
estimate_a=double(subs(tmp,a,x(2)));
clear a;
end


function estimate_p = Estimate_p(x)
%Function for calculating the optmal effort level
syms a;
syms p;
 

estimate_p=double(solve(subs(diff(DA(a,x(7),x(9)),a),a,x(2))-subs(diff(UAS(x(1),a,p,x(4),x(6),x(10)),a),a,x(2)),p,'IgnoreAnalyticConstraints', true));

clear a;
clear p;
end


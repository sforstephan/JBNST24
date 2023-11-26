function estimate_mina = Estimate_mina(productivity,umw)
syms a;
tmp=vpasolve(PROD(a,productivity,umw)==0,a);
if tmp <=0
    estimate_mina=0;
else
    estimate_mina=tmp;
end
clear a temp;
end


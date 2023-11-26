function exphurdle = Estimate_exphurdle(explorationDegree,umwM,umwSD)
%Not relevant for this simulation study
tmpfun=@(a) normcdf(a,umwM,umwSD)-explorationDegree;
optionsFsolve=optimset(optimset('fsolve'),'TolFun',1E-6,'TolX',1E-6,'Display','none');
x0=umwM;
exphurdle=fsolve(tmpfun,x0,optionsFsolve);


end

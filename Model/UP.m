function up = UP( fl,a,p,productivity,para,umw )
%Principal's utility function

if (para==0)
    up=PROD(a,productivity,umw)-S(fl,a,productivity,p,umw);
else
    up=(1-exp(1)^(-para * (PROD(a,productivity,umw) - S(fl,a,productivity,p,umw))))/para;
end


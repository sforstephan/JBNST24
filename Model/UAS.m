function uas = UAS( fl,a,p,productivity,aara,umw )
%agent's utility gathered from compensation

if (aara==0)
    uas=S(fl,a,productivity,p,umw);
else
    uas=(1 - exp(1)^(-aara*S(fl,a,productivity,p,umw)) ) / aara;
end


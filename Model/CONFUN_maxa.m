


function [ c, ceq ] = confun_secondbest( x )
%Constraint-function for secondbest-solution
    %x(1)=fl
    %x(2)=a
    %x(3)=p
    %x(4)=productivity
    %x(5)=para
    %x(6)=aara
    %x(7)=disa
    %x(8)=resutil
    %x(9)=eqeffort
    
%nonlinear inequality constraint  
c=[ %participation constraint
    x(8) - UA(x(2),x(7),x(9),x(1),x(3),x(4),x(6),x(10));

   -(x(2));

   -x(3);
   -x(3)-1;
    ];
%equality constraint
ceq=[
    %Anreizkompatibilitätsbedingung (incentive compatibility)
    UAS_diff(x)-DA_diff(x);
    ];
  
end


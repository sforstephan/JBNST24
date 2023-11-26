
function up = UP_objfun( x )
%Objective-Function for linear optimization problem
%   %Vektor x
    %x(1)=fl
    %x(2)=a
    %x(3)=p
    %x(4)=productivity
    %x(5)=para
    %x(6)=aara
    %x(7)=disa
    %x(8)=resutil
    %x(9)=eqeffort
    
    up= - ( PROD( x(2), x(4),x(10) ) - S( x(1), x(2), x(4), x(3), x(10)) );

end

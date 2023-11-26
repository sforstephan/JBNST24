function differences = differences( A )
%Abfall der Performance von einer Periode zur anderen
%   A = Vektoren mit gesamten Zeitreihen´
c=0;
for j=2:size(A,2)
    for i=1:size(A,1)

        differences(i,j-1)=A(i,j)-A(i,j-1);
    end
end


end
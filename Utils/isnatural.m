function bool = isnatural(A)
%ISNATURAL True for natural numbers
% ISNATURAL(A) returns a logical array that is true for values in A that 
% are real, integer-valued and greater than zero, and false otherwise.

bool = isint(A) & A > 0;
end
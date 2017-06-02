function bool = isint(A)
%ISINT True for integers (regardless of numeric type)
% isint(A) returns a logical matrix that is true for values in A that are 
% real and integer-valued, and false otherwise.

bool = isfinite(A) & imag(A)==0 & ceil(A) == floor(A);
end
function [ B ] = sympoly2sm( P, vars )
%POLY2SM Summary of this function goes here
%   Detailed explanation goes here
N = length(vars);
B=sym('B',[N,N]);
for j = 1: N
    dP = diff(P,vars(j));
    B(j,j)= 0.5*diff(dP,vars(j));
    
    for i = (j+1): N
         B(i,j) = 0.5*diff(dP,vars(i));
         B(j,i) = B(i,j);
    end
end

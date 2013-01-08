function matrix = normalize(matrix)
% NORMALIZE   Matrix normalization. 
%    NORMALIZE() normalizes a matrix, all the values 
%    will be included in the interval [0 1]. 
%  
%    NORMALIZE(A) computes the matrix A of m,n dimension. 
%
%    NORMALIZE returns a the normalized matrix.
%
% See also MAX, MIN
  
% Javier ROJAS BALDERRAMA. Grenoble, May 2005  

% % version de Rojas
%   if min( matrix(:)) ~= max( matrix(:))
%     
%     matrix = matrix - min( matrix(:) );
%     matrix = matrix / max( matrix(:) );
%   
%   else
%     
%     matrix;
%     
%   end
  
  
  % normalize modifie
  ma = max( matrix(:));
  mi = min( matrix(:));
  if  mi ~= ma 
  
      matrix = matrix - mi;
      matrix = matrix /(ma - mi);

  else
    
    matrix;
    
  end
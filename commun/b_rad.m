function B = b_rad(rho,r_max,sigma);

  % r_max is max value of rho (radius or neighborhood)
  % sigma is the standard deviation of the gaussian set
    
  if rho <= r_max
    B = 1;
  
  else
    B = exp(  -rho^2 / (2*sigma));

  end
  

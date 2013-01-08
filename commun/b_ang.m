function B = b_ang(theta,alpha,phi);

  % alpha is the openning angle 
  % theta is the prefered direction  
  
  phi = phi * pi/180;  
    
  theta =  theta * pi/180;
  alpha =  alpha * pi/180;
  
  if ( abs(phi - theta) <= alpha/2 )
    B = cos( 2 * pi * (1/(2*alpha)) * (theta-phi) );
  
  else
    B = 0;
  
  end
  



%__________________________________________________________________ %
%                          Multi-Objective                          %
%        Multi-Objetective Stochastic Paint Optimizer (MOSPO)       %
%                                                                   %
%                                                                   %
%                  Developed in MATLAB R2021a (MacOs)               %
%                                                                   %
%                      Author and programmer                        %
%                ---------------------------------                  %
%                      Nima Khodadadi (ʘ‿ʘ)                         %
%                       SeyedAli Mirjalili                          %
%                             e-Mail                                %
%                ---------------------------------                  %
%                         nkhod002@fiu.edu                          % 
%                                                                   %
%                            Homepage                               %
%                ---------------------------------                  %
%                    https://nimakhodadadi.com                      %
%                                                                   %
%                                                                   %
%                                                                   %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %

function range = xboundaryP(name)

 
    
    switch name
      
        case {'P8'}% SRN
            range = zeros(2,2);
            range(1,1)  = -20;
            range(2,1)  = -20;
            range(1,2)  = 20; 
            range(2,2)  = 20; 
       
    end
end
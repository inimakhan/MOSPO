

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


% ----------------------------------------------------------------------- %

function i=RouletteWheelSelection(p)

    r=rand;
    c=cumsum(p);
    i=find(r<=c,1,'first');

end
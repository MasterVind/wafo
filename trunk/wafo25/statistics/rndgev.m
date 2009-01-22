function R = rndgev(varargin)
%RNDGEV Random matrices from a Generalized Extreme Value distribution
% 
% CALL:  R = rndgev(k,s,m0,sz)
%        R = rndgev(phat,sz)
%     
%        R = matrix of random numbers
%        k = shape parameter in the GEV
%        s = scale parameter in the GEV, s>0  (default 1)
%       m0 = location parameter in the GEV    (default 0)
%      phat = Distribution parameter struct
%             as returned from FITGEV.  
%       sz = size(R)    (Default common size of k,s and m0)
%            sz can be a comma separated list or a vector 
%            giving the size of R (see zeros for options). 
% 
% The generalized extreme-value distribution is defined by its cdf
%
%                exp( - (1 - k(x-m)/s))^1/k) ),  k~=0
%  F(x;k,s,m) =
%                exp( -exp(-(x-m)/s) ),  k==0
%
%  for x>s/k+m (when k<=0) and x<m+s/k (when k>0).
%
% The random numbers are generated by the inverse method. 
%
% Example:
%   R1=rndgev(0.5,5,0,1,100);  % Finite end-point (R1<4)
%   plotgumb(R1),shg
%   R2=rndgev(0,2,0,1,100);    % Gumbel
%   plotgumb(R2),shg
%   R3=rndgev(-.5,.2,0,1,100); % Heavy tailed
%   plotgumb(R3),shg
%
% See also  pdfgev, cdfgev, invgev, fitgev, momgev


% Tested on: Matlab 5.3
% History: 
% Revised by jr 22.12.1999
% revised ms 14.06.2000
% - updated header info
% - changed name to rndgev (from gevrnd)
% - allowed 3 arguments
% revised pab 23.10.2000
%   - added default s,m0
%  - added comnsize, nargchk
%  - added greater flexibility on the sizing of R

error(nargchk(1,inf,nargin))
Np = 3;
options = struct; % default options
[params,options,rndsize] = parsestatsinput(Np,options,varargin{:});
if numel(options)>1
  error('Multidimensional struct of distribution parameter not allowed!')
end

[k,s,m0] = deal(params{:});
if isempty(s),  s=1;end
if isempty(m0), m0=0;end

if isempty(rndsize)
  [csize] = comnsize(k,s,m0);
else
  [csize] = comnsize(k,s,m0,zeros(rndsize{:}));
end
if any(isnan(csize))
  error('k,s and m0 must be of common size or scalar.');
end
  
R = invgev(rand(csize),k,s,m0,'lowertail',false);


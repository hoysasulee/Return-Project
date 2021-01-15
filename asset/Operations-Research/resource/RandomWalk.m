% Chapter 6: Numerical Techniques
%            For Unconstrained Optimization
%--------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applied Optimization with Matlab Programming
% Dr. P.Venkataraman
% Second Edition,  John Wiley
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Random Walk Method  for unconstrained minimum
%  two dimension version
%  Zero Order Method
%  6.2.2   Random Walk
%  Side constraints are not checked
%  P. Venkataraman - March 2008
%--------------------------------------------------
% A function m-file for the Random Walk Method
%************************************
% requires:     	       UpperBound_nVar.m
%						   GoldSection_nVar.m
% and the problem m-file:  functname.m
%************************************************
% NEW: NEEDS to be TURNED ON BY USER
% For two dimensions it will plot a filled contour
% to take advantage of Array programming
% the method will look for the problem file written
% in array form in  :     Vfunctname.m
%  For Example if functname is "Example6_1.m"
%  The vector form should be in "VExample6_1m"
%************************************************
%------------------------------------------------
%%%%%Usage ----------------------------------------------
%  RandomWalk(functname,dvar0,niter,tol,lowbound,intvl,ntrials)
%  functname  :  where specific example can be found
%  dvar0      : initial guess for the design vector 
%             : length of this vector defines number of variables
%  niter      : number of random Walk iterations
%  tol        : tolerance for golden section
%  lowbound   : for golden section and upper bound calculations
%  intv       :  for upper bound calculations
%  ntrials    : for upper bound calculations
%%%  Example
% RandomWalk('Example6_1',[0.5 0.5],10, 0.001, 0,1 ,10)
%--------------------------------------------------------
%
function ReturnValue = ...
    RandomWalk(functname,dvar0,niter,tol,lowbound,intvl,ntrials)
%%%%%%%%%%%%%%%%%%%%%%%%%
global xs fs delx1 delx2 % can be used in calling program to print 
%               iterative information if necessary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% management functions
clc    % position the cursor at the top of the screen
close   %  closes the figure window
format compact  % avoid skipping a line when writing to the command window
warning off  % don't report any warnings like divide by zero etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nvar = length(dvar0); % length of design vector or number of variables
% obtained from start vector
if (nvar == 2)
    %*************************
    %  plotting contours -
    %  only for two variables
    %  previous generation code is left in place
    %*************************
    % the plot is centered around initial guess
    % with (+-) delx1, delx2 on either side
    % this can be reset by user
    
    delx1 = 5;
    delx2 = 5;

    x1 = (dvar0(1)-delx1):0.1:(dvar0(1)+delx1);
    x2 = (dvar0(2)-delx2):0.1:(dvar0(2)+delx2);
    x1len = length(x1);
    x2len = length(x2);
%     [X1 X2] = meshgrid(x1,x2);
%     Vfunctname = strcat('V',functname);
%     fun = feval(Vfunctname,X1,X2);
    for i = 1:x1len;
       for j = 1:x2len;
          x1x2 =[x1(i) x2(j)];
          fun(j,i) = feval(functname,x1x2);
       end
    end
    cv = linspace(log10(1),log10(10),20);
    maxf = max(max(fun));
    minf = min(min(fun));
    delm = (maxf - minf);
    cval = minf+ delm*cv;
    colormap(summer);
    [c1,h1] = contourf(x1,x2,fun,cval);
    colorbar
    %clabel(c1); % remove labelling for clarity
    grid
    xlabel('x_1');
    ylabel('x_2');
    funname = strrep(functname,'_','-');
    title(funname);

    % note that contour values are problem dependent
    % the range is problem dependent
    %**************************
    % finished plotting contour
    %***************************

end

%%% this can be reset by user
hstep = 0.001; % step for finite difference slope calculation
% find search direction

% design vector, search vector.alpha , and function value is stored
xs(1,:) = dvar0;
x = dvar0;
fs(1) = feval(functname,x); % value of function at start
as(1)=0;
for i = 1:niter-1
    % determine search direction
    s = rand(nvar,1)';  % remember these elements in the positive quadrant
    sign = rand(nvar,1)'; % used to change signs for s

    for j = 1:nvar
        if (sign(j)> 0.5) s(j) = -s(j); end
    end
    % the search direction is available in s
    % store this value
    ss(i,:) = s;

    % check for intial positive slope
    % if slope is positive then go to the next iteration
    % this step causes function to increase ( alpha = 0)
    %
    curx = x;

    nextx = curx + hstep*s;
    slope = (feval(functname,x+hstep*s)-feval(functname,x)) ...
        /hstep;

    % if slope > 0, then exit this iteration.
    if(slope < 0)
        output = GoldSection_nVar(functname,tol,x, ...
            s,lowbound,intvl,ntrials);
        as(i+1) = output(1);
        fs(i+1) = output(2);
        for k = 1:nvar
            xs(i+1,k)=output(2+k);
            x(k)=output(2+k);
        end
        %**********
        % draw lines
        %************
        if (nvar == 2)
            line([xs(i,1) xs(i+1,1)],[xs(i,2) xs(i+1,2)],'LineWidth',2,'Color','r')
            itr = int2str(i);
            x1loc = 0.5*(xs(i,1)+xs(i+1,1));
            x2loc = 0.5*(xs(i,2)+xs(i+1,2));
            % iteration number not printed
            %text(x1loc,x2loc,itr); % writes iteration number on the line
        end
        %*********
        % finished drawing lines
        %************
        pause(1)
    else
        as(i+1) = 0;
        fs(i+1) = fs(i);
        xs(i+1,:)=xs(i,:);
    end
%     disp([i xs(i,:) fs(i)]);
end
len=length(as);
for kk = 1:nvar
    designvar(kk)=xs(len,kk);
end
% fprintf('The problem:  '),disp(functname)
%fprintf('\n - The design vector and function during the iterations')
%[xs fs']
%ReturnValue = [designvar fs(len)]; pre-Sec. 6.5 - return number of iteration
zoom
ReturnValue = [len designvar fs(len)];

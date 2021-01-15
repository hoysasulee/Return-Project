
%%%%%Usage ----------------------------------------------
%  SteepestDescent(functname,dvar0,niter,tol,lowbound,intvl,ntrials)
%  functname   :  where specific example can be found
%  dvar0       : initial guess for the design vector
%              : length of this vector defines number of variables
%  niter       : number of random Walk iterations
%  tol         : tolerance for golden section and steepest descent
%  lowbound    : for golden section and upper bound calculations
%  intv        :  for upper bound calculations
%  ntrials     : for upper bound calculations
%---------------------------------------------
%%%  Example
% SteepestDescent('Example1',[0 3],7, 0.0001, 0,1 ,20)
%
function ReturnValue = SteepestDescent(functname, ...
    dvar0,niter,tol,lowbound,intvl,ntrials)

%%%%%%%%%%%%     global    %%%%%%%%%%%%%
global xsd fsd asd convgsd lenXsd
%         can be used in calling program to print
%        iterative information if necessary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% management functions
clc    % position the cursor at the top of the screen
clf   %  closes the figure window
format compact  % avoid skipping a line when writing to the command window
warning off  % don't report any warnings like divide by zero etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nvar = length(dvar0); % length of design vector or number of variables
% obtained from start vector
if (nvar == 3)
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
    delx3 = 5;

    x1 = (dvar0(1)-delx1):0.1:(dvar0(1)+delx1);
    x2 = (dvar0(2)-delx2):0.1:(dvar0(2)+delx2);
    x3 = (dvar0(3)-delx3):0.1:(dvar0(3)+delx3);
 
    x1len = length(x1);
    x2len = length(x2);
    x3len = length(x3);
    %     [X1 X2 X3] = meshgrid(x1,x2,x3);
    %     Vfunctname = strcat('V',functname);
    %     fun = feval(Vfunctname,X1,X2,X3);
    for i = 1:x1len;
        for j = 1:x2len;
            for h = 1:x3len;
            x1x2x3 =[x1(i) x2(j) x3(h)];
            fun(j,i,h) = feval(functname,x1x2x3);
            end
        end
    end
    colormap(summer);
    %[c1,h1] = contourf(x1,x2,x3,fun,[20]);
    colorbar
    %clabel(c1); % remove labelling for clarity
    grid
    xlabel('x_1');
    ylabel('x_2');
    zlabel('x_3');
    funname = strrep(functname,'_','-');
    title(funname);

    % note that contour values are problem dependent
    % the range is problem dependent
    %**************************
    % finished plotting contour
    %***************************

end

%*********************
%  Numerical Procedure
%*********************
% design vector, alpha , and function value is stored
xsd(1,:) = dvar0;
x = dvar0;
Lc = 'r';
fsd(1) = feval(functname,x); % value of function at start
asd(1)=0;
s = -(gradfunction(functname,x)); % steepest descent

convgsd(1)=s*s';
lenXsd(1) = 0;
for i = 1:niter-1
    % determine search direction

    output = GoldSection_nVar(functname,tol,x, ...
        s,lowbound,intvl,ntrials);

    asd(i+1) = output(1);
    fsd(i+1) = output(2);
    for k = 1:nvar
        xsd(i+1,k)=output(2+k);
        x(k)=output(2+k);
    end
    s = -(gradfunction(functname,x)); 
    convgsd(i+1)=s*s';
    %***********
    % draw lines
    %************

    if (nvar == 2)
        line([xsd(i,1) xsd(i+1,1)],[xsd(i,2) xsd(i+1,2)],'LineWidth',2, ...
            'Color',Lc)
        itr = int2str(i);
        x1loc = 0.5*(xsd(i,1)+xsd(i+1,1));
        x2loc = 0.5*(xsd(i,2)+xsd(i+1,2));

        % text(x1loc,x2loc,itr);
        % writes iteration number on the line

        % alternates color of line for visual effect
        if strcmp(Lc,'r')
            Lc = 'k';
        else
            Lc = 'r';
        end
        pause(1)
        %***********************
        % finished drawing lines
        %***********************

    end
    %***************************************
    %  apply stopping criteria
    %****************************************
    delx = x - xsd(i,:);  % difference in the design vector
    lenXsd(i+1) = sqrt(sum(delx.^2));  % length of difference
    if(convgsd(i+1)<= tol)
        fprintf('Kuhn-Tucker Conditions met\n');
        break; end; % convergence criteria
    if(lenXsd(i+1)<= tol)
        fprintf('Exit: Design not changing\n');
        break; end; % convergence criteria
    if(i == niter-1)
        fprintf('Exit: Increase number of Iterations\n');
        break; end; % convergence criteria
end
zoom
len=length(asd);
%  recover final values to return
designvar=xsd(length(asd),:);
%%% return design information at the last iteration
ReturnValue = [designvar fsd(len)];
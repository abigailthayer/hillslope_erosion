% This code generates the hillslope evolution by soil creep and regolith
% production, of a convex hillslope with an incising stream at the base of
% each side.

% written by AGT 2/8/2016

clear all
figure(1)
clf

%% initialize 

%constants
rhor = 2700; %density of rock kg/m3
rhos = 1300; %density of soil kg/m3
w0 = 1e-4; %weathering rate, m/yr
k = 0.05*2000; %efficiency constant kg/(m*yr)
epsch = 0.5e-4; %erosion into channel (m/yr)
hstar = 0.3; 

% set up distance array
xmin = -300; %m
xmax = 300; 
dx = 2; 
x = xmin+(dx/2):dx:xmax-(dx/2); %so that the x value is in the middle of each 'box'
N = length(x); %number of 'boxes', one surrounding each distance in x array

% set up height array
zmin = -20; %m
zmax = 1200;
dz = 1;
z = zmin:dz:zmax;

% set up time array
tmax = 100000; %years
dt = 1;
t = 0:dt:tmax;

% define bedrock profile
slope0 = 0.05; %initial slope of each side
br = 15-slope0*abs(x); %equation for hill
brp=br; %saves initial hill profile

%define soil profile
h0 = 0.5; %initial soil height
h = h0*ones(size(x)); %array for soil height
hill = brp+h; %top of hill with soil

imax = length(t);
nplots = 100;
tplot = tmax/nplots;

%% run

for i = 1:imax

    wdot = w0 * exp(-h/hstar); %couples rate of eroion to soil height

    %conversion of rock to regolith
    dzdx = diff(hill)/dx; %slope of hill
    q = zeros(size(dzdx)); %creates empty array for soil flux
    q = -k*dzdx; %fills soil flux array
    q = [q(1) q q(end)]; %duplicates values at end of array to make it longer
    dhdt = ((rhor/rhos)*wdot) - ((1/rhos)*diff(q)); %change in soil height
    
    %calculate new profiles
    brp(2:end-1) = brp(2:end-1)-(wdot(2:end-1)*dt); %calculate new bedrock profile height
    h = h+(dhdt*dt); %calculate new soil height
    h = max(h,0); %keeps soil height from becoming negative
    
    brp(1) = brp(1)-(epsch*dt); %stream incision at left side, right side below
    brp(end) = brp(end)-(epsch*dt); 
    h(1) = 0; %set soil height at left side to 0, right side below
    h(end)=0;
    
    hill = brp+h; %calculate new hill height

    if(rem(t(i),tplot)==0)
        figure(1)
        plot(x,brp)
        hold on
        plot(x,hill)
        axis([-300 300 -6 16])
        time=num2str(t(i)); %convert time of each plot to 'letters'
        timetext=strcat(time,' years'); %add years to the time
        text(150,14,timetext,'fontsize',14) %shows time on each plot
        hold off
        pause(0.1)
    end

end














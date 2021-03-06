%% 2D Trajectory Comparison & Analysis
% 
%  Takes in 2D trajectory data (in the X and Z coordinate frame) from the
%  simout variable 'yout' for the PC_Quadcopter_Simulation.slx and compares
%  it to the commanded trajectory positions. MUST RUN SIM BEFORE USING THIS
%  SCRIPT.
%
%  TODO: -Completes error checking and determines if trajectory was satisfactory.
%        -Incoroprates time sensitive calculations
%        -??
%  
% written by Ethan Marcello
% last updated 31OCT19

%% Important display parameters:
ss = 3; %data display step size (larger number will display less data points)

%% 2D Trajectory import and data manipulation (time independent)

theta = yout(:,5); %pitch information
Thrust = (yout(:,13)+yout(:,14)+yout(:,15)+yout(:,16))/9000; %Value proportional to thrust. Not actual thrust.
X = yout(:,10);
Y = yout(:,11);
Z = yout(:,12);
X_cmd = yout(:,25);
Y_cmd = yout(:,26);
Z_cmd = yout(:,24);

load('hummTraj.mat'); %load in true hummingbird trajectory data (if needed for testing, but commanded path should be nearly the same)

fig = figure(1);
clf;
%fig.OuterPosition = [100 100 650 650]; %can adjust where figure shows up if desired
ax = axes;
ax.FontSize=12;
%ax.XTick = -10:2:7;
index = 1; %variable used to indicate start of humm traj flight
while(tout(index) < 15)
    index = index+1;
end
endi = index; %variable used to indicate end of the trajectory flight
while(yout(endi,25) ~= yout((endi+2),25))
    endi = endi+1;
    if(endi>=size(tout))
        endi = size(tout);
        break;
    end
end

hold on;
plot(X(index:ss:endi),Z(index:ss:endi),'bo','LineWidth',1.5); %state data X,Z
plot(X_cmd((index-1):ss:(endi-1)),Z_cmd((index-1):ss:(endi-1)),'r+','LineWidth',1.5); %commands data X,Z
%plot(hummTraj(:,2),hummTraj(:,3)+1,'c*','LineWidth',1.5); %actual hummingbird data (adds one to the Z coordinate to match sim height)
ax.DataAspectRatio = [1 1 1]; %equalizes scale on xy axis
grid on;

%Add thrust vectors using "quiver" function
%trim data
numVectors = 5;
splice = round(linspace(index,endi,numVectors)); %evenly spaces velocity vects throught
theta = theta(splice);
Thrust = Thrust(splice);
for numVectors = 1:5
    a = Thrust(numVectors)*cos(theta(numVectors));
    b = Thrust(numVectors)*sin(theta(numVectors));
    quiver(X(splice(numVectors)),Z(splice(numVectors)),b,a,0,'g','LineWidth',2); %displays vector
end

tit = title(path.name,'FontSize',20);
%NOTE: Thrust vectors are only proportional to thrust, and they are evenly
%spaced throughout the displayed dataset.
leg = legend('Path Flown','Path Commanded','Thrust Vector','FontSize',16);
xl = xlabel('X (m)','FontSize',16);
yl = ylabel('Z (m)','FontSize',16);

%% Error Calculations

xerr = X(index:endi)-X_cmd((index-1):(endi-1)); %errors in X over entire path
zerr = Z(index:endi)-Z_cmd((index-1):(endi-1)); %errors in Z over entire path
err_2D = sqrt(xerr.^2+zerr.^2); %2D distance errors over the entire path
avgerr_2D = mean(err_2D);
stderr_2D = std(err_2D); %std deviation of errors
maxerr_2D = max(err_2D);



% Control Flow
%   ask crystal type (monoclinic only for now)
%   ask for the beta angle
%   ask for the beta axes
%   plot crystal axes as vectors (don't show coordinate system), ask if correct (if not send to start)
%   ask for plane to rotate in
%   show now orientation in coordinate system, labeled like lab setup
%   display euler angles

correctPlot = true;
coordinateFun();

function coordinateFun()
% Establish crystal type
crystalType = 'We assume monoclinic crystal for now.';
disp(crystalType);

% Get offset angle
beta = input('What is the beta angle (in degrees)?: ');
adjustAngle = (beta - 90) * pi/180;

% Get which axes are offset
betaAxes = input('The beta angle is between which two crystal axes (input separated by commas)?: ','s');
betaAxes = strsplit(betaAxes,',');

if any(strcmp(betaAxes,'a')) && any(strcmp(betaAxes,'c'))
    q = quiver3([0,0,0],[0,0,0],[0,0,0],[0,1,0],[0,0,cos(adjustAngle)],[1,0,-sin(adjustAngle)],'LineWidth',1);
    text(0,0,1,'a'); text(1,0,0,'b'); text(0,cos(adjustAngle),-sin(adjustAngle),'c');
    xlabel('yL');ylabel('zL'),zlabel('xL');
    check = input('Is the plot correct (y/n)?: ','s');
    if check == 'n'
        disp('Starting over...');
        coordinateFun()
    end
elseif any(strcmp(betaAxes,'a')) && any(strcmp(betaAxes,'b'))
    q = quiver3([0,0,0],[0,0,0],[0,0,0],[0,0,cos(adjustAngle)],[0,1,0],[1,0,-sin(adjustAngle)],'LineWidth',1);
    text(0,0,1,'a'); text(cos(adjustAngle),0,-sin(adjustAngle),'b'); text(0,1,0,'c');
    xlabel('yL');ylabel('zL'),zlabel('xL');
    check = input('Is the plot correct (y/n)?: ','s');
    if check == 'n'
        disp('Starting over...');
        coordinateFun()
    end
elseif any(strcmp(betaAxes,'c')) && any(strcmp(betaAxes,'b'))
    q = quiver3([0,0,0],[0,0,0],[0,0,0],[0,1,-sin(adjustAngle)],[0,0,cos(adjustAngle)],[1,0,0],'LineWidth',1);
    text(0,0,1,'a'); text(1,0,0,'b'); text(-sin(adjustAngle),cos(adjustAngle),0,'c');
    xlabel('yL');ylabel('zL'),zlabel('xL');
    check = input('Is the plot correct (y/n)?: ','s');
    if check == 'n'
        disp('Starting over...');
        coordinateFun()
    end
end

rotationPlane = input('What plane do you want to rotate about the microwave B? (input separated by commas): ','s');
rotationAngle = input('Rotation angle, if any (in degrees): ');

planePossibilities = {'a,c','a*,c','a,c*','a,b','a*,b','a,b*','b,c','b*,c','b,c*'};

end

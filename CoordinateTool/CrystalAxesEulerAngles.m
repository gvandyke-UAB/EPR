
% This program generates the Euler angles that EasySpin uses to orient
% crystals. Before this existed, you had to figure them out by thinking
% about how to rotate the crystal's "z" axis, then the new "y" axis, then
% the even newer "z" axis. Now, the program allows us to only think about
% rotating the crystal IN THE LAB FRAME. Think about how you'd rotate a
% crystal if you held it in your hand: your head isn't moving with the
% crystal. This program achieves that same effect.


% create crystalAxes object
Crystal = crystalAxes([1,0,0],[0,1,0],[0,0,1]); % a, b, c order of args.
    % Sets a-axis as the x unit vector, b-axis as y unit vector, c-axis as
    % z unit vector. So it's not a monoclinic crystal yet.


% set orientation of axes relative to each other (beta angle adjustment)
Crystal = Crystal.adjustAxis('c','yL',-13);
    % "I want to rotate the current c-axis about the 'yL' axis -13 degrees"
    % Now it's a monoclinic crystal structure

    
% display 1
Crystal.showInitialAxesFigure();


% user confirmation
if ~userConfirmation('Is the base crystal orientation correct? (y/n): ')
    % if user says "n", stop program 
    return
else
end

% while loop asks user for rotation axis and angle
done = true;
while done
    
    % ask user
    labAxis = input('Rotate about which lab axis? (xL, yL, or zL): ','s');
    angle = input('By how many degrees?: ');

    % perform rotation
    Crystal = Crystal.rotateAxes(labAxis,angle);
    
    % display new crystal orientation
    Crystal.showFinalAxesFigure();
    
    % check if correct/more rotations necessary
    if ~userConfirmation('Is the rotated crystal orientation correct? (y/n): ')
    % if user says "n", stop program 
        return
    else
    % if user says "y", ask to do another rotation
        if ~askRotateAgain('Perform another rotation? (y/n): ')
        % if user says "n", terminate while loop
            done = false;
        end
        
    end

end

% returns the Euler angles (ready for EasySpin) for transforming original
% crystal (display 1) to rotated crystal (display 2)
eulZYZ = rotm2eul(Crystal.completeRotationMatrix,'ZYZ');

eulZYZ



%%%%%%%%%%% This section deals with rotations in the experiment %%%%%%%%%%%
%{

% ask user if there will be rotation during experiment
if ~userCheckForRotation('Will the crystal rotate in the experiment? (y/n): ',eulZYZ)
    % if user says "n", display Euler angles and stop program
    return
else
end


% if there is rotation i.e. taking spectra at multiple angles, then we
% return a bunch of Euler angles, each corresponding to one stop in the
% experiment. We assume the rotations are about the microwave magnetic
% field for now, but further customization is possible.

% ask user for the size of the angle interval
angleChunk = input('Step by how many degrees?: ');


% angle step for each spectra
numberOfSteps = 180/angleChunk;
round(numberOfSteps);

% preallocate space in eulZYZ
eulZYZ = [eulZYZ;zeros(numberOfSteps,3)];


for i = 1:(numberOfSteps+1)
    
    Crystal = Crystal.rotateAxes('xL',angleChunk);
        % the hard-coded "xL" here is me assuming the rotation will be
        % about the microwave magnetic field
        
    % uncomment these to see a crude animation of the crystal rotating    
    %Crystal.showFinalAxesFigure();
    %pause(.7);
    
    eulZYZ(i+1,:) = rotm2eul(Crystal.completeRotationMatrix,'ZYZ');
        % index starts at 2 bc eulZYZ already has one row filled
        
end

disp('The Euler angles (in radians) for each orientation are as follows:');
eulZYZ

%}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Function Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function feedback = userConfirmation(question)

correct = input(question,'s');
if strcmp(correct,'n')
    disp('Ending program, re-check input.');
    feedback = false;
elseif ~strcmp(correct,'y')
    disp('I need confirmation in either a "y" or an "n".');
    feedback = userConfirmation(question);
else
    feedback = true;
end

end

function feedback = userCheckForRotation(question,EulerAngles)

correct = input(question,'s');
if strcmp(correct,'n')
    disp(horzcat('The Euler angles (in radians) for your orientation are: ',mat2str(EulerAngles)));
    feedback = false;
elseif ~strcmp(correct,'y')
    disp('I need confirmation in either a "y" or an "n".');
    feedback = userCheckForRotation(question,EulerAngles);
else
    feedback = true;
end

end

function feedback = askRotateAgain(question)

correct = input(question,'s');
if strcmp(correct,'n')
    disp('Ending program, displaying Euler angles in radians.');
    feedback = false;
    return
elseif ~strcmp(correct,'y')
    disp('I need confirmation in either a "y" or an "n".');
    feedback = askRotateAgain(question);
else
    feedback = true;
end

end
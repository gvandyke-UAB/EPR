
% This program generates the Euler angles that EasySpin uses to orient
% crystals. Before this existed, you had to figure them out by thinking
% about how to rotate the crystal's "z" axis, then the new "y" axis, then
% the even newer "z" axis. Now, the program allows us to only think about
% rotating the crystal IN THE LAB FRAME. Think about how you'd rotate a
% crystal if you held it in your hand: your head isn't moving with the
% crystal. This program achieves that same effect.

% create crystal axis 
originalCrystal = crystalAxes([0,0,1],[1,0,0],[0,1,0]); % a, b, c order of args
    % to the computer, a is the z axis, b is the x axis, and c is the y
    % axis. We rename these 'xL', 'yL', and 'zL', respectively. We do it
    % this way so the plots visually correspond to the experiental setup,
    % hopefully making this tool more intuitive.

% set orientation of axes relative to each other (beta angle adjustment)
originalCrystal = originalCrystal.adjustAxes('c','yL',-13);
    % "I want to rotate the current c-axis about the 'yL' axis -13 degrees"

% display 1
originalCrystal.showit();

% user confirmation
if ~userconfirmation('Is the base crystal orientation correct? (y/n): ')
    return
else
end

% rotate whole crystal structure, keeping lab frame intact. You may stack
% as many rotations here as you like, as long as you remember to include those 
% matrix# outputs in the totalRotationMatrix variable below
[rotatedCrystal,matrix1] = originalCrystal.rotateAxes('zL',90);
[rotatedCrystal,matrix2] = rotatedCrystal.rotateAxes('yL',90);
    % "I want to align the microwave magnetic field with c*"

% display 2
rotatedCrystal.showit();

% user confirmation
if ~userconfirmation('Is the rotated crystal orientation correct? (y/n): ')
    return
else
end

% make the total rotation matrix
totalRotationMatrix = matrix2 * matrix1; % matrices in REVERSE order, important because they don't commute

% returns the Euler angles (ready for EasySpin) for transforming original crystal (display 1) to rotated
% crystal (display 2)
eulZYZ = rotm2eul(totalRotationMatrix,'ZYZ');

% ask user if there will be rotation during experiment (does nothing yet)
if ~userCheckForRotation('Will the crystal rotate in the experiment? (y/n): ',eulZYZ)
    return
else
end

% if there is rotation i.e. taking spectra at multiple angles, then we
% return a bunch of Euler angles, each corresponding to one stop in the
% experiment. We assume the rotations are about the microwave magnetic
% field for now, but further customization is possible.

% ask user how many stops we'll be making
N = input('How many spectra will we take between 0 and 180 degrees? (assuming evenly spaced intervals): ');

% angle step for each spectra
angleChunk = 180/(N-1);

% preallocate space in eulZYZ
eulZYZ = [eulZYZ;zeros(N-1,3)];

for i = 1:(N-1)
    
    [rotatedCrystal,stepMatrix] = rotatedCrystal.rotateAxes('xL',angleChunk);
    
    totalRotationMatrix = stepMatrix * totalRotationMatrix;
    
    eulZYZ(i+1,:) = rotm2eul(totalRotationMatrix,'ZYZ');
    
end

disp('The Euler angles for each orientation are as follows:');
eulZYZ


function feedback = userconfirmation(question)

correct = input(question,'s');
if correct == 'n'
    disp('Ending program, re-check input.');
    feedback = false;
elseif correct ~= 'y'
    disp('I need confirmation in either a "y" or an "n".');
    feedback = userconfirmation();
else
    feedback = true;
end

end

function feedback = userCheckForRotation(question,EulerAngles)

correct = input(question,'s');
if correct == 'n'
    disp(horzcat('The Euler angles (in radian) for your orientation are: ',mat2str(EulerAngles)));
    feedback = false;
elseif correct ~= 'y'
    disp('I need confirmation in either a "y" or an "n".');
    feedback = userCheckForRotation(question,EulerAngles);
else
    feedback = true;
end

end
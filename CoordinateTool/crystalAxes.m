classdef crystalAxes
    % crystalAxes stores axes data subject to rotations
      
    
    properties
        aAxis {mustBeNumeric}
        bAxis {mustBeNumeric}
        cAxis {mustBeNumeric}
    end
    
    methods
        function obj = crystalAxes(aVector,bVector,cVector)
            % Construct an instance of this class
            % Constructs by assigning axes
            % User specifies row vectors to represent the three crystal axes
            
            obj.aAxis = aVector; 
            obj.bAxis = bVector;
            obj.cAxis = cVector;
        end
        
        function adjustedAxes = adjustAxes(obj,axis,labAxis,angle)
            % Rotates a specified axis by angle (in degrees) about labAxis
            if strcmp(labAxis,'xL')
                rotationMatrix = rotz(angle);
                if strcmp(axis,'b')
                    col = rotationMatrix*obj.bAxis.';
                    obj.bAxis = col.';
                elseif strcmp(axis,'c')
                    col = rotationMatrix*obj.cAxis;
                    obj.cAxis = col.';
                end
            elseif strcmp(labAxis,'yL')
                rotationMatrix = rotx(angle);
                if strcmp(axis,'a')
                    col = rotationMatrix*obj.aAxis.';
                    obj.aAxis = col.';
                elseif strcmp(axis,'c')
                    col = rotationMatrix*obj.cAxis.';
                    obj.cAxis = col.';
                end
            elseif strcmp(labAxis,'zL')
                rotationMatrix = roty(angle);
                if strcmp(axis,'a')
                    col = rotationMatrix*obj.aAxis.';
                    obj.aAxis = col.';
                elseif strcmp(axis,'b')
                    col = rotationMatrix*obj.bAxis.';
                    obj.bAxis = col.';
                end
            end
           adjustedAxes = obj; 
        end
        
        function [rotatedAxes,overallRotationMatrix] = rotateAxes(obj,labAxis,angle)
            % rotates all 3 axes about labAxis by angle
            if strcmp(labAxis,'xL')
                rotationMatrix = rotz(angle);
                obj.aAxis = (rotationMatrix*obj.aAxis.').';
                obj.bAxis = (rotationMatrix*obj.bAxis.').';
                obj.cAxis = (rotationMatrix*obj.cAxis.').';
            elseif strcmp(labAxis,'yL')
                rotationMatrix = rotx(angle);
                obj.aAxis = (rotationMatrix*obj.aAxis.').';
                obj.bAxis = (rotationMatrix*obj.bAxis.').';
                obj.cAxis = (rotationMatrix*obj.cAxis.').';
            elseif strcmp(labAxis,'zL')
                rotationMatrix = roty(angle);
                obj.aAxis = (rotationMatrix*obj.aAxis.').';
                obj.bAxis = (rotationMatrix*obj.bAxis.').';
                obj.cAxis = (rotationMatrix*obj.cAxis.').';
            end
            rotatedAxes = obj;
            overallRotationMatrix = rotationMatrix;
        end
        
        function showit(obj)
            % this function is written purely beause quiver3 is ridiculous
            % and needs some preprocessing 
            xCoordinates = [obj.aAxis(1) obj.bAxis(1) obj.cAxis(1)];
            yCoordinates = [obj.aAxis(2) obj.bAxis(2) obj.cAxis(2)];
            zCoordinates = [obj.aAxis(3) obj.bAxis(3) obj.cAxis(3)];
            
            figure('NumberTitle', 'off', 'Name', 'Crystal Axes Euler Angle Tool');
            quiver3([0,0,0],[0,0,0],[0,0,0],xCoordinates,yCoordinates,zCoordinates,'LineWidth',1);
            xlabel('yL');ylabel('zL'),zlabel('xL');
            
            text(obj.aAxis(1),obj.aAxis(2),obj.aAxis(3),'a-axis');
            text(obj.bAxis(1),obj.bAxis(2),obj.bAxis(3),'b-axis');
            text(obj.cAxis(1),obj.cAxis(2),obj.cAxis(3),'c-axis');
            
            
        end
            
    end
end


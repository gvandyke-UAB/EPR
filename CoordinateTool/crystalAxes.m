classdef crystalAxes
    % crystalAxes stores axes data subject to rotations
      
    
    properties
        aAxisInitial {mustBeNumeric}
        bAxisInitial {mustBeNumeric}
        cAxisInitial {mustBeNumeric}
        aAxisFinal {mustBeNumeric}
        bAxisFinal {mustBeNumeric}
        cAxisFinal {mustBeNumeric}
        completeRotationMatrix = [1,0,0;0,1,0;0,0,1]; % starts as identity matrix
    end
    
    methods
        function obj = crystalAxes(aVector,bVector,cVector)
            % Construct an instance of this class
            % Constructs by assigning axes
            % User specifies row vectors to represent the three crystal axes
            
            obj.aAxisInitial = aVector;
            obj.bAxisInitial = bVector;
            obj.cAxisInitial = cVector;
            obj.aAxisFinal = aVector;
            obj.bAxisFinal = bVector;
            obj.cAxisFinal = cVector;
        end
        
        function adjustedAxes = adjustAxis(obj,axis,labAxis,angle)
            % Rotates a specified axis by angle (in degrees) about labAxis
            if strcmp(labAxis,'xL')
                rotationMatrix = rotx(angle);
                if strcmp(axis,'b')
                    obj.bAxisFinal = (rotationMatrix*obj.bAxisInitial.').';
                    obj.bAxisInitial = (rotationMatrix*obj.bAxisInitial.').';          
                elseif strcmp(axis,'c')
                    obj.cAxisFinal = (rotationMatrix*obj.cAxisInitial.').';
                    obj.cAxisInitial = (rotationMatrix*obj.cAxisInitial.').';
                end
            elseif strcmp(labAxis,'yL')
                rotationMatrix = roty(angle);
                if strcmp(axis,'a')                   
                    obj.aAxisFinal = (rotationMatrix*obj.aAxisInitial.').';
                    obj.aAxisInitial = (rotationMatrix*obj.aAxisInitial.').';
                elseif strcmp(axis,'c')                   
                    obj.cAxisFinal = (rotationMatrix*obj.cAxisInitial.').';  
                    obj.cAxisInitial = (rotationMatrix*obj.cAxisInitial.').';  
                end
            elseif strcmp(labAxis,'zL')
                rotationMatrix = rotz(angle);
                if strcmp(axis,'a')                   
                    obj.aAxisFinal = (rotationMatrix*obj.aAxisInitial.').';
                    obj.aAxisInitial = (rotationMatrix*obj.aAxisInitial.').';
                elseif strcmp(axis,'b')                  
                    obj.bAxisFinal = (rotationMatrix*obj.bAxisInitial.').';
                    obj.bAxisInitial = (rotationMatrix*obj.bAxisInitial.').';
                end
            end
           adjustedAxes = obj; 
        end
        
        function rotatedAxes = rotateAxes(obj,labAxis,angle)
            % rotates all 3 axes about labAxis by angle
            if strcmp(labAxis,'xL')
                rotationMatrix = rotx(angle);
                obj.aAxisFinal = (rotationMatrix*obj.aAxisFinal.').';
                obj.bAxisFinal = (rotationMatrix*obj.bAxisFinal.').';
                obj.cAxisFinal = (rotationMatrix*obj.cAxisFinal.').';
            elseif strcmp(labAxis,'yL')
                rotationMatrix = roty(angle);
                obj.aAxisFinal = (rotationMatrix*obj.aAxisFinal.').';
                obj.bAxisFinal = (rotationMatrix*obj.bAxisFinal.').';
                obj.cAxisFinal = (rotationMatrix*obj.cAxisFinal.').';
            elseif strcmp(labAxis,'zL')
                rotationMatrix = rotz(angle);
                obj.aAxisFinal = (rotationMatrix*obj.aAxisFinal.').';
                obj.bAxisFinal = (rotationMatrix*obj.bAxisFinal.').';
                obj.cAxisFinal = (rotationMatrix*obj.cAxisFinal.').';
            end
            obj.completeRotationMatrix = rotationMatrix * obj.completeRotationMatrix;
            rotatedAxes = obj;
        end
        
        function showInitialAxesFigure(obj)
            % this function is written purely beause quiver3 is ridiculous
            % and doesn't take in regular vector arguments
            
            close
            
            xCoordinates = [obj.aAxisInitial(1) obj.bAxisInitial(1) obj.cAxisInitial(1)];
            yCoordinates = [obj.aAxisInitial(2) obj.bAxisInitial(2) obj.cAxisInitial(2)];
            zCoordinates = [obj.aAxisInitial(3) obj.bAxisInitial(3) obj.cAxisInitial(3)];
            
            figure('NumberTitle', 'off', 'Name', 'Crystal Axes Euler Angle Tool');
            quiver3([0,0,0],[0,0,0],[0,0,0],xCoordinates,yCoordinates,zCoordinates,'LineWidth',1.5);
            xlabel('xL');ylabel('yL'),zlabel('zL');
            
            text(obj.aAxisInitial(1),obj.aAxisInitial(2),obj.aAxisInitial(3),'a-axis');
            text(obj.bAxisInitial(1),obj.bAxisInitial(2),obj.bAxisInitial(3),'b-axis');
            text(obj.cAxisInitial(1),obj.cAxisInitial(2),obj.cAxisInitial(3),'c-axis');
            
            view([127 30]);
            
        end
        
        function showFinalAxesFigure(obj)
            % this function is written purely beause quiver3 is ridiculous
            % and needs some preprocessing 
            
            close
            if isempty(obj.aAxisFinal)
                showInitialAxesFigure(obj)
            else
            xCoordinates = [obj.aAxisFinal(1) obj.bAxisFinal(1) obj.cAxisFinal(1)];
            yCoordinates = [obj.aAxisFinal(2) obj.bAxisFinal(2) obj.cAxisFinal(2)];
            zCoordinates = [obj.aAxisFinal(3) obj.bAxisFinal(3) obj.cAxisFinal(3)];
            
            figure('NumberTitle', 'off', 'Name', 'Crystal Axes Euler Angle Tool');
            quiver3([0,0,0],[0,0,0],[0,0,0],xCoordinates,yCoordinates,zCoordinates,'LineWidth',1.5);
            xlabel('xL');ylabel('yL'),zlabel('zL');
            
            text(obj.aAxisFinal(1),obj.aAxisFinal(2),obj.aAxisFinal(3),'a-axis');
            text(obj.bAxisFinal(1),obj.bAxisFinal(2),obj.bAxisFinal(3),'b-axis');
            text(obj.cAxisFinal(1),obj.cAxisFinal(2),obj.cAxisFinal(3),'c-axis');
            
            view([127 30]);
            
            end
            
        end
            
    end
end


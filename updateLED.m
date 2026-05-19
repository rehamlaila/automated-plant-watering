 %% LED Function
function functionLED = updateLED(a, LightPin, V, AveVolt)
if V > AveVolt
        % LED ON
        writeDigitalPin(a, LightPin, 1); 
        % return status
        functionLED = 1;                   
else
        % LED FF
        writeDigitalPin(a, LightPin, 0); 
        % return status
        functionLED = 0;                  
end
end
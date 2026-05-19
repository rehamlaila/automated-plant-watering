clear; 
close all;

% Initialize board and OLED
a = arduino("COM4", "Nano3", "Libraries", {"I2C"});
[Oled, a] = Initialize_Oled(a, 0);

% Assign pins
SoilPin   = "A1";
PumpPin   = "D2";
ButtonPin = "D6";
LightPin  = "D4";

% Calibration voltages
airVolt        = 3.5;
dryVolt        = 3.3;
wetVolt        = 2.9;
towelVolt      = 2.7;
clearWaterVolt = 2.6;

% Midpoint voltage
AveVolt = (dryVolt + wetVolt) / 2;

% Run unit test
results = runtests('MoistureTest.m');
disp(results);

% Start timers
startTime  = tic;
maxRuntime = 7 * 24 * 60 * 60;

% Live graph
figure;
LiveGraph = animatedline('Color', 'c', 'LineWidth', 1.5);
title("Moisture vs Time");
xlabel("Time [s]");
ylabel("Moisture (%)");
ylim([0 100]);
grid on;

stop = false;

writeDigitalPin(a, PumpPin, 0);
writeDigitalPin(a, LightPin, 0);

while ~stop
    
    T = toc(startTime);
    V = readVoltage(a, SoilPin);
    M = computeMoisture(V, dryVolt, wetVolt);

    addpoints(LiveGraph, T, M);
    drawnow;

    % 7-day shutdown
    if T >= maxRuntime
        writeDigitalPin(a, PumpPin, 0);
        writeDigitalPin(a, LightPin, 0);
        disp("7-DAY AUTO SHUTDOWN ACTIVATED.");
        display_write(Oled, 1, 1, 1, 128, 1, 8, 1, '7 DAY AUTO SHUTDOWN');
        stop = true;
        break;
    end

    % Emergency stop
    if readDigitalPin(a, ButtonPin) == 1
        writeDigitalPin(a, PumpPin, 0);
        writeDigitalPin(a, LightPin, 0);
        disp("EMERGENCY STOP INITIATED!");
        display_write(Oled, 1, 1, 1, 128, 1, 8, 1, 'EMERGENCY STOP');
        plotCharacterization(dryVolt, wetVolt, towelVolt, airVolt, clearWaterVolt);
        stop = true;
        break;
    end

    %  DRY STATE 
    if V >= dryVolt
        
        disp("Soil is dry! Pump ON.");
        display_write(Oled, 1, 1, 1, 128, 1, 8, 1, 'Pump ON');

        writeDigitalPin(a, PumpPin, 1);
        writeDigitalPin(a, LightPin, 1);

        waterTimer = tic;
        while toc(waterTimer) < 5
            
            T = toc(startTime);
            V = readVoltage(a, SoilPin);
            M = computeMoisture(V, dryVolt, wetVolt);

            addpoints(LiveGraph, T, M);
            drawnow;

            updateLED(a, LightPin, V, AveVolt);

            if readDigitalPin(a, ButtonPin) == 1
                writeDigitalPin(a, PumpPin, 0);
                writeDigitalPin(a, LightPin, 0);
                plotCharacterization(dryVolt, wetVolt, towelVolt, airVolt, clearWaterVolt);
                stop = true;
                break;
            end

            pause(0.1);
        end

        writeDigitalPin(a, PumpPin, 0);
        writeDigitalPin(a, LightPin, 0);

        % Wait 55 sec
        waitTimer = tic;
        while toc(waitTimer) < 55
            
            T = toc(startTime);
            V = readVoltage(a, SoilPin);
            M = computeMoisture(V, dryVolt, wetVolt);

            addpoints(LiveGraph, T, M);
            drawnow;

            updateLED(a, LightPin, V, AveVolt);

            if readDigitalPin(a, ButtonPin) == 1
                writeDigitalPin(a, PumpPin, 0);
                writeDigitalPin(a, LightPin, 0);
                plotCharacterization(dryVolt, wetVolt, towelVolt, airVolt, clearWaterVolt);
                stop = true;
                break;
            end

            pause(1);
        end

    % WET STATE 
    elseif V <= wetVolt
        
        writeDigitalPin(a, PumpPin, 0);
        writeDigitalPin(a, LightPin, 0);

        disp("Soil is wet. Pump OFF.");
        display_write(Oled, 1, 1, 1, 128, 1, 8, 1, 'Pump OFF');

        pause(1);

    %  MONITORING 
    else
        
        writeDigitalPin(a, PumpPin, 0);

        disp("Monitoring soil...");
        display_write(Oled, 1, 1, 1, 128, 1, 8, 1, 'Monitoring');

        updateLED(a, LightPin, V, AveVolt);
        pause(1);
    end
end

writeDigitalPin(a, PumpPin, 0);
writeDigitalPin(a, LightPin, 0);
disp("Program stopped safely.");
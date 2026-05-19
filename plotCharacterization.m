function plotCharacterization(dryVolt, wetVolt, towelVolt, airVolt, clearWaterVolt)
% PLOTCHARACTERIZATION Plots the sensor calibration curve
% Inputs:
%   dryVolt        - voltage for dry soil (30%)
%   wetVolt        - voltage for wet soil (70%)
%   towelVolt      - voltage for wet towel
%   airVolt        - voltage in air
%   clearWaterVolt - voltage in water

% Line equation (moisture mapping)
SlopeM = (70 - 30) / (wetVolt - dryVolt);
yintB = 70 - (SlopeM * wetVolt);

% Known calibration points
DVy = 30;   % dry soil
WVy = 70;   % wet soil

% Compute other points using line
TVy = towelVolt * SlopeM + yintB;
AVy = airVolt * SlopeM + yintB;
CWVy = clearWaterVolt * SlopeM + yintB;

% Plot
figure(2);
hold on;

% Plot points
plot(dryVolt, DVy, "b*", "MarkerSize", 10);
plot(wetVolt, WVy, "r*", "MarkerSize", 10);
plot(towelVolt, TVy, "cs", "MarkerSize", 10);
plot(airVolt, AVy, "ys", "MarkerSize", 10);
plot(clearWaterVolt, CWVy, "gs", "MarkerSize", 10);

% Plot characteristic line
plot([dryVolt, wetVolt], [DVy, WVy], "k-");

% Display equation
equation = sprintf("y = %.2fx + %.2f", SlopeM, yintB);
text(2.0, 45, equation, "FontSize", 11);

% Axis settings
ylim([0 100]);
yticks(0:10:100);
xlim([0 5]);
xticks(0:0.5:5);

% Labels and legend
xlabel("Sensor Output [Volt]");
ylabel("Moisture [%]");
legend("Dry Soil", "Wet Soil", "Wet Towel", "Air", ...
       "Glass of Water", "Characteristic Line");

grid on;
hold off;
end
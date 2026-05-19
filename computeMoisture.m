%% Moisture Function
function M = computeMoisture(V, dryVolt, wetVolt)
    % Convert voltage V into moisture percentage
    % Slope and intercept from your calibration
    SlopeM = (70 - 30) / (wetVolt - dryVolt);
    yintB = 70 - (SlopeM * wetVolt);
    % Calculate moisture percentage
    M = V * SlopeM + yintB;
    % Add limit for graph
    M = max(0, min(100, M));
end
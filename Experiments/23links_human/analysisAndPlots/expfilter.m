%% Simple Exponential Filtering
function smoothed_data = expfilter(input_data, alpha)
    
    smoothed_data = zeros(size(input_data));
    
    for col = 1:size(input_data, 2)
        
        smoothed_data(1, col) =  input_data(1, col);
        
        for row = 2:size(input_data, 1)
            
            smoothed_data(row, col) =  alpha * input_data(row, col) + (1 - alpha) * smoothed_data(row-1, col);
            
        end
        
    end

end

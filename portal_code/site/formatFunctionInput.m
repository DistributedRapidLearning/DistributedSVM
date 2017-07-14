function [functionInput] = formatFunctionInput(functionInput)
% convert variables from string to numeric values
functionInput.itNumber = str2double(functionInput.itNumber);
end
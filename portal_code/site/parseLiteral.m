function [ value ] = parseLiteral( dataType, value )
%PARSELITERAL Summary of this function goes here
%   Detailed explanation goes here

    switch char(dataType)
        case 'http://www.w3.org/2001/XMLSchema#int'
            value = str2num(strrep(value, ',', '.'));
        case 'http://www.w3.org/2001/XMLSchema#double'
            value = str2double(strrep(value, ',', '.'));
        otherwise
            warning(['no conversion defined for data-type: ' dataType]);
    end
    
end


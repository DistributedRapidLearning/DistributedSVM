function writeToLog(logText,functionInput)

logText = [logText '\r\n']; % always end line after string
fid = fopen(functionInput.pathToLogFile, 'a');
fprintf(fid, logText);
fclose(fid);

end
function pht_getTaskResult( registryLocation, siteId, taskId, itMasterDir )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    attempts = 100;
    waitTime = 5;
    
    iterationAttempt = 0;
    while iterationAttempt < attempts
        endpoint = [registryLocation '/client/' num2str(siteId) '/task/' num2str(taskId) '/result'];
        [binaryData, extra] = urlread2(endpoint,'GET');
        
        jsonResponse = loadjson(binaryData);

        if ~isempty(jsonResponse)
            siteOutput = jsonResponse{1}.response;

            if ~isempty(siteOutput)
                % Store response in DistOutput for the iteration
                storageLocation = fullfile(itMasterDir, ['DistOutput_' num2str(siteId) '.txt']);
                fid = fopen(storageLocation,'wt');
                fprintf(fid, siteOutput);
                fclose(fid);
                disp(['output for site ' num2str(siteId) ' stored'])
            end
            
            break;
        else
            disp(['could not read json in attempt ' num2str(iterationAttempt) ', will try again later'])
        end
        
        %pausing x seconds
        pause(waitTime)
        iterationAttempt = iterationAttempt+1;
    end
    
    if (attempts-1)==iterationAttempt
        disp(['Although many attempts have passed, could not read the result of task ' num2str(taskId) ' for site ' num2str(siteId)])
    end
end


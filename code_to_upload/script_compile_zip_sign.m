clear
clc
% Note: increase the pause() in case the compiler takes longer
%% user input
% path to the location of the repository on local machine
pathToRepository = '';
% path to the Varian File Signer on your local macine
pathToFileSigner = '';
% text file with password of the Varian File Signer provided by Varian (do not store in repository)
pathToFileSignerPassword = '';


%% construct path variables
masterPrjName = 'MasterExecutorLib.prj';
sitePrjName = 'SiteExecutorLib.prj';

% path to master prj 
pathToMainMaster = fullfile(pathToRepository,'portal_code','master',masterPrjName);

% path to site prj
pathToMainSite = fullfile(pathToRepository,'portal_code','site',sitePrjName);

% path to subfolder in the repository
pathToUploadFolder = fullfile(pathToRepository,'code_to_upload');

% path to temporary storage of packaging output (master)
pathToMasterPackagingOutput = fullfile(pathToRepository,'portal_code','master','MasterExecutorLib');
pathToMasterDll = fullfile(pathToMasterPackagingOutput,'for_redistribution_files_only','MasterExecutorLib.dll');
% path to temporary storage of packaging output (site)
pathToSitePackagingOutput = fullfile(pathToRepository,'portal_code','site','SiteExecutorLib');
pathToSiteDll = fullfile(pathToSitePackagingOutput,'for_redistribution_files_only','SiteExecutorLib.dll');
%% create .dlls for master and site and store in /code_to_upload/master and /code_to_upload/site
disp('Creating .dll for master...');
eval(['deploytool -package ' pathToMainMaster])% ...

disp('Creating .dll for sites...');
eval(['deploytool -package ' pathToMainSite])% ...

disp('Start pause() to wait for compilation')
pause(60)
disp('End pause() to wait for compilation')
%% move .dll to  /code_to_upload/master and /code_to_upload/site
copyfile(pathToMasterDll,fullfile(pathToUploadFolder,'master','MasterExecutorLib.dll'))
copyfile(pathToSiteDll,fullfile(pathToUploadFolder,'site','SiteExecutorLib.dll'))
%% delete unused output
rmdir(pathToMasterPackagingOutput,'s');
rmdir(pathToSitePackagingOutput,'s');
%% zip master and site folders as code_to_upload.zip
zip(fullfile(pathToUploadFolder,'code_to_upload.zip'),{fullfile(pathToUploadFolder,'master') fullfile(pathToUploadFolder,'site')})
% read file signer password
fileSignerPassword = fileread(pathToFileSignerPassword);
% sign .zip-file
dos([pathToFileSigner ' ' fullfile(pathToUploadFolder,'code_to_upload.zip') ' ' fileSignerPassword])

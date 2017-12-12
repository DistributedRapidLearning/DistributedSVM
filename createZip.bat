mkdir target
cd target

mkdir Master
mkdir Site

cd Master
copy ..\..\SourceCode\Master\algoExecutor\for_testing\algoExecutor.dll algoExecutor.dll
copy ..\..\mandatoryArtifacts\CATRBoostrap.exe CATRBoostrap.exe
copy ..\..\mandatoryArtifacts\MWArray.dll MWArray.dll
copy ..\..\mandatoryArtifacts\Description.xml Description.xml

cd ..\Site
copy ..\..\SourceCode\Site\algoExecutor\for_testing\algoExecutor.dll algoExecutor.dll
copy ..\..\mandatoryArtifacts\CATRBoostrap.exe CATRBoostrap.exe
copy ..\..\mandatoryArtifacts\MWArray.dll MWArray.dll
copy ..\..\SourceCode\Site\johanQuery.sparql johanQuery.sparql

cd ..\
7z a MakingZips.zip Master\ Site\

#!/bin/sh
echo 'Build Start'

cd AutoProject

#
buildDay=$(date +%Y%m%d)
buildTime=$(date +%Y%m%d%H%M)

profile="com.bx.CTCCShow"

#
buildConfiguration="QA"
buildPath="../ArchiveProduction/QA/${buildDay}/Auto_QA_${buildTime}.xcarchive"
ipaName="../ipa/QA/${buildDay}/Auto_QA_${buildTime}.ipa"

#
xctool -scheme AutoProject -configuration ${buildConfiguration} clean
xctool -scheme AutoProject -configuration ${buildConfiguration} archive -archivePath ${buildPath}
xcodebuild -exportArchive -exportFormat IPA -archivePath ${buildPath} -exportPath ${ipaName} -exportProvisioningProfile “$profile"

echo 'Build End'


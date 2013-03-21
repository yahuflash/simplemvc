#!/bin/bash
 
# chmod u+x deploy-to-device.sh
# ./deploy-to-device game.apk
# ./deploy-to-device game.ipa

# update these paths so that they point to the AIR SDK
adt="/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/4.6.0/bin/adt"
adb="/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/4.6.0/lib/android/bin/adb"
 
if [ ${1: -4} == ".ipa" ]
then
    "$adt" -installApp -platform ios -package $1
else
    "$adb" install -r $1
fi
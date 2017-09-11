#!/bin/bash

# Copyright (c) 2017 Benjamin W. Bohl

echo
echo "======="
echo "|bwbEO|"
echo "======="
echo "Copyright (c) 2017 Benjamin W. Bohl"
echo
echo "Starting initialization of your bwbEO copy."
echo "-------------------------------------------"
echo
echo "You will be prompted for the following properties of your Edirom application:"
echo "* Application name (brandFullName), e.g. MY-LONG-EDITION-NAME vol. 1"
echo "* Application short name (brandShortName), e.g. MLEN vol. 1"
echo "* Application version (brandVersion), e.g. 1.0.0"
echo "* Contents copyright holder (vendorShortName), e.g. MY-PROJECT-NAME"
echo "* Copyright statement, e.g. 2017 bwbohl"
echo "* Copyright holder website (vendorUrl), e.g. http://www.my-project-name.com"
echo "* Application-logo copyright (logoCopyright), e.g. ©2017 COPYRIGHT-HOLDER. All rights reserved."
echo
echo "The prompt includes the default value in parenthesis. Hit enter to keep this or type any new value."
read -n 1 -s -p "Press any key to continue…"

echo
echo
read -p "Application name (bwbEO): " name
name=${name:-bwbEO}
echo $name
id=$(sed -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ /abcdefghijklmnopqrstuvwxyz-/' <<< $name)
echo
echo "id: $id"

echo
read -p "Short name ($name): " shortname
shortname=${shortname:-$name}
echo $shortname

echo
read -p "Version (1.0.0): " version
version=${version:-1.0.0}
echo $version

echo
read -p "Copyright holder (bwbohl): " vendor
vendor=${vendor:-bwbohl}
echo $vendor

#copyright statement
echo
copyright_default="© $(date +'%Y') $vendor"
read -p "Copyright statement ($copyright_default): " copyright
copyright=${copyright:-$copyright_default}
echo $copyright

echo
read -p "Copyright holder website (http://www.example.com): " www
www=${www:-http\:\/\/www.example.com}
echo $www

echo
logo_default="$copyright_default. All rights reserved."
read -p "Logo copyright ($logo_default): " logo
logo=${logo:-$logo_default}
echo $logo


foldername="$(date +%Y%m%d%H%M)-$shortname"
echo
echo "Your settings will be saved to ./build/$foldername/"
echo
read -n 1 -s -p "Press any key to continue…"

#setup build folders
mkdir -p ./build
mkdir -p ./build/"$foldername"
mkdir ./build/"$foldername"/assets
mkdir ./build/"$foldername"/assets/branding
mkdir ./build/"$foldername"/assets/branding/locale/

#assets/application.ini
touch ./build/"$foldername"/assets/application.ini
echo "[App]" >> ./build/"$foldername"/assets/application.ini
echo "Vendor=$vendor" >> ./build/"$foldername"/assets/application.ini
echo "Name=$name" >> ./build/"$foldername"/assets/application.ini
echo "Version={{VERSION}}" >> ./build/"$foldername"/assets/application.ini
echo "BuildID={{BUILDID}}" >> ./build/"$foldername"/assets/application.ini
echo "Copyright=Copyright (c) $(date +%Y) $vendor" >> ./build/"$foldername"/assets/application.ini
echo "ID=$id" >> ./build/"$foldername"/assets/application.ini
echo >> ./build/"$foldername"/assets/application.ini
echo "[Gecko]" >> ./build/"$foldername"/assets/application.ini
echo "MinVersion=5.0" >> ./build/"$foldername"/assets/application.ini #check if this is still true
echo "MaxVersion=22.*" >> ./build/"$foldername"/assets/application.ini #check if this is still true
echo >> ./build/"$foldername"/assets/application.ini
echo "[XRE]" >> ./build/"$foldername"/assets/application.ini
echo "EnableExtensionManager=0" >> ./build/"$foldername"/assets/application.ini
echo "EnableProfileMigrator=0" >> ./build/"$foldername"/assets/application.ini


#assets/branding/locale/brand.dtd
touch ./build/"$foldername"/assets/branding/locale/brand.dtd

echo '<!ENTITY  brandFullName        "'$name'">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd
echo '<!ENTITY  brandShortName       "'$shortname'">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd
echo '<!ENTITY  brandVersion         "'$version'">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd
echo '<!ENTITY  vendorShortName      "'$vendor'">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd
echo '<!ENTITY  vendorUrl            "'$www'">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd
echo '<!ENTITY  softwareName         "Edirom Online">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd
echo '<!ENTITY  logoCopyright        "'$logo'">' >> ./build/"$foldername"/assets/branding/locale/brand.dtd

#assets/branding/locale/brand.properties
touch ./build/"$foldername"/assets/branding/locale/brand.properties

echo "brandFullName=$name" >> ./build/"$foldername"/assets/branding/locale/brand.properties
echo "brandShortName=$shortname" >> ./build/"$foldername"/assets/branding/locale/brand.properties
echo "vendorShortName=$vendor" >> ./build/"$foldername"/assets/branding/locale/brand.properties

#chrome.manifest
## no changes

# assets/prefs.js
echo
echo "copy prefs.js"
cp ./submodules/webapp-xul-wrapper/assets/prefs.js ./build/"$foldername"/assets

#write sed commands
echo
echo "Writing sed_command-file.txt"
echo "" > sed_command-file.txt
echo "s/Zotero/Edirom Online/g" >> sed_command-file.txt
echo 's/pref("toolkit.defaultChromeURI", "chrome:\/\/app\/content\/ui\/main.xul");/pref("toolkit.defaultChromeURI", "chrome:\/\/edirom-online\/content\/ui\/main.xul");/g' >> sed_command-file.txt
echo 's/pref("browser.chromeURL", "chrome:\/\/app\/content\/ui\/basicViewer.xul");/\/\/pref("browser.chromeURL", "chrome:\/\/app\/content\/ui\/basicViewer.xul");/g' >> sed_command-file.txt
# TODO app.update.urls
echo 's/pref("network.protocol-handler.warn-external.http", false);/\/\/pref("network.protocol-handler.warn-external.http", false);/g' >> sed_command-file.txt
echo 's/pref("network.protocol-handler.warn-external.https", false);/\/\/pref("network.protocol-handler.warn-external.https", false);/g' >> sed_command-file.txt
echo 's/pref("network.protocol-handler.warn-external.ftp", false);/\/\/pref("network.protocol-handler.warn-external.ftp", false);/g' >> sed_command-file.txt

echo "customizing prefs.js…"
sed -i '' -f sed_command-file.txt ./build/"$foldername"/assets/prefs.js


# TODO updater.ini

# TODO icons

# mac/edirom-online
mkdir ./build/"$foldername"/mac
#touch ./build/"$foldername"/mac/edirom-online

echo "#!/bin/bash" > ./build/"$foldername"/mac/edirom-online
echo 'CALLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"' >> ./build/"$foldername"/mac/edirom-online
echo '"$CALLDIR/edirom-online-bin" "$CALLDIR/../Resources/application.ini" "$@"' >> ./build/"$foldername"/mac/edirom-online

chmod +x ./build/"$foldername"/mac/edirom-online

#mac/contents
mkdir ./build/"$foldername"/mac/Contents
##PkgInfo
echo "APPLedon" > ./build/"$foldername"/mac/Contents/PkgInfo
##Info.plist
## TODO InfoString
## TODO BundleIdentifier
## TODO BundleSignature

#config.sh
echo
echo "copying config.sh…"
cp ./submodules/webapp-xul-wrapper/config.sh ./build/"$foldername"/config.sh

#write sed commands
echo
echo "Writing sed_command-file.txt"
echo "" > sed_command-file.txt
echo "s/SIGN=1/SIGN=0/g" >> sed_command-file.txt
echo "s/MODULE=\"app\"/MODULE=\"edirom-online\"/g" >> sed_command-file.txt
echo "s/WEBAPPMODULE=\"kitchensink\/dist\/\"/WEBAPPMODULE=\"jetty\/\"/g"  >> sed_command-file.txt
echo "s/APPNAME=\"Webapp XUL Wrapper\"/APPNAME=\"$name\"/g"  >> sed_command-file.txt
echo "s/PACKAGENAME=\"webapp-xul-wrapper\"/PACKAGENAME=\"$id\"/g"  >> sed_command-file.txt
echo "s/DEFAULT_VERSION_PREFIX=\"0.0.0.SOURCE.\"/DEFAULT_VERSION_PREFIX=\"$version.SOURCE.\"/g" >> sed_command-file.txt
echo "s/VERSION_NUMERIC=\"0.0.0\"/VERSION_NUMERIC=\"$version\"/g" >> sed_command-file.txt

echo "customizing config.sh…"
# TODO BRIDGESCRIPTS
sed -i '' -f sed_command-file.txt build/"$foldername"/config.sh

read -n 1 -s -p "Press any key to continue…"

echo
echo "done."

#copy files to webapp-xul-wrapper submodule
echo "copying files to  webapp-xul-wrapper"
echo
cp -R -v ./build/"$foldername"/* ./submodules/webapp-xul-wrapper

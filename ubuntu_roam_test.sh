#!/bin/sh
#
# ubuntu_roam_test.sh - Script to report current Wi-Fi connection info and indicate when roams occur
#
# V0.1 - N.Bowden 15th Jan 2018 - Initial version
# V0.2 - N.Bowden 15th Jan 2018 - Minor updates following field test
#
# Run on CLI (terminal window) : . ./ubuntu_roam_test.sh
#
# Output of script:
#
# "BSSID, SSID, Signal_Level_dBm, Channel, Time"
# "bssid_addr, ssid_name, sig_level, channel_number, timestamp"
# "bssid_addr, ssid_name, sig_level, channel_number, timestamp"
# "bssid_addr, ssid_name, sig_level, channel_number, timestamp"
#
# ------------------------------------------------------------------------


# Set the name of your Wi-FI NIC below (use output from iwconfig, e.g.wlan0)
WIFINIC="wlan0"

# List all of our Wi-Fi channels to lookup from the frequency we gather in the output of the "iwconfig" command
declare -A CHANNELS=(
['2.412']='01'
['2.417']='02'
['2.422']='03'
['2.427']='04'
['2.432']='05'
['2.437']='06'
['2.442']='07'
['2.447']='08'
['2.452']='09'
['2.457']='10'
['2.462']='11'
['2.467']='12'
['2.472']='13'
['5.18']='36'
['5.2']='40'
['5.22']='44'
['5.24']='48'
['5.26']='52'
['5.28']='56'
['5.3']='60'
['5.32']='64'
['5.5']='100'
['5.52']='104'
['5.54']='108'
['5.56']='112'
['5.58']='116'
['5.6']='120'
['5.62']='124'
['5.64']='128'
['5.66']='132'
['5.68']='136'
['5.7']='140'
['5.72']='144'
['5.745']='149'
['5.765']='153'
['5.785']='157'
['5.805']='161'
['5.825']='165'
)

LAST_BSSID='blank'

# Output headers
echo "BSSID, SSID, Signal_Level_dBm, Freq_GHz, Channel, Time"

while [ 1 ]
do

 # pull out the fields we need with grep
 RFINFO=(`/sbin/iwconfig $WIFINIC  | grep -oP '(?<=Signal level=)(.*)(?= dBm)|(?<=ESSID:")(.*)(?=")|(?<=Access Point: )(..:..:..:..:..:..)|(?<=Frequency:)(.*)(?= GHz)'`)


 SSID=${RFINFO[0]}
 FREQ=${RFINFO[1]}
 BSSID=${RFINFO[2]}
 RSSI=${RFINFO[3]}
 CHANNEL=${CHANNELS[$FREQ]}
 CURRENT_TIME=`date +%H:%M:%S`

 NEW_BSSID=''

 if [ $BSSID != $LAST_BSSID ]
 then
   NEW_BSSID="*"
 fi

 # output the data we have extracted from the iwconfig command, in csv format (for easy analysis)
 echo "$NEW_BSSID$BSSID, \"$SSID\", $RSSI, ${FREQ}, $CHANNEL, $CURRENT_TIME"

 LAST_BSSID=$BSSID

 # take a nap for a second before we loop again
 sleep 1

# end of while loop
done

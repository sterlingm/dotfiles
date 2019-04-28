cd ~/qmk_firmware
NEXT_WAIT_TIME=0
until avrdude -p atmega32u4 -P /dev/ttyACM0 -c avr109 -U flash:w:handwired_dactyl_manuform_5x6_sterlingm.hex || [ $NEXT_WAIT_TIME -eq 5 ]; do
  sleep 1
  NEXT_WAIT_TIME=$((NEXT_WAIT_TIME+1))
done
cd ~

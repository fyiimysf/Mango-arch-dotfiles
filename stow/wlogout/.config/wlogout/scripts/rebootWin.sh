#!/bin/bash
pas="jkl;'#"
WINDOWS_TITLE=`grep -i "^menuentry 'Windows" /boot/grub/grub.cfg|head -n 1|cut -d"'" -f2`
echo $pas | sudo -S -k grub-reboot "$WINDOWS_TITLE"
echo $pas | sudo -S -k reboot

# sudo -S <<< "password" command

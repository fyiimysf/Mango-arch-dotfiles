#!/bin/bash
p=""
WINDOWS_TITLE=`grep -i "^menuentry 'Windows" /boot/grub/grub.cfg|head -n 1|cut -d"'" -f2`
echo $p | sudo -S -k grub-reboot "$WINDOWS_TITLE"
echo $p | sudo -S -k reboot

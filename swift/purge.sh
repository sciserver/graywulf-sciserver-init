# purge storage

IFS=',' read -ra DEVS <<< "$SS_OS_SWIFT_DEV"
for DEV in "${DEVS[@]}"; do
  echo Purging $DEV
  umount /dev/${DEV}1
  echo "d
w
" | fdisk /dev/$DEV
  rm -R /srv/node/${DEV}1
  cat /etc/fstab | sed "/$DEV/d" > /etc/fstab.tmp
  rm /etc/fstab
  mv /etc/fstab.tmp /etc/fstab
done


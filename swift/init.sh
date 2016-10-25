# configure storage

modprobe xfs

IFS=',' read -ra DEVS <<< "$SS_OS_SWIFT_DEV"
for DEV in "${DEVS[@]}"; do
  echo Initializing $DEV
  echo "n
p
1


w
" | fdisk /dev/$DEV
  mkdir -p /srv/node/${DEV}1
  mkfs.xfs -f /dev/${DEV}1
  echo "/dev/${DEV}1 /srv/node/${DEV}1 xfs noatime,nodiratime,nobarrier,logbufs=8 0 0" >> /etc/fstab
done
              
mount -a
chown -R swift:swift /srv/node

# generate config files

subsenv SS_OS_ swift/proxy-server.conf > /etc/swift/proxy-server.conf
subsenv SS_OS_ swift/account-server.conf > /etc/swift/account-server.conf
subsenv SS_OS_ swift/container-server.conf > /etc/swift/container-server.conf
subsenv SS_OS_ swift/object-server.conf > /etc/swift/object-server.conf

# open port for proxy

iptables -I INPUT 1 -p tcp --dport $SS_OS_SWIFT_PROXY_PORT -j ACCEPT

# generate service account in keystone

source $HOME/admin-openrc.sh

openstack user create "$SS_OS_KEYSTONE_SWIFT_USER" \
  --password "$SS_OS_KEYSTONE_SWIFT_PASS" \
  --project "$SS_OS_KEYSTONE_SERVICE_PROJECT"
openstack role add admin \
  --project "$SS_OS_KEYSTONE_SERVICE_PROJECT" \
  --user "$SS_OS_KEYSTONE_SWIFT_USER"
openstack service create object-store \
  --name swift \
  --description "Swift Service"
                
openstack endpoint create \
  --region sciserver object-store \
  public 'http://scidev09:8081/v1/AUTH_%(tenant_id)s' 
openstack endpoint create \
  --region sciserver object-store \
  internal 'http://scidev09:8081/v1/AUTH_%(tenant_id)s' 
openstack endpoint create \
  --region sciserver object-store \
  admin 'http://scidev09:8081' 



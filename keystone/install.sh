yum -y install openstack-keystone
yum -y install python-keystoneclient python-keystonemiddleware python-openstackclient

# configure apache

ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

iptables -I INPUT 1 -p tcp --dport 5000 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 35357 -j ACCEPT

systemctl restart httpd.service


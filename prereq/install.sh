setenforce 0

# install and start mysql (or mariadb)

yum -y install mysql-server
systemctl enable mariadb.service
systemctl start mariadb.service
iptables -I INPUT 1 -p tcp --dport 3306 -j ACCEPT

# install and start httpd

yum -y install httpd mod_wsgi
systemctl enable httpd.service
systemctl start httpd.service

# install and run rabbitmq

yum -y install rabbitmq-server
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service	
iptables -I INPUT 1 -p tcp --dport 5672 -j ACCEPT

# install memcached and rsync etc.

yum -y install memcached xfsprogs rsync
systemctl enable memcached.service
systemctl start memcached.service
systemctl enable rsyncd.service
systemctl start rsyncd.service

# openstack repo

sudo yum install -y https://www.rdoproject.org/repos/rdo-release.rpm


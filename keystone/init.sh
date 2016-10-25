# generate config file

cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.orig
subsenv SS_OS_ keystone/keystone.conf > /etc/keystone/keystone.conf

# create database

mysql -e "CREATE DATABASE $SS_OS_KEYSTONE_DB;"
mysql -e "GRANT ALL ON $SS_OS_KEYSTONE_DB.* TO '$SS_OS_KEYSTONE_DB_USER'@'%' IDENTIFIED BY '$SS_OS_KEYSTONE_DB_PASS';"
mysql -e "GRANT ALL ON $SS_OS_KEYSTONE_DB.* TO '$SS_OS_KEYSTONE_DB_USER'@'localhost' IDENTIFIED BY '$SS_OS_KEYSTONE_DB_PASS';"

# initialize schema

keystone-manage db_sync

# create admin config file and source it

subsenv SS_OS_KEYSTONE_TEST keystone/test-openrc.sh > $HOME/test-openrc.sh
subsenv SS_OS_KEYSTONE_ADMIN keystone/admin-openrc.sh > $HOME/admin-openrc.sh

source $HOME/admin-openrc.sh

# bootstrap keystone

keystone-manage bootstrap \
  --bootstrap-password "$SS_OS_KEYSTONE_ADMIN_PASS" \
  --bootstrap-username "$SS_OS_KEYSTONE_ADMIN_USER" \
  --bootstrap-project-name "$SS_OS_KEYSTONE_ADMIN_USER" \
  --bootstrap-role-name "$SS_OS_KEYSTONE_ADMIN_USER" \
  --bootstrap-service-name "$SS_OS_KEYSTONE_SERVICE" \
  --bootstrap-region-id "$SS_OS_KEYSTONE_REGION" \
  --bootstrap-admin-url http://$HOSTNAME:35357 \
  --bootstrap-public-url http://$HOSTNAME:5000 \
  --bootstrap-internal-url http://$HOSTNAME:5000

openstack project create "$SS_OS_KEYSTONE_SERVICE_PROJECT"
openstack user create "$SS_OS_KEYSTONE_SERVICE_USER" \
  --password "$SS_OK_KEYSTONE_SERVICE_PASS" \
  --project "$SS_OS_KEYSTONE_SERVICE_PROJECT"
openstack role add "admin" \
  --project "$SS_OS_KEYSTONE_SERVICE_PROJECT" \
  --user "$SS_OS_KEYSTONE_SERVICE_USER"

# create default role
								 
openstack role create "$SS_OS_KEYSTONE_ROLE_DEFAULT"
openstack role create "$SS_OS_KEYSTONE_ROLE_USER"

# create test account

openstack project create "$SS_OS_KEYSTONE_TEST_USER"
openstack user create "$SS_OS_KEYSTONE_TEST_USER" \
  --password "$SS_OS_KEYSTONE_TEST_PASS" \
  --project "$SS_OS_KEYSTONE_TEST_USER"
openstack role add "$SS_OS_KEYSTONE_ROLE_DEFAULT" \
  --project "$SS_OS_KEYSTONE_TEST_USER" \
  --user "$SS_OS_KEYSTONE_TEST_USER"
openstack role add "$SS_OS_KEYSTONE_ROLE_USER" \
  --project "$SS_OS_KEYSTONE_TEST_USER" \
  --user "$SS_OS_KEYSTONE_TEST_USER"
	


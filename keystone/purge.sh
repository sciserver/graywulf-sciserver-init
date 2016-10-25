. ../config.sh

# drop keystone database

mysql -e "DROP DATABASE $SS_OS_KEYSTONE_DB;"

# drop generated files

rm $HOME/admin-openrc.sh
rm $HOME/test-openrc.sh






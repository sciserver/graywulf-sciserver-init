# create database

mysql -e "CREATE DATABASE $SS_SCIDRIVE_DB;"
mysql -e "GRANT ALL ON $SS_SCIDRIVE_DB.* TO '$SS_SCIDRIVE_USER'@'%' IDENTIFIED BY '$SS_SCIDRIVE_PASS';"
mysql -e "GRANT ALL ON $SS_SCIDRIVE_DB.* TO '$SS_SCIDRIVE_USER'@'localhost' IDENTIFIED BY '$SS_SCIDRIVE_PASS';"

# initialize schem

mysql "$SS_SCIDRIVE_DB" < scidrive/scidrive.sql


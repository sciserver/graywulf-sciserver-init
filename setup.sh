source config.sh
source lib.sh

verb=$1
comp=$2

if [[ $verb == "help" ]]
then
  echo "usage: setup.sh <verb> <component>"
  echo "  verbs:      install"
  echo "              init"
  echo "              start"
  echo "              stop"
  echo "              remove"
  echo "              purge"
  echo "  components: all"
  echo "              prereq"
  echo "              keystone"
  echo "              swift"
  echo "              scidrive"
elif [[ $comp == "all" ]]
then
  echo "Selected all components"
  for comp in "prereq" "keystone" "swift" "scidrive"
  do
    cmd=$comp/$verb.sh
    if [ -e $cmd ]
      then
      eval source $cmd
    fi
  done
else
  cmd=$comp/$verb.sh
  if [ -e $cmd ]
  then
    eval source $cmd
  fi
fi

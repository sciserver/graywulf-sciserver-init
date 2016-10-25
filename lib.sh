function subsenvcmd {
  prefix=$1
  infile=$2

  echo -n "cat $infile | sed"

  env | cut -d'=' -f 1 | grep $prefix | while read line; do
    echo -n " -e \"s/%$line%/\$$line/\""
  done
}

function subsenv {
  eval $(subsenvcmd $1 $2)
}


#!/usr/bin/env bash

function budir {
	date_bin="/bin/date"
	cp_bin="/bin/cp"
	basename_bin="/usr/bin/basename"

	date=`$date_bin +%d%m%y-%H%M%S`
   dest_suffix=""
   suffix_counter=0

	len="${#1}"

	if [ "$len" -eq "0" ];
	then
		echo "Usage: budir DIRECTORY"
	else
		basename=`$basename_bin $1`
      dest_prefix="$basename.$date"
      dest_found=0

      # Loop until dest directory doesn't exists
      while [ $dest_found == 0 ]
      do
         dest=$dest_prefix$dest_suffix

         if [ -e $dest ];
         then
            let suffix_counter++
            dest_suffix="-"$suffix_counter
         else
            dest_found=1
         fi
      done

		echo "Copying $1 to $dest"

		$cp_bin -r $1 $dest
	fi
}

function bcc {
   bc_bin=`which bc`

   echo "scale=5; $1" | $bc_bin 
}

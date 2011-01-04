#!/usr/bin/env bash

# Backup directory
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

# Call bc with arguments
function bcc {
   bc_bin=$(which bc)

   echo "scale=5; $1" | $bc_bin 
}

# Reminder to use sudoedit instead of sudo vim
function sudo {
   if [ "$1" == "vim" ]; then
      echo "Use sudoedit instead."
      return 1
   fi

   sudo_bin=$(which sudo)
   $sudo_bin $@
}

# Show cdable directories
function cdable {
   local cdable_file="$HOME/.bash_cdable"
   local grep_bin=$(which grep)
   local awk_bin=$(which awk)

   if [ -f $cdable_file ]; then
      $grep_bin "export" $cdable_file | $awk_bin '{print $2}'
   else
      echo "File '$cdable_file' doesn't exist."
   fi
}

# Open browser
function ob {
   local browser=$(which firefox)
   $browser "$(pwd)/$@"
}

# Find java classes by name
function fj {
  local find_bin=$(which find)
  $find_bin . -iname "$1*.java"
}

# Find java classes by name and open them in vim
function fjv {
  local find_bin=$(which find)
  local vim_bin=$(which vim)

  $find_bin . -iname "$1*.java" -exec "${vim_bin}" {} +
}

# Compare file to stdout with vimdiff.
function vimdifff() {
   local vim_bin=$(which vim)

   $vim_bin - -c ":vnew $1 | windo diffthis"
}

# Extract file
function e()
{
   local file=$1
   local list=0

   if [ -z "${file}" ]; then
      return 1
   fi

   if [ "$1" == "-t" ]; then
      if [ -z $2 ]; then
         return 1
      else
         list=1
         file=$2
      fi
   else
      file=$1
      list=0
   fi

   if [ -f "${file}" ] ; then
      if [ ${list} -eq 0 ]; then
         case "${file}" in
            *.tar.bz2 | *.tbz2)    tar xvjf "${file}"     ;;
            *.tar.gz | *.tgz)      tar xvzf "${file}"     ;;
            *.tar)                 tar xvf "${file}"      ;;
            *.bz2)                 bunzip2 "${file}"      ;;
            *.gz)                  gunzip "${file}"       ;;
            *.rar | *.r00)         unrar x "${file}"      ;;
            *.zip)                 unzip "${file}"        ;;
            *.jar | *.ear | *.war) jar -vxf "${file}"     ;;
            *)           echo "Don't know how to extract file '${file}'" ;;
        esac
     else
         case "${file}" in
            *.tar.bz2 | *.tbz2)    tar tvjf "${file}"     ;;
            *.tar.gz | *.tgz)      tar tvzf "${file}"     ;;
            *.tar)                 tar tvf "${file}"      ;;
            *.rar | *.r00)         unrar l "${file}"      ;;
            *.zip)                 unzip -l "${file}"     ;;
            *.jar | *.ear | *.war) jar -vtf "${file}"     ;;
            *)           echo "Don't know how to list files from '${file}'" ;;
         esac
     fi
  else
     echo "'${file}' is not a valid file."
     return 1
  fi
}

# Change keyboard layout between us and finnish
function change_layout() {
   SETXKBMAP_BIN=$(which setxkbmap)
   XMODMAP_BIN=$(which xmodmap)
   GREP_BIN=$(which grep)
   AWK_BIN=$(which awk)

   cur_layout=$($SETXKBMAP_BIN -print | $GREP_BIN "xkb_symbols" | $AWK_BIN '{ print $4 }' | $AWK_BIN -F"+" '{print $2}')

   if [ "$cur_layout" != "us" ]; then
      $SETXKBMAP_BIN -layout us
   else
      $SETXKBMAP_BIN -layout fi
   fi

   $XMODMAP_BIN ~/.Xmodmap
}

function toggle_touchpad() {
   local synclient_bin=$(which synclient)
   local qstr="TouchpadOff"
   local cur_state=$("${synclient_bin}" -l | grep "${qstr}" | awk '{ print $3 }')
   local new_state=""

   if [ "${cur_state}" == "1" ]; then
      new_state="0"
   else
      new_state="1"
   fi

   "${synclient_bin}" "${qstr}"=${new_state}
}

# Tar gz directory
function tard {
   local dir=$1
   TAR_BIN=$(which tar)

	if [ "${#1}" -eq 0 ];
   then
      echo "Usage: tard <directory>"
      return 1
   fi

   $TAR_BIN -czf "$1.tar.gz" "$1"
}

# Clear tmp directory
function clean_tmp_dirs {
   local delete=${1-:""}

   local tmp_dir=$HOME/tmp
   local download_dir=$HOME/downloads

   clean_directory "$tmp_dir" "$1"
   clean_directory "$download_dir" "$1"
}

# Clean directory from old files and empty directories
function clean_directory {
   local dir=$1
   local delete=${2-:""}
   local delete_param=""

	if [ "${#1}" -eq 0 ];
   then
      echo "Usage: clean_directory <directory> [-delete]"
      return 1
   fi

   if [ ! -d "$dir" ]; then
      return 1
   fi

   if [ "$delete" == "-delete" ]; then
      delete_param="-delete"
   fi

   # Remove files that has not been modified in last 30 days
   find "$dir" -type f -mtime +30 ${delete_param}
   # Remove all empty directories
   find "$dir" -mindepth 1 -type d -empty ${delete_param}
}

# Reload bash configuration
function reload() {
   load_file ~/.bashrc
}


#!/bin/bash

#By default, the movies are downloaded into ntfs_1/movies folder
#The movies are moved from ntfs_1/movies folder to either ntfs_2 or ntfs_3 movies folder when ntfs_1 is less than 10G

OIFS="$IFS"
IFS=$'\n'

SOURCE=/mnt/ntfs_1/movies
DESTINATION1=/mnt/ntfs_2/movies
DESTINATION2=/mnt/ntfs_3/movies

NTFSSIZE1=$(df | grep ntfs_1 | awk '{print $4}')
NTFSSIZE2=$(df | grep ntfs_2 | awk '{print $4}')
NTFSSIZE3=$(df | grep ntfs_3 | awk '{print $4}')

#convert size to gigs
SIZE1=`echo "$NTFSSIZE1 / 10^6" | bc`
SIZE2=`echo "$NTFSSIZE2 / 10^6" | bc`
SIZE3=`echo "$NTFSSIZE3 / 10^6" | bc`

echo "ntfs_1 size is $SIZE1"
echo "ntfs_2 size is $SIZE2"
echo "ntfs_3 size is $SIZE3"


#function to movie files to a specific directory
function movie_files {
  for i in $(ls $SOURCE | head -10); do
         rsync -a $SOURCE/$i $1
	 rm -rf $SOURCE/$i
         echo "$(date +%d-%m-%Y-%H:%M) $SOURCE/$i moved to $1" >> ~/scripts/logs/move_movie_$(date +%d_%m_%Y).log
        done

}

#moving movies if less than 10G
if [ $SIZE1 -lt 49 ] && [ $SIZE2 -gt 1 ]; then
 movie_files $DESTINATION1
elif [ $SIZE1 -lt 49 ] && [ $SIZE3 -gt 1 ]; then
 movie_files $DESTINATION2
elif [ $SIZE1 -gt 49 ]; then
	echo "size of $SOURCE is ${SIZE1}GIG no need to movie files"
else
       	echo "All disk are full"
fi
IFS="$OIFS"


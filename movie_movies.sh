#!/bin/bash

#By default, the movies are downloaded into ntfs_1/movies folder
#The movies are moved from ntfs_1/movies folder to either ntfs_2 or ntfs_3 movies folder when ntfs_1 is less than 10G

OIFS="$IFS"
IFS=$'\n'

SOURCE=/mnt/ntfs_1/movies
DESTINATION1=/mnt/ntfs_2/movies
DESTINATION2=/mtn/ntfs_3/movies

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

#moving movies if less than 10G
if [ $SIZE1 -lt 49 ] && [ $SIZE2 -gt 1 ]; then
	for i in $(ls $SOURCE | head -10); do
	 mv -v $SOURCE/$i $DESTINATION1
	 echo "$(date +%d-%m-%Y-%H:%M) $SOURCE/$i moved to $DESTINATION1" >> ~/scripts/logs/move_movie.log 
	done       	
elif [ $SIZE1 -lt 49 ] && [ $SIZE3 -lt 1 ]; then
 echo "movie files to ntfs_3"
elif [ $SIZE1 -gt 49 ]; then
	echo "size of $SOURCE is ${SIZE1}GIG no need to movie files"
else
       	echo "All disk are full"
fi
IFS="$OIFS"


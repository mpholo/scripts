#!/bin/bash

for i in $(ls -d /mnt/ntfs_[1-3]) 
do
  echo "deleting in  folder $i"
  find "$i/movies" -mtime +365 | wc -l
  #find $i/series -mtime +365 | wc -l
done


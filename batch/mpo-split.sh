#! /bin/bash

# Mass split MPO files
# --------------------
# Run this script from a folder containing many *.MPO files.
# The script will create directories titled "Left" and "Right".
# The two .jpg files will be placed in one or the other folder.
#
# Remember that the .MPO extension is expected to be all caps,
# but the output .jpg files will have lower-case extensions.

# https://linuxhandbook.com/courses/bash/

RIGHT_DIR=./Right
if [ ! -d "$RIGHT_DIR" ]; then
    mkdir $RIGHT_DIR
fi

for img in *.MPO
do
    imgName=${img%.MPO}
    echo " splitting " $img;
    
    # create temporary left and right images
    exiftool -trailer:all= $img -o "./Left/"$imgName".jpg"
    exiftool $img -mpimage2 -b > $imgName".jpg"
    mv $imgName".jpg" $RIGHT_DIR
done



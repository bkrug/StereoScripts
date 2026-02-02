# Gimp Stereo Scripts

To install, clone this repo.
Add the "src" folder to Gimp's source of scripts through the following menu.
`Edit -> Preferences -> Folders -> Scripts`

I did not create mposplit.exe. It is a windows executable for splitting mpo files into two jpegs.

### Ideas to come back and make this work in Linux

Gimp is available in Linux, but I need to replace that mposplit.exe file.
This website directs attention to the program "exiftool":
https://www.lightbulbhead.co.uk/splitting-a-mpo-file/

Using `dnf search exiftool` we can see that the package is available in Fedora.

From the linked webpage, here is the code I care about:
```
    imgName=${img%.mpo}

    # create temporary left and right images
    exiftool -trailer:all= $img -o $imgName"_L.jpg"
    exiftool $img -mpimage2 -b > $imgName"_R.jpg"
```
    
Be aware that ImageMagick and AnaBuilder might also be useful, if I don't want to use thos gimp scripts and more.

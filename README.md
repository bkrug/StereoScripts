# Installing Gimp Stereo Scripts

To install, clone this repo.
Add the "src" folder to Gimp's source of scripts through the following menu.
`Edit -> Preferences -> Folders -> Scripts`

# Splitting .MPO files into two .JPGs

### Windows

I did not create mposplit.exe. It is a windows executable for splitting mpo files into two jpegs.

### Linux

A different tool is necessary to split .MPO files.
This website directs attention to the program "exiftool":
https://www.lightbulbhead.co.uk/splitting-a-mpo-file/

Using `dnf search exiftool` we can see that the package is available in Fedora.

From a folder containing many .MPO files, run this terminal command `bash /home/bkrug/Repos/StereoScripts/batch/mpo-split.sh`.
It will create two new subfolders "Left" and "Right" and place each half of the .MPO file in one of the two folders.
The result will be two lists of files with identical names and slightly different contents.

# Gimp Tools

The scripts within this repo create a new "Stereo" menu in the GIMP menubar.
Below are the tools that exist within that menu.

### Display Analygraph Layers

Allows the user to select a left image and a right image, and generates an analygraph image from the two.
The image is created as two GIMP layers.
If necessary, you can shift or rotate one of the layers so that the red and cyan layers match up better.

Use this option if the "mass" operation produces inadequate results for a few pictures,
or if your source left and right images do not have identical names.

### Display Stereo Card

Allows the user to select a left image and a right image, and generates an image to be viewed through a stereocope.
The result is a picture that would be 6 inches wide and 4 inches tall if printed.
When using this tool, a substantial amount of horizontal space is automatically cropped,
retaining only the middle 3 inches for the original left and right image.

This tool should always have the same results as the "mass" operation,
so use it only when your source left and right images do not have identical names.

### Create Analgraph Images in Mass

Similar to "Display Analygraph Layers", but allows the user to select
a folder filled with left-eye images,
a folder filled with right-eye images,
and a destination folder.
The left and right folders must have lists of files with identical names.

Since the resulting images are saved directly to the destination folder,
the images are not auto-displayed in GIMP.

### Create Stereo Cards in Mass

Similar to "Display Stereo Card", but allows the user to select
a folder filled with left-eye images,
a folder filled with right-eye images,
and a destination folder.
The left and right folders must have lists of files with identical names.

Since the resulting images are saved directly to the destination folder,
the images are not auto-displayed in GIMP.

### Stack Images

Allows the user to select a left image and a right image,
and displays them as a new image containing the original left image directly above the original right image.

After using this tool, it must be followed by either of the "unstack" tools.

### Unstack from Cropped Selection

After the user uses "Stack Images",
the user is expected to manually crop the left and right images to the portions that they wish to retain.
This toll can then be used to realign the original images to be side-by-side and viewable through a stereoscope.
The resulting image will be printable as a 6 inch by 4 inch picture,
but the individual left and right halves do not need to perfectly fill a 3 inch by 4 inch space.
The user can select a border color to fill in any extra space.

The "Stack Images" tool placed the left image above the right image,
so that the user can guarantee that they are removing matching sections from the original images.

Use this tool when you want to view the images through a stereoscope,
but do not want the left and right images to have a 3 x 4 aspect ratio (3 inches being the width).

### Unstack from User-Defined Location

Use this following "Stack Images" to create an image that can be viewed through a stereoscope.
Using this tool requires the user to select an x-coordinate to represent the middle of the desired left half and right half the stereoscopic image.
The result is similar to "Display Stereo Card", but allows the user to pan the half-images horizontally.

Use this tool when you want to view the images through a stereoscope,
and want to maintain a 3 x 4 aspect ratio for the left and right halves,
but want more control over the cropped content than you have with "Display Stereo Card".
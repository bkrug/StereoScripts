# Installing Gimp Stereo Scripts

To install, clone this repo.
Add the "src" folder to Gimp's source of scripts through the following menu.
`Edit -> Preferences -> Folders -> Scripts`

# Splitting .MPO files into two .JPGs

### Windows

I did not create mposplit.exe, but it is included in this repo.
It is a windows executable for splitting mpo files into two jpegs.
You can get an idea of how to use it by looking at the *.bat scripts in the obsolete folder.

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

### Create Analgraph Images in Mass

Allows a user to create a series of analygraph images from one folder containing left-eye images and another folder containing right-eye images.
The two folders are required to contain lists of files with identical names.
If source images come from .MPO files, the attached "/batch/mpo-split.sh" shell script will create such a folder structure for you.

Since the resulting images are saved directly to a user-specified destination folder,
the images are not auto-displayed in GIMP.

### Create Stereo Cards in Mass

Allows a user to create a series of stereosopic images, meant to be viewed through a stereo viewer,
from one folder containing left-eye images and another folder containing right-eye images.
The two folders are required to contain lists of files with identical names.
If source images come from .MPO files, the attached "/batch/mpo-split.sh" shell script will create such a folder structure for you.

The resulting stereoscopic images are meant to be printed on a 6-inch wide x 4-inch tall medium.
Thus, the image for each eye will have an aspect ratio of about 3 x 4.
If your source images are wider than 3 x 4, then the tool automatically crops out the edges.
Only the middle 3 inches of width will remain.
If your source images are narrower than 3 x 4, then the tool does not crop anything and fills in the extra space with a border color.

Since the resulting images are saved directly to a user-specified destination folder,
the images are not auto-displayed in GIMP.

### Display Analygraph Layers

Allows the user to select a left image and a right image, and generates an analygraph image from the two.
The image is displayed in the GIMP application as two image layers, one red and one cyan,
and the user must manually export the result to a destination file.
If necessary, you can shift or rotate one of the layers so that the two of them match up better.

Use this option if the "mass" operation produces inadequate results for a few pictures,
or if your source left and right images do not have identical names.

### Display Stereo Card

Allows the user to select a left image and a right image, and generates an image to be viewed through a stereocope.
The result is a picture that would be 6 inches wide and 4 inches tall if printed.
If your source images are wider than a 3 x 4 aspect ratio, then they are edited using the approach of the "Create Stereo Cards in Mass" tool.

The image is displayed in the GIMP application,
and the user must manually export the result to a destination file.

This tool should always have the same results as the "mass" operation,
so use it only when your source left and right images do not have identical names.

### Stack Images

Allows the user to select a left image and a right image,
and displays them as a new image containing the original left image directly above the original right image.

After using this tool, it must be followed by either of the "unstack" tools.

### Unstack from Cropped Selection

After the user uses "Stack Images",
the user is expected to manually crop the left and right images to the portions that they wish to retain.
This "unstack" tool can then be used to realign the original images to be side-by-side and viewable through a stereoscope.
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
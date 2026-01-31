for %%f in (*.mpo) do (
	mposplit %%f
	"c:\program files\gimp 2\bin\gimp-console-2.10.exe" -i -b "(auto-stereo \"%%f.v1.jpg\" \"%%f.v2.jpg\" \"%%f.card.jpg\" \"GRAY\" '0.0625)" -b "(gimp-quit 1)"
	del %%f.v1.jpg
	del %%f.v2.jpg
)
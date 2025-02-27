for %%f in (*.mpo) do (
	mposplit %%f
	"c:\program files\gimp 2\bin\gimp-console-2.10.exe" -i -b "(anaglyph-conv \"%%f.v2.jpg\" \"%%f.v1.jpg\" \"%%f.jpg\" \"CYAN\" \"RED\")" -b "(gimp-quit 1)"
	del %%f.v1.jpg
	del %%f.v2.jpg
)
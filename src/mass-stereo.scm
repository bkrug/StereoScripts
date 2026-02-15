(define (stereo-auto
					fnmL
                    fnmR
					backColor
					borderSize)
	(let*
		(
			(img (car (gimp-file-load RUN-NONINTERACTIVE fnmL fnmL)))
			(layerArray (car (gimp-image-get-layers img)))
			(lyrL (vector-ref layerArray 0))			
			(lyrR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnmR)))
			;
			(HEIGHT_INCHES 4)
			(WIDTH_INCHES 3)
			; Since there is a left-half and right-half,
			; each half has an upper and lower border,
			; but each half has only one border on either side.
			; (Measured in inches)
			(heightWithoutBorder (- HEIGHT_INCHES (* 2 borderSize)))
			(widthWithoutBorder (- WIDTH_INCHES borderSize))
			; dimensions in pixels
			(origHeight (car (gimp-image-get-height img)))
			(origWidth (car (gimp-image-get-width img)))
			; get the target widths in pixels
			(widthForEachEye (/ (* widthWithoutBorder origHeight) heightWithoutBorder))
			(cutFromLeftWidth (/ (- origWidth widthForEachEye) -2))
			(newWidth (* 2 widthForEachEye))
		)
		; insert the right-eye layer
		(gimp-image-insert-layer img lyrR 0 0)
		; cut left layer down to middle portion and move it to the left
		(gimp-layer-resize lyrL widthForEachEye origHeight cutFromLeftWidth 0)
		(gimp-layer-set-offsets lyrL 0 0)
		; cut right layer down to middle portion and move it to the right
		(gimp-layer-resize lyrR widthForEachEye origHeight cutFromLeftWidth 0)
		(gimp-layer-set-offsets lyrR widthForEachEye 0)
		; resize image to a 4x6 ratio
		(gimp-image-resize img newWidth origHeight 0 0)
		(gimp-image-merge-visible-layers img CLIP-TO-IMAGE)
		; add border
		(stereo-add-border img backColor borderSize)
		; return value
		img
	)
)

(define (stereo-auto-display
					fnmL
					fnmR
					backColor
					borderSize)
	(let*
		(
			(img (stereo-auto fnmL fnmR backColor borderSize))
		)
		; display the image
		(gimp-display-new img)
		(gimp-displays-flush)
	)
)

(define (stereo-auto-save
					fnmL
					fnmR
					fnmDest
					backColor
					borderSize)
	(let*
		(
			(img (stereo-auto fnmL fnmR backColor borderSize))
		)
		; save the image
		(gimp-image-flatten img)
		(gimp-file-save RUN-NONINTERACTIVE img fnmDest)
	)					
)

; "folderL", "folderR", and "folderDest" must end with slashes
(define (stereo-save-many-images filesL folderL folderR folderDest backColor borderSize)
	(let*
		(
			(fnmL (car filesL))
			(filename (substring fnmL (string-length folderL)))
			(fnmR (string-append folderR filename))
			(fnmDest (string-append folderDest filename))
		)
		(stereo-auto-save fnmL fnmR fnmDest backColor borderSize)
		(if (> (length filesL) 1)
			(stereo-save-many-images (cdr filesL) folderL folderR folderDest backColor borderSize)
			(display "")
		)
	)
)

(define (stereo-mass-creation pathL pathR pathDest ext backColor borderSize)
	(let*
		(
			(normalizedL (normalize-folder-path pathL))
			(normalizedR (normalize-folder-path pathR))
			(normalizedDest (normalize-folder-path pathDest))
			(normalizedExt (normalize-extension ext))
			(searchL (string-append normalizedL normalizedExt))
			(filesL (car (file-glob searchL 0)))
		)
		(stereo-save-many-images filesL normalizedL normalizedR normalizedDest backColor borderSize)
	)
)

(script-fu-register "stereo-auto-display"
					"Display Stereo Card"
					"Convert two photos into a stereoscopic card in one step"
					""
					"Benjamin Krug"
					"2026-02-15"
					""
        SF-FILENAME "Left Image" ""
        SF-FILENAME "Right Image" ""
		SF-COLOR      _"Color"                  "gray"
		SF-ADJUSTMENT _"Border Size in Inches"  '(0.0625 0 3 0.0625 5 4 0)		  
)

(script-fu-register "stereo-mass-creation"
					"Create Stereo Cards in Mass"
					"Specify two folders with matching lists of left and right images, and place new stereo cards in a third folder"
					""
					"Benjamin Krug"
					"2026-02-15"
					""
		SF-DIRNAME "Left Folder" ""
		SF-DIRNAME "Right Folder" ""
		SF-DIRNAME "Destination Folder" ""
		SF-STRING  "Extension" "jpg"
		SF-COLOR      _"Color"                  "gray"
		SF-ADJUSTMENT _"Border Size in Inches"  '(0.0625 0 3 0.0625 5 4 0)		  
)

(script-fu-menu-register "stereo-auto-display"
                         "<Image>/Stereo")

(script-fu-menu-register "stereo-mass-creation"
                         "<Image>/Stereo")
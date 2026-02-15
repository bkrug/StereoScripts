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

;(stereo-auto-display "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/P1110869.jpg" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/P1110869.jpg" "gray" 0.0625)
;(stereo-auto-save "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/P1110869.jpg" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/P1110869.jpg" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/P1110869.jpg" "gray" 0.0625)
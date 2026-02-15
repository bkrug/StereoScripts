; Add enough of a border such that the image has a 4x6 ratio.
; Thus the borderSize is the minimum size.
; Set the resolution so that the photograph is 4 inches by 6 inches.
(define (stereo-add-border
							img
							backColor
							borderSize)
	(let* 
		(
			(layerArray (car (gimp-image-get-layers img)))
			(lyrContent (vector-ref layerArray 0))
			;			
			(contentHeight (car (gimp-image-get-height img)))
			(contentWidth (car (gimp-image-get-width img)))         
			(HEIGHT_INCHES 4)
			(WIDTH_INCHES 6)
			; height and width in pixels before they are increased to match the desired aspect ratio
			(heightWithBorder (/ contentHeight (- 1 (/ (* 2 borderSize) HEIGHT_INCHES ))))
			(widthWithBorder (/ contentWidth (- 1 (/ (* 2 borderSize) WIDTH_INCHES ))))
			; height and width in pixels after increasing them to match the desired aspect ratio
			(printedHeight
				(if
					(> (/ HEIGHT_INCHES WIDTH_INCHES) (/ contentHeight contentWidth))
					(* (/ HEIGHT_INCHES WIDTH_INCHES) widthWithBorder)
					heightWithBorder 
				)
			)
			(printedWidth
				(if
					(> (/ HEIGHT_INCHES WIDTH_INCHES) (/ contentHeight contentWidth))
					widthWithBorder
					(* (/ WIDTH_INCHES HEIGHT_INCHES) heightWithBorder)
				)
			)
			; offsets to move the content to
			(contentTopOffset (/ (- printedHeight contentHeight) 2))
			(contentLeftOffset (/ (- printedWidth contentWidth) 2))
			; calculate the desired dots per inch
			(verticalResolution (/ printedHeight HEIGHT_INCHES))
			(horizontalResolution (/ printedWidth WIDTH_INCHES))
			; Create a background layer to hold the border color
			(blankLyr (car (gimp-layer-new img "Background" printedWidth printedHeight 0 100 0)))
		)
		;
		(gimp-image-resize img printedWidth printedHeight 0 0)
		; center the content layer vertically and horizontally
		(gimp-layer-set-offsets lyrContent contentLeftOffset contentTopOffset)
		; color background image
		(gimp-context-set-background backColor)
		(gimp-drawable-fill blankLyr FILL-BACKGROUND)
		; insert layer behind
		(gimp-image-insert-layer img blankLyr 0 1)
		; merge layers
		(gimp-image-merge-visible-layers img CLIP-TO-IMAGE)
		; set resolution so that the image makes sense in inches
		(gimp-image-set-resolution img horizontalResolution verticalResolution)
	)
)

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
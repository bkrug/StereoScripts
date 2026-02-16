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

(define (unstack-image-common
							img
							lyr
							backColor
							borderSize)
	(let*
   		(
			(origHeight (car (gimp-image-get-height img)))
			(origWidth (car (gimp-image-get-width img)))
			(contentHeight (/ origHeight 2))
			(contentWidth (* 2 origWidth))
			(HEIGHT_INCHES 4)
			(WIDTH_INCHES 6)
		)
		; double image width
		(gimp-image-resize img contentWidth origHeight 0 0)
		(gimp-layer-resize-to-image-size lyr)
		; select bottom half of image
		(gimp-image-select-rectangle img CHANNEL-OP-ADD 0 contentHeight origWidth contentHeight)
		; cut bottom half of image
		(gimp-edit-cut (vector lyr) )
		; select top right quarter of new image size
		(gimp-image-select-rectangle img CHANNEL-OP-REPLACE origWidth 0 origWidth contentHeight)
		; paste bottom half on the right
		(gimp-edit-paste lyr)
		(let*
			(
				; merge content layers. neither layer held the border yet.
				(lyrMerge (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE)))
			)
			; halve image height
			(gimp-image-resize img contentWidth contentHeight 0 0)
			(gimp-layer-resize-to-image-size lyrMerge)
			;
			(stereo-add-border img backColor borderSize)
			; the end
			(gimp-displays-flush)
		)
	)
)

(define (unstack-image img
					   lyr
					   backColor
					   borderSize)
	(gimp-image-undo-group-start img)
	;
	(gimp-selection-none img)
	(unstack-image-common img lyr backColor borderSize)
	;
	(gimp-image-undo-group-end img)
)

(define (unstack-image-at-x
					img
					lyr
					middleX
					backColor
					borderSize)
	(gimp-image-undo-group-start img)					
	(gimp-selection-none img)
	(let*
		(
			; desired height of each half of the image
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
			(heightOfOneFrame (/ origHeight 2))
			; get the target widths in pixels
			(widthForEachEye (/ (* widthWithoutBorder heightOfOneFrame) heightWithoutBorder))
			(newWidth (* 2 widthForEachEye))
			; given that middleX refers to the center of the portions that we will keep,
			; calculate the left-most position of what we will keep
			(leftmostPosition (- middleX (/ widthForEachEye 2)))
			(cutFromLeftWidth
				(cond
					((< leftmostPosition 0)
						0)
					((> leftmostPosition (- origWidth widthForEachEye))
						(- origWidth widthForEachEye))
					(else
						leftmostPosition)
				)				
			)
		)
		; cut to the portion we will keep
		(gimp-image-crop img widthForEachEye origHeight cutFromLeftWidth 0)
		; let the top half of what is left become the left half of what is left
		(unstack-image img lyr backColor borderSize)
	)
	(gimp-image-undo-group-end img)
)

(script-fu-register "unstack-image"
					"Unstack from Cropped Selection"
					"Splits image into top and bottom halves, converting into left and right halves, and fits them onto into an image for printing a 4x6 photograph."
					""
					"Benjamin Krug"
					"2026-02-15"
					""
					SF-IMAGE      "The image"				0
					SF-DRAWABLE   "The layer"				0
					SF-COLOR      _"Color"                  "gray"
					SF-ADJUSTMENT _"Border Size in Inches"  '(0.0625 0 3 0.0125 0.0125 4 1)
)

(script-fu-register "unstack-image-at-x"
					"Unstack from User-Defined Location"
					"Unstack such that a user-selected x-coordinate represents the middle of the new image."
					""
					"Benjamin Krug"
					"2026-02-15"
					""
					SF-IMAGE      "The image"				0
					SF-DRAWABLE   "The layer"				0
					SF-ADJUSTMENT _"X Position"             '(0 0 1000000 25 100 0 1)
					SF-COLOR      _"Color"                  "gray"
					SF-ADJUSTMENT _"Border Size in Inches"  '(0.0625 0 3 0.0125 0.0125 4 1)
)
;See values specified for SF-ADJUSTMENT here:
;https://docs.gimp.org/3.0/en/gimp-using-script-fu-tutorial-first-script.html

(script-fu-menu-register "unstack-image"
                         "<Image>/Stereo")

(script-fu-menu-register "unstack-image-at-x"
                         "<Image>/Stereo")

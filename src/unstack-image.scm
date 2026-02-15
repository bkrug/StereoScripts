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

(define (unstack-image img
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

(script-fu-register "unstack-image"
					"Unstack for Stereoscope"
					"Splits image into top and bottom halves, converting into left and right halves, and fits them onto into an image for printing a 4x6 photograph."
					""
					"Benjamin Krug"
					"2026-01-31"
					""
					SF-IMAGE      "The image"				0
					SF-DRAWABLE   "The layer"				0
					SF-COLOR      _"Color"                  "gray"
					SF-ADJUSTMENT _"Border Size in Inches"  '(0.0625 0 3 0.0625 5 4 0)
)

(script-fu-menu-register "unstack-image"
                         "<Image>/Stereo")

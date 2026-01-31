(define (unstack-image img
					  lyr
					  backColor
					  borderSize)
   (let*
   		(
			(origHeight (car (gimp-image-get-height img)))
			(origWidth (car (gimp-image-get-width img)))
			(newHeight (/ origHeight 2))
			(newWidth (* 2 origWidth))
			(BACKGROUND_FILL 1)
			(HEIGHT_INCHES 4)
			(WIDTH_INCHES 6)
		)
		; double image width
		(gimp-image-resize img newWidth origHeight 0 0)
		(gimp-layer-resize-to-image-size lyr)
		; select bottom half of image
		(gimp-image-select-rectangle img CHANNEL-OP-ADD 0 newHeight origWidth newHeight)
		; cut bottom half of image
		(gimp-edit-cut (vector lyr) )
		; select top right quarter of new image size
		(gimp-image-select-rectangle img CHANNEL-OP-REPLACE origWidth 0 origWidth newHeight)
		; paste bottom half on the right
		(gimp-edit-paste lyr)
		(let*
			(
				; merge layers
				(lyr-merge (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE)))
			)
			; halve image height
			(gimp-image-resize img newWidth newHeight 0 0)
			(gimp-layer-resize-to-image-size lyr-merge)
			; set image to ratio of a 4x6 photograph
			(let* 
				(
					(heightWithBorder (/ newHeight (- 1 (/ borderSize (/ HEIGHT_INCHES 2)))))
					(widthWithBorder (/ newWidth (- 1 (/ borderSize (/ WIDTH_INCHES 2)))))
					(photoHeight (if (> (/ 4 6) (/ newHeight newWidth)) (* (/ 4 6) widthWithBorder) heightWithBorder ) )
					(photoWidth (if (> (/ 4 6) (/ newHeight newWidth)) widthWithBorder (* (/ 6 4) heightWithBorder) ) )
					(centerHeight (/ (- photoHeight newHeight) 2))
					(centerWidth (/ (- photoWidth newWidth) 2))
					(blankLyr (car (gimp-layer-new img "Background" photoWidth photoHeight 0 100 0)))
				)
				(gimp-image-resize img photoWidth photoHeight 0 0)
				; move layer to center
				(gimp-layer-set-offsets lyr-merge centerWidth centerHeight)
				; color background image
				(gimp-context-set-background backColor)
				(gimp-drawable-fill blankLyr FILL-BACKGROUND)
				; insert layer behind
				(gimp-image-insert-layer img blankLyr 0 1)
				; merge layers
				(gimp-image-merge-visible-layers img CLIP-TO-IMAGE)
				; the end
				(gimp-displays-flush)
			)
		)
	)
)

(script-fu-register "unstack-image"
					"Unstack for Stereoscope"
					"Splits image into top and bottom halves, converting into left and right halves, and fits them onto into an image for printing a 4x6 photograph."
					""
					"Benjamin Krug"
					"2026-01-26"
					""
					SF-IMAGE      "The image"				0
					SF-DRAWABLE   "The layer"				0
					SF-COLOR      _"Color"                  "gray"
					SF-ADJUSTMENT _"Border Size in Inches"  '(0.0625 0 3 0.0625 5 4 0)
)

(script-fu-menu-register "unstack-image"
                         "<Image>/Stereo")

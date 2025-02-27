(define (stereo-photo img lyr backColor borderSize)
   (let* (
		   (origHeight (car (gimp-image-height img)))
		   (origWidth (car (gimp-image-width img)))
		   (newHeight (/ origHeight 2))
		   (newWidth (* 2 origWidth))
		   (CHANNEL_OP_ADD 0)
		   (CHANNEL_OP_REPLACE 2)
		   (CLIP_TO_IMAGE 1)
		   (FG_BUCKET_FILL 0)
		   (BACKGROUND_FILL 1)
		   (HEIGHT_INCHES 4)
		   (WIDTH_INCHES 6)
         )
	  ; double image width
	  (gimp-image-resize img newWidth origHeight 0 0)
	  (gimp-layer-resize-to-image-size lyr)
      ; select bottom half of image
      (gimp-image-select-rectangle img CHANNEL_OP_ADD 0 newHeight origWidth newHeight)
	  ; cut bottom half of image
	  (gimp-edit-cut lyr)
      ; select top right quarter of new image size
      (gimp-image-select-rectangle img CHANNEL_OP_REPLACE origWidth 0 origWidth newHeight)
	  ; paste bottom half on the right
	  (gimp-edit-paste lyr 1)
	  ; merge layers
	  (gimp-image-merge-visible-layers img CLIP_TO_IMAGE)
	  ; halve image height
	  (gimp-image-resize img newWidth newHeight 0 0)
	  (gimp-layer-resize-to-image-size (car (gimp-image-get-active-layer img)))
	  ; set image to ration of a 4x6 photograph
	  (let* (
				(heightWithBorder (/ newHeight (- 1 (/ borderSize (/ HEIGHT_INCHES 2)))))
				(widthWithBorder (/ newWidth (- 1 (/ borderSize (/ WIDTH_INCHES 2)))))
			)
		  (let* (
					(photoHeight (if (> (/ 4 6) (/ newHeight newWidth)) (* (/ 4 6) widthWithBorder) heightWithBorder ) )
					(photoWidth (if (> (/ 4 6) (/ newHeight newWidth)) widthWithBorder (* (/ 6 4) heightWithBorder) ) )
				)
				(let* (
						(centerHeight (/ (- photoHeight newHeight) 2))
						(centerWidth (/ (- photoWidth newWidth) 2))
						(lyr (car (gimp-image-get-active-layer img)))
						(blankLyr (car (gimp-layer-new img photoWidth photoHeight 0 "" 100 0)))
					)
					(gimp-image-resize img photoWidth photoHeight 0 0)
					; move layer to center
					(if (> (/ 4 6) (/ newHeight newWidth))
						(script-fu-move-layer-to img lyr centerWidth centerHeight)
						(script-fu-move-layer-to img lyr centerWidth centerHeight)
					)
					; color background image
					(gimp-context-set-background backColor)
					(gimp-drawable-fill blankLyr BACKGROUND_FILL)
					; insert layer behind
					(gimp-image-insert-layer img blankLyr 0 1)
					; merge layers
					(gimp-image-merge-visible-layers img CLIP_TO_IMAGE)
				)
		  )
	  )
      ; the end
      (gimp-displays-flush)
   )
)

(script-fu-register "stereo-photo"
					"Stereo Photo"
					"Splits and image in half vertically, aligns the halves horizontally, and fits them onto into an image for printing a photograph."
					""
					"Benjamin Krug"
					"2014-10-04"
					""
					SF-IMAGE      "The image"				0
					SF-DRAWABLE   "The layer"				0
					SF-COLOR      _"Color"                  "gray"
					SF-ADJUSTMENT _"Border Size in Inches" '(0.0625 0 3 0.0625 5 4 0)
)

(script-fu-menu-register "stereo-photo"
                         "<Image>/Stereo")
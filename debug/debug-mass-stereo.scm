(define (stereo-auto fnmL
                     fnmR)
	(let* 
		(
			(img (car (gimp-file-load RUN-NONINTERACTIVE fnmL fnmL)))
			(layerArray (car (gimp-image-get-layers img)))
			(lyrL (vector-ref layerArray 0))			
			(lyrR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnmR)))
			;
			(origHeight (car (gimp-image-get-height img)))
			(origWidth (car (gimp-image-get-width img)))
			(widthForEachEye (/ (* 3 origHeight) 4))
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
		;
		(gimp-image-resize img newWidth origHeight 0 0)
		(let*
			(
				(layMerge (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE) ) )
			)
			; display the image
			(gimp-display-new img)
			(gimp-displays-flush)
		)		
	)
)

;(stereo-auto "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/P1110869.jpg" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/P1110869.jpg")
(define (script-fu-move-layer-to image layer absolutex absolutey)
	(let* ( 
			(layerOffsets (gimp-drawable-offsets layer))
			(layerOffsetsX (car layerOffsets))
			(layerOffsetsY (cadr layerOffsets))
			(activelayer 0)
			(offsetx 0)
			(offsety 0)
			)
		(set! activelayer (car (gimp-image-get-active-layer image)))
		(set! offsetx (- absolutex layerOffsetsX))
		(set! offsety (- absolutey layerOffsetsY))
		(gimp-layer-translate activelayer offsetx offsety)
		(gimp-displays-flush)
    )
)

(define (stack-images fnm-L
                      fnm-R)
   (let* (
           (img (car (gimp-file-load RUN-NONINTERACTIVE fnm-L fnm-L)))
           (layL (car (gimp-image-get-active-layer img)))
           (layR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnm-R)))
		   (origHeight (car (gimp-image-height img)))
		   (origWidth (car (gimp-image-width img)))
		   (newHeight (* 2 origHeight))
		   (CLIP_TO_IMAGE 1)
         )
	  ; double image height
	  (gimp-image-resize img origWidth newHeight 0 0)
      ; insert the right-eye layer
      (gimp-image-add-layer img layR 0)
	  ; move right layer vertically down
	  (script-fu-move-layer-to img layR 0 origHeight)
	  ; merge layers
	  (gimp-image-merge-visible-layers img CLIP_TO_IMAGE)
	  ; display the image
	  (gimp-display-new img)
      ; the end
      (gimp-displays-flush)
   )
)

; register the script?
(script-fu-register "stack-images"
                    "Stack Images"
                    "Stack one image at the top top half and one at the bottom half of the new image."
                    ""
                    "Benjamin Krug"
                    "2014-10-04"
                    ""
                    SF-FILENAME "fnm-L" ""
                    SF-FILENAME "fnm-R" ""
                    ;SF-FILENAME "Output" "output.rcs.png"
)
(script-fu-menu-register "stack-images" "<Toolbox>/Stereo")
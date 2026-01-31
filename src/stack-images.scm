(define (stack-images fnm-L
                      fnm-R)
   (let* 
      (
         (img (car (gimp-file-load RUN-NONINTERACTIVE fnm-L fnm-L)))
         (layL (car (gimp-image-get-layers img)))
         (layR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnm-R)))
         (origHeight (car (gimp-image-get-height img)))
         (origWidth (car (gimp-image-get-width img)))
         (newHeight (* 2 origHeight))
         (CLIP_TO_IMAGE 1)
      )
	   ; double image height
	   (gimp-image-resize img origWidth newHeight 0 0)
      ; insert the right-eye layer
      (gimp-image-insert-layer img layR 0 0)
	   ; move right layer vertically down
	   (gimp-layer-set-offsets layR 0 origHeight)
	   ; merge layers
	   (let*
         (
            (layMerge (car (gimp-image-merge-visible-layers img CLIP_TO_IMAGE) ) )
         )
         ; display the image
         (gimp-display-new img)
         ; the end
         (gimp-displays-flush)
         ; return
         '(img layMerge)         
      )
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
)

(script-fu-menu-register "stack-images"
						 "<Image>/Stereo")

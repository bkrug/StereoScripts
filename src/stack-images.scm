(define (stack-images fnmL
                      fnmR)
   (let* 
      (
         (img (car (gimp-file-load RUN-NONINTERACTIVE fnmL fnmL)))
         (lyrR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnmR)))
         (origHeight (car (gimp-image-get-height img)))
         (origWidth (car (gimp-image-get-width img)))
         (newHeight (* 2 origHeight))
      )
      (gimp-image-undo-enable img)
      (gimp-image-undo-group-start img)
	   ; double image height
	   (gimp-image-resize img origWidth newHeight 0 0)
      ; insert the right-eye layer
      (gimp-image-insert-layer img lyrR 0 0)
	   ; move right layer vertically down
	   (gimp-layer-set-offsets lyrR 0 origHeight)
	   ; merge layers
	   (let*
         (
            (layMerge (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE) ) )
         )
         ; display the image
         (gimp-display-new img)
         ; the end
         (gimp-displays-flush)
         ; return
         (vector img layMerge)         
      )
      (gimp-image-undo-group-end img)
   )
)

; register the script?
(script-fu-register "stack-images"
                    "Stack Images"
                    "Stack left image as the top top half and right image as the bottom half of a new image."
                    ""
                    "Benjamin Krug"
         			  "2026-01-31"
                    ""
                    SF-FILENAME "Left Image" ""
                    SF-FILENAME "Right Image" ""
)

(script-fu-menu-register "stack-images"
						 "<Image>/Stereo")

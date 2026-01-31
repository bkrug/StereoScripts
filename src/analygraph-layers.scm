(define (analygraph-layers fnm-L fnm-R)
  (let*
    (
      (img (car (gimp-file-load RUN-NONINTERACTIVE fnm-L fnm-L)))
      (layL (car (gimp-image-get-layers img)))
      (layR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnm-R)))
      (grey-saturation -100)
    )
    ;
    ;(gimp-image-undo-disable img)
    ;
    (gimp-image-insert-layer img layR 0 0)
    ; make both layers grayscale
    (gimp-drawable-hue-saturation layL HUE-RANGE-ALL 0 0 grey-saturation 0)
    ;(gimp-drawable-hue-saturation layR HUE-RANGE-ALL 0 0 grey-saturation 0)
    ;
    ;(gimp-drawable-colorize-hsl layer-R 0.5 1.0 0)
    ;(gimp-drawable-colorize-hsl 1 180 100 0)
    ;(gimp-drawable-colorize-hsl 2 180 100 0)
    ;
    ;(gimp-layer-set-opacity layL 50)
    ;
    ;(gimp-image-undo-enable img)
    ; display the image
    (gimp-display-new img)
    ; the end
    (gimp-displays-flush)
  )
)

(script-fu-register "analygraph-layers"
					"Load Analygraph Layers"
					"Loads two photos as layers tinted cyan and red"
					""
					"Benjamin Krug"
					"2026-01-26"
					""
                    SF-FILENAME "fnm-L" ""
                    SF-FILENAME "fnm-R" ""
)

(script-fu-menu-register "analygraph-layers"
                         "<Image>/Stereo")

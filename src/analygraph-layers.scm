(define (analygraph-create-layers fnmL fnmR)
	(let*
		(
			(img (car (gimp-file-load RUN-NONINTERACTIVE fnmL fnmL)))
			(layerArray (car (gimp-image-get-layers img)))
			(lyrL (vector-ref layerArray 0))
			(lyrR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnmR)))
		)
		(gimp-image-insert-layer img lyrR 0 0)
		; make one layer cyan
		(gimp-drawable-colorize-hsl lyrR 180 100 -50)
		; make one layer red
		(gimp-drawable-colorize-hsl lyrL 0 100 -50)
		;
		(gimp-layer-set-opacity lyrR 50)
		;
		img
	)
)

(define (analygraph-display-layers fnmL fnmR)
	(let*
		(
			(img (analygraph-create-layers fnmL fnmR))
		)
    (gimp-display-new img)
    (gimp-displays-flush)
	)
)

(script-fu-register "analygraph-display-layers"
					"Load Analygraph Layers"
					"Loads two photos as layers tinted cyan and red"
					""
					"Benjamin Krug"
					"2026-02-14"
					""
          SF-FILENAME "Left Image" ""
          SF-FILENAME "Right Image" ""
)

(script-fu-menu-register "analygraph-display-layers"
                         "<Image>/Stereo")

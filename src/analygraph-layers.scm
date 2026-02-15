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
		;
		(gimp-image-undo-enable img)
	)
)

; "folderL", "folderR", and "destFolder" must end with slashes
(define (analygraph-save-image fnmL fnmR fnmDest)
	(let*
		(
			(img (analygraph-create-layers fnmL fnmR))
		)		
		(gimp-image-flatten img)
		(gimp-file-save RUN-NONINTERACTIVE img fnmDest)
	)
)

(define (analygraph-save-many-images filesL folderL folderR folderDest)
	(let*
		(
			(fnmL (car filesL))
			(filename (substring fnmL (string-length folderL)))
			(fnmR (string-append folderR filename))
			(fnmDest (string-append folderDest filename))
		)
		(analygraph-save-image fnmL fnmR fnmDest)
		(if (> (length filesL) 1)
			(analygraph-save-many-images (cdr filesL) folderL folderR folderDest)
			(display "")
		)
	)
)

(define (analygraph-mass-creation pathL pathR pathDest ext)
	(let*
		(
			(normalizedL (normalize-folder-path pathL))
			(normalizedR (normalize-folder-path pathR))
			(normalizedDest (normalize-folder-path pathDest))
			(normalizedExt (normalize-extension ext))
			(searchL (string-append normalizedL normalizedExt))
			(filesL (car (file-glob searchL 0)))
		)
		(analygraph-save-many-images filesL normalizedL normalizedR normalizedDest)
	)
)

(script-fu-register "analygraph-display-layers"
					"Display Analygraph Layers"
					"Loads two photos as separate layers tinted cyan and red"
					""
					"Benjamin Krug"
					"2026-02-14"
					""
          SF-FILENAME "Left Image" ""
          SF-FILENAME "Right Image" ""
)

(script-fu-register "analygraph-mass-creation"
					"Create Analygraph Images in Mass"
					"Specify two folders with matching lists of left and right images, and place new analygraphs in a third folder"
					""
					"Benjamin Krug"
					"2026-02-14"
					""
          SF-DIRNAME "Left Folder" ""
          SF-DIRNAME "Right Folder" ""
          SF-DIRNAME "Destination Folder" ""
          SF-STRING  "Extension" "jpg"
)

(script-fu-menu-register "analygraph-display-layers"
                         "<Image>/Stereo")

(script-fu-menu-register "analygraph-mass-creation"
                         "<Image>/Stereo")                         

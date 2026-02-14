(define (normalize-folder-path givenPath)
	(if
		(equal?
			(substring givenPath (- (string-length givenPath) 1))
			"/"
		)
		givenPath
		(string-append givenPath "/")
	)
)

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

; "folderL", "folderR", and "destFolder" must end with slashes
(define (analygraph-save-image fnmL folderL folderR destFolder)
	(let*
		(
			(filename (substring fnmL (string-length folderL)))
			(fnmR (string-append folderR filename))
			(destFile (string-append destFolder filename))
			(img (analygraph-create-layers fnmL fnmR))
		)
		(gimp-image-flatten img)
		(gimp-file-save RUN-NONINTERACTIVE img destFile)
	)
)

(define (analygraph-save-many-images filesL folderL folderR dest)
	(let*
		(
			(errorMsg (analygraph-save-image (car filesL) folderL folderR dest))
		)
		(if (> (length filesL) 1)
			(analygraph-save-many-images (cdr filesL) folderL folderR dest)
			(display "")
		)
	)
)

(define (analygraph-mass-creation pathL pathR pathDest ext)
	(let*
		(
			(normalizedExt 
				(if 
					(equal? (substring ext 0 1) ".")
					(string-append "*" ext)
					(string-append "*." ext)
				)
			)
			(normalizedL (normalize-folder-path pathL))
			(normalizedR (normalize-folder-path pathR))
			(normalizedDest (normalize-folder-path pathDest))
			(searchL (string-append pathL normalizedExt))
			(filesL (car (file-glob searchL 0)))
		)
		(analygraph-save-many-images filesL normalizedL normalizedR normalizedDest)
	)
)

;(analygraph-mass-creation "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Ana/" "jpg")
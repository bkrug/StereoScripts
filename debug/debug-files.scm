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
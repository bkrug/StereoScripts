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

(define (analygraph-layers-create fnmL fnmR)
	(let*
		(
			(img (car (gimp-file-load RUN-NONINTERACTIVE fnmL fnmL)))
			(layerArray (car (gimp-image-get-layers img)))
			(lyrL (vector-ref layerArray 0))
			(lyrR (car (gimp-file-load-layer RUN-NONINTERACTIVE img fnmR)))
			(grey-saturation -100)
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
(define (analygraph-save-image fnmL fnmR folderL folderR destFolder)
	(let*
		(
			(filenameL (substring fnmL (string-length folderL)))
			(filenameR (substring fnmR (string-length folderR)))
			(destFile (string-append destFolder filenameL))
			(img (analygraph-layers-create fnmL fnmR))
		)
		(if (equal? filenameL filenameR)
			(begin
				(gimp-image-flatten img)
				(gimp-file-save RUN-NONINTERACTIVE img destFile)
				""
			)
			(string-append "Files in the left and right path must match exactly. Found missmatch between these two: " filenameL " " filenameR)
		)
	)
)

(define (analygraph-save-many-images filesL filesR folderL folderR dest)
	(let*
		(
			(errorMsg (analygraph-save-image (car filesL) (car filesR) folderL folderR dest))
		)
		(if (> (string-length errorMsg) 0)
			errorMsg
			(if (> (length filesL) 1)
				(analygraph-save-many-images (cdr filesL) (cdr filesR) folderL folderR dest)
				""
			)
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
			(searchR (string-append pathR normalizedExt))
			(filesL (car (file-glob searchL 0)))
			(filesR (car (file-glob searchR 0)))
			(errorMsg
				(if (= (length filesL) (length filesR))
					(analygraph-save-many-images filesL filesR normalizedL normalizedR normalizedDest)
					(string-append "Left folder and right folder contain different numbers of files of type: " normalizedExt)
				)
			)
		)
		(if (> (string-length errorMsg) 0)
			(error errorMsg)
			display ""
		)
	)
)

;(analygraph-mass-creation "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Ana/" "jpg")
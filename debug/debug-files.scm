(define (write-line givenStr)
	(display givenStr)
	(display #\newline)
)

(define (analygraph-layers-internal fnmL fnmR)
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
  )
)

(define (display-files pathL pathR ext)
	(let*
		(
			(normalizedExt (if (equal? (substring ext 0 1) ".")
												(string-append "*" ext)
												(string-append "*." ext)
											))
			(searchL (if 
									(equal?
										(substring pathL (- (string-length pathL) 1))
										"/"
									)
									(string-append pathL normalizedExt)
									(string-append pathL "/" normalizedExt)
								))
			(filesL (car (file-glob searchL 0)))
		)
		(for-each write-line filesL)
	)
)

;(display-files "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/" "jpg")
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
		;
		img
  )
)

(define (make-analygraph fnmL fnmR)
	(let*
		(
			(img (analygraph-layers-internal fnmL fnmR))
		)
		(gimp-image-flatten img)
		; display the image
		(gimp-display-new img)
		; the end
		(gimp-displays-flush)
		;(gimp-file-save RUN-NONINTERACTIVE img "/home/bkrug/test.jpg")		
	)
)

(define (write-sep-line str1 str2)
	(if (= (length str1) 0)
		(display "")
		(make-analygraph (car str1) (car str2))
	)
	(if (= (length str1) 0)
		#t
		(write-sep-line (cdr str1) (cdr str2))
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
			(searchR (if 
									(equal?
										(substring pathR (- (string-length pathR) 1))
										"/"
									)
									(string-append pathR normalizedExt)
									(string-append pathR "/" normalizedExt)
								))
			(filesL (car (file-glob searchL 0)))
			(filesR (car (file-glob searchR 0)))
		)
		;(for-each write-line filesL)
		;(for-each write-line filesR)
		(write-sep-line filesL filesR)
	)
)

;(display-files "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/" "jpg")
;(make-analygraph "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Left/P1110869.jpg" "/home/bkrug/Pictures/Photos/Switch 2 Unboxing/3D/Right/P1110869.jpg")
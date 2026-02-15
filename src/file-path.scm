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

(define (normalize-extension ext)
  (cond
    ((equal? (substring ext 0 2) "*.")
      givenExt)
    ((equal? (substring ext 0 1) ".")
      (string-append "*" ext))
    (else
      (string-append "*." ext))
  )
)
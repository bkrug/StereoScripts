(define (write-line givenStr)
    (display givenStr)
    (display #\newline)
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

;(display-files "/home/bkrug/Cabinet/" "" "docx")
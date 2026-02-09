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
        )
        (display normalizedExt)
        (display searchL)
        ; (file-glob searchL 0)
    )
)
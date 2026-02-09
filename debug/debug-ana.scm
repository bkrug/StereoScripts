(define (debug-script)
    (let*
        (
            (fnm-left "/home/bkrug/GimpTest/20251227_114725.jpg")
            (fnm-right "/home/bkrug/GimpTest/20251227_114731.jpg")
        )
        (analygraph-layers fnm-left fnm-right)
    )
)
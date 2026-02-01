(define (debug-script)
    (let*
        (
            (fnm-left "/home/bkrug/GimpTest/20251227_114725.jpg")
            (fnm-right "/home/bkrug/GimpTest/20251227_114731.jpg")
            (stack-result (stack-images fnm-left fnm-right) )
            (img-stack (vector-ref stack-result 0) )
            (lyr-stack (vector-ref stack-result 1) )
        )
        (unstack-image img-stack lyr-stack "gray" 0.0625 )
    )
)
(define prepare
  (make <service>
    #:provides '(prepare)
    #:requires '(prepare-fs prepare-status)
    #:docstring "run wireplumber"
;;    #:requires '(pipewire pipewire-pulse)
    #:start (make-forkexec-constructor
              (let ((output-port (open-file "/tmp/shepherd/STATUS" "a")))
                (display "SIGOK" output-port)
                (newline output-port)
                (close output-port)))
    #:stop (make-kill-destructor)
    #:one-shot? #t))
(register-services prepare)

(start prepare)

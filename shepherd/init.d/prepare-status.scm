(define prepare-status
  (make <service>
    #:provides '(prepare-status)
    #:requires '(prepare-fs)
    #:docstring "run wireplumber"
;;    #:requires '(pipewire pipewire-pulse)
    #:start (make-forkexec-constructor
              '("touch" "/tmp/shepherd/STATUS"))
    #:stop (make-kill-destructor)
    #:one-shot? #t))
(register-services prepare-status)

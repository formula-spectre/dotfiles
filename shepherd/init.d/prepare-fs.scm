(define prepare-fs
  (make <service>
    #:provides '(prepare-fs)
    #:docstring "run wireplumber"
;;    #:requires '(pipewire pipewire-pulse)
    #:start (make-forkexec-constructor
              '("mkdir" "-p" "/tmp/shepherd"))
    #:stop (make-kill-destructor)
    #:one-shot? #t))
(register-services prepare-fs)

(start prepare-fs)

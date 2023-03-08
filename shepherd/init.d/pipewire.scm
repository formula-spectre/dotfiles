(define pipewire
  (make <service>
    #:provides '(pipewire)
    #:docstring "run pipewire as an user service"
    #:start (make-forkexec-constructor
              '("/run/current-system/sw/bin/pipewire")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/pipewire.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services pipewire)

(start pipewire)

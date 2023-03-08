(define wireplumber
  (make <service>
    #:provides '(wireplumber)
    #:docstring "run wireplumber"
;;    #:requires '(pipewire pipewire-pulse)
    #:start (make-forkexec-constructor
              '("/run/current-system/sw/bin/wireplumber")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/wireplumber.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services wireplumber)

(start wireplumber)

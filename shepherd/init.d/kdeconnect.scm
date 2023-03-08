(define kdeconnect-indicator
  (make <service>
    #:provides '(kdeconnect-indicator)
    #:requires '(kdeconnectd)
    #:docstring "run kdeconnect-indicaotr"
    #:start (make-forkexec-constructor
              '("kdeconnect-indicator")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/kdeconnect-indicator.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services kdeconnect-indicator)

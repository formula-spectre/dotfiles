(define kdeconnectd
  (make <service>
    #:provides '(kdeconnectd)
    #:docstring "run kdeconnectd"
    #:start (make-forkexec-constructor
              '("/usr/lib64/libexec/kdeconnectd")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/kdeconnectd.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services kdeconnectd)

(define myservice
  (make <service>
    #:provides '(SUBST)
    #:docstring "run SUBST"
    #:start (make-forkexec-constructor
              '("SUBST")
              ;; the following line is if you want shepherd to do the logging itself
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/SUBST.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services myservice)

(start SUBST)

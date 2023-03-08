(define searx
  (make <service>
    #:provides '(searx)
    #:docstring "Run `syncthing' without calling the browser"
    #:start (make-forkexec-constructor
              '("")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/searx.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services searx)
;(start searx)

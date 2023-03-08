(define syncthing
  (make <service>
    #:provides '(syncthing)
    #:docstring "Run `syncthing' without calling the browser"
    #:start (make-forkexec-constructor
              '("syncthing" "-no-browser"
                "-logflags=3") ; prefix with date & time
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/syncthing.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services syncthing)


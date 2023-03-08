(define pipewire-pulse
  (make <service>
    #:provides '(pipewire-pulse)
    #:docstring "run pipewire-pulse"
    #:start (make-forkexec-constructor
              '("/run/current-system/sw/bin/pipewire"  "-c" "pipewire-pulse.conf")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/pipewire-pulse.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services pipewire-pulse)

(start pipewire-pulse)

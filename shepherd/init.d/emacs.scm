(define emacs
  (make <service>
    #:provides '(emacs)
;;    #:requires '(pipewire)
    #:docstring "run emacs"
;;    #:environment-variables ("EMACSDIR=/home/doctor-sex/.config/emacs DOOMDIR=/home/doctor-sex/.config/doom.d")
    #:start (make-forkexec-constructor
              '("/home/doctor-sex/.nix-profile/bin/emacs" "--fg-daemon")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/emacs.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services emacs)

(start emacs)

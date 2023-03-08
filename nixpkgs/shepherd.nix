{ config, lib, pkgs, ... }:

let
  initdir = "shepherd/rc.d";
in
{
  xdg  = {
    #this is the config file, it reads ./rc.d for services
    configFile."shepherd/init.scm".text = ''
(use-modules (shepherd service)
             ((ice-9 ftw) #:select (scandir)))

;; Load all the files in the directory 'rc.d' with a suffix '.scm'.
(for-each
  (lambda (file)
    (load (string-append "rc.d/" file)))
  (scandir (string-append (dirname (current-filename)) "/rc.d")
           (lambda (file)
             (string-suffix? ".scm" file))))

;; Send shepherd into the background
(action 'shepherd 'daemonize)
'';

    ##begin service definition

    #define the pipewire service
    configFile."${initdir}/pipewire.scm".text = ''
(define pipewire
  (make <service>
    #:provides '(pipewire)
    #:docstring "run pipewire"
    #:start (make-forkexec-constructor
              '("${pkgs.pipewire}/bin/pipewire")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/pipewire.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services pipewire)

(start pipewire)
'';

    #define the pipewire-pulse service
    configFile."${initdir}/pipewire-pulse.scm".text = ''
(define pipewire-pulse
  (make <service>
    #:provides '(pipewire-pulse)
;;    #:requires '(pipewire)
    #:docstring "run pipewire-pulse"
    #:start (make-forkexec-constructor
              '("${pkgs.pipewire}/bin/pipewire"  "-c" "pipewire-pulse.conf")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/pipewire-pulse.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services pipewire-pulse)

(start pipewire-pulse)
'';

    #define the wireplumber service
    configFile."${initdir}/wireplumber.scm".text = ''
(define wireplumber
  (make <service>
    #:provides '(wireplumber)
    #:docstring "run wireplumber"
;;    #:requires '(pipewire pipewire-pulse)
    #:start (make-forkexec-constructor
              '("${pkgs.wireplumber}/bin/wireplumber")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/wireplumber.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services wireplumber)

(start wireplumber)
'';

    configFile."${initdir}/emacs.scm".text = ''
(define emacs
  (make <service>
    #:provides '(emacs)
    #:docstring "run emacs as daemon"
    #:start (make-forkexec-constructor
              '("${pkgs.emacs}" "--daemon")
                #:log-file (string-append (getenv "HOME")
                                          "/.var/log/shepherd/emacs.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
(register-services emacs)

(start emacs)
'';
  };
}

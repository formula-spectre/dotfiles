;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 15))

(require 'doom-modeline)
(doom-modeline 1)
(setq doom-modeline-support-imenu t
      doom-modeline-height  10
      doom-modeline-hud     t
      doom-modeline-icons   t
      doom-modeline-buffer-file-name-style 'auto
      doom-modeline-major-mode-color-icon t
      doom-modeline-buffer-state-icon t
      doom-modeline-buffer-modification-icon t
      doom-modeline-major-mode-icon t)
(setq truncate-lines nil)

(use-package tron-legacy-theme
  :config
  (setq tron-legacy-theme-vivid-cursor t
        tron-legacy-theme-dark-fg-bright-comments t)
  (load-theme 'tron-legacy t))

(setq doom-theme 'tron-legacy)
(setq doom-line-numbers-style 'relative)
(setq display-line-numbers-type 'relative)

(when (file-directory-p "/usr/share/emacs/site-lisp/mu4e" )
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e"))

 (use-package mu4e
   :ensure nil
   :load-path "/usr/share/emacs/site-lisp/mu4e/"
   ;; :defer 20 ; Wait until 20 seconds after startup
   :config

   ;; This is set to 't' to avoid mail syncing issues when using mbsync
   (setq mu4e-change-filenames-when-moving t)

   ;; Refresh mail using isync every 10 minutes
   (setq mu4e-update-interval (* 10 60))
   (setq mu4e-get-mail-command "mbsync -a")
   (setq mu4e-root-maildir "~/.local/mail")

   (setq mu4e-drafts-folder "/[Gmail]/Drafts")
   (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
   (setq mu4e-refile-folder "/[Gmail]/All Mail")
   (setq mu4e-trash-folder  "/[Gmail]/Trash")

   (setq mu4e-maildir-shortcuts
       '(("/Inbox"             . ?i)
         ("/[Gmail]/Sent Mail" . ?s)
         ("/[Gmail]/Trash"     . ?t)
         ("/[Gmail]/Drafts"    . ?d)
         ("/[Gmail]/All Mail"  . ?a))))

;TODO: encrypt the password
(require 'circe)
(setq circe-reduce-lurker-spam t)
(circe-set-display-handler "JOIN" (lambda (&rest ignored) nil))

(use-package org-auto-tangle
  :load-path "site-lisp/org-auto-tangle/"    ;; this line is necessary only if you cloned the repo in your site-lisp directory
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(when (file-exists-p (concat (getenv "DOOMDIR") "/private.el"))
  (load! (concat (getenv "DOOMDIR") "/private")))

(setq org-directory "~/org/")

(use-package frog-jump-buffer :ensure t)
(unbind-key (kbd "C-x C-b")) ;unbind the default buffer manager
(global-set-key (kbd "C-x C-b") #'frog-jump-buffer)
;;these two are some kind of fallback

;; configure all-the-icons-ivy to have icons in the frog-jumper popup
(use-package all-the-icons-ivy
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(setq frog-jump-buffer-use-all-the-icons-ivy t)

;;excluded buffers
(dolist (regexp '("^\\*Native-compile-log" "^\\*Async-native-compile-log" "^\\*Messages"))
  (push regexp frog-jump-buffer-ignore-buffers))

(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

(setq vterm-kill-buffer-on-exit t
      vterm-term-environment-variable "xterm"
      vterm-shell "/bin/zsh")

(add-hook 'vterm-mode-hook
          (lambda ()
            (local-set-key (kbd "M-:") 'eval-expression)))

(add-hook 'vterm-mode-hook
          (lambda ()
            (local-set-key (kbd "M-c") 'hydra-lerna/body)))

(add-hook 'vterm-mode-hook
          (lambda ()
            (setq mode-line-format (default-value 'mode-line-format))))

(defhydra hydra-god-mode (:body-pre (message "god mode started")
                          :post     (message "god mode exited."))
  "god mode"
  ("p" previous-line)
  ("n" next-line)
  ("b" backward-char)
  ("f" forward-char)
  ("a" doom/backward-to-bol-or-indent)
  ("e" doom/forward-to-last-non-comment-or-eol)
  ("j" electric-newline-and-maybe-indent)
  ("k" kill-line)
  ("o" open-line)
  ("ga" beginning-of-buffer)
  ("ge" end-of-buffer)
  ("q" nil "quit"))

(defhydra hydra-modes ( :color pink :exit t)
  "various major modes"
  ("t" text-mode "text mode")
  ("o" org-mode "org mode")
  ("w" writeroom-mode "writeroom mode")
  ("e" emacs-lisp-mode "elisp mode")
  ("g" hydra-god-mode/body "activate hydra-god-mode")
  ("q" nil "quit"))

(defhydra hydra-lerna ( :exit t :foreign-keys nil )
  "various stuff"
  ("y" (lambda (arg)
         "Copy lines (as many as prefix argument) in the kill ring"
         (interactive "p")
         (kill-ring-save (line-beginning-position)
                         (line-beginning-position (+ 1 arg)))
         (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
   "copy-line")
  ("T" (lambda () (interactive) (telega t)) "telega")
  ("tc" telega-chat-with "chat with..")
  ("tq" telega-kill "kill telega")
  ("p" password-store-copy "pass-store copy")
  ("M-p" password-store-copy-field "pass-store copy field"))

(defhydra hydra-buffer (:exit t
                        :hint nil)
  "
^manage buffers^
_c_: create buffer      _p_: prev buffer
_k_: kill buffer        _n_: next buffer
_i_: ibuffer
"
  ("c" +default/new-buffer)
  ("k" kill-this-buffer )
  ("n" next-buffer )
  ("p" previous-buffer)
  ("i" ibuffer))

(defhydra hydra-ibuffer-main (:color pink :hint nil)
  "
 ^Navigation^ | ^Mark^        | ^Actions^        | ^View^
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
  _k_:    ʌ   | _m_: mark     | _D_: delete      | _g_: refresh
 _RET_: visit | _u_: unmark   | _S_: save        | _s_: sort
  _j_:    v   | _*_: specific | _a_: all actions | _/_: filter
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
"
  ("j" ibuffer-forward-line)
  ("RET" ibuffer-visit-buffer :color blue)
  ("k" ibuffer-backward-line)

  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)

  ("D" ibuffer-do-delete)
  ("S" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)

  ("g" ibuffer-update)
  ("s" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)

  ("o" ibuffer-visit-buffer-other-window "other window" :color blue)
  ("q" kill-this-buffer "quit ibuffer" :color blue)
  ("." nil "toggle hydra" :color blue))

(defhydra hydra-ibuffer-mark (:color teal :columns 5
                              :after-exit (hydra-ibuffer-main/body))
  "Mark"
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-action (:color teal :columns 4
                                :after-exit
                                (if (eq major-mode 'ibuffer-mode)
                                    (hydra-ibuffer-main/body)))
  "Action"
  ("A" ibuffer-do-view "view")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
  ("b" nil "back"))

(defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
  "Filter"
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body)

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(define-key dired-mode-map "." 'hydra-dired/body)

(map! :leader
      (:desc "modes" "m" #'hydra-modes/body)
      (:desc "pass-store-copy" "M-p" #'password-store-copy)
      (:desc "pass-Store-Copy-Field" "C-M-p" #'password-store-copy-field)
      (:desc "buffer management" "b" #'hydra-buffer/body))

(global-set-key (kbd "C-\\") #'undo)
(global-set-key (kbd "M-:") #'eval-expression) ;just to enforce it. maybe not needed? TODO: investigate

(unbind-key (kbd "C-k"))
(global-set-key (kbd "C-k") #'crux-kill-whole-line)

(unbind-key (kbd "M-%"))
(global-set-key (kbd "M-%") #'vr/replace)

(unbind-key (kbd "M-c"))
(global-set-key (kbd "M-c") #'hydra-lerna/body)

(setq telega-server-libs-prefix "/usr")
(add-hook 'telega-load-hook 'telega-notifications-mode)
(add-hook 'telega-load-hook 'telega-appindicator-mode)
(setq telega-appindicator-use-labels t)

(setq telega-chat-input-markups '("org" "markdown2"))
(setq telega-directory (concat (getenv "XDG_DATA_HOME") "/telega"))
(setq telega-emoji-font-family "Iosevka Nerd Font")
(setq telega-emoji-use-images t)
(add-hook 'telega-chat-mode-hook 'toggle-truncate-lines)
(add-hook 'telega-load-hook 'telega-mode-line-mode)

(use-package exwm
  :config
  ;; Set the default number of workspaces
  ;;   (setq exwm-workspace-number 9)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  ;; When window title updates, use it to set the buffer name
  (add-hook 'exwm-update-title-hook #'efs/exwm-update-title)

  ;; Configure windows as they're created
                                        ;(add-hook 'exwm-manage-finish-hook #'efs/configure-window-by-class)

  ;; When EXWM starts up, do some extra confifuration
  (add-hook 'exwm-init-hook #'efs/exwm-init-hook)

  ;; NOTE: Uncomment the following two options if you want window buffers
  ;;       to be available on all workspaces!


  ;; Automatically move EXWM buffer to current workspace when selected
  (setq exwm-layout-show-all-buffers t)

  ;; Display all EXWM buffers in every workspace buffer list
  (setq exwm-workspace-show-all-buffers t)

  ;; NOTE: Uncomment this option if you want to detach the minibuffer!
  ;; Detach the minibuffer (show it with exwm-workspace-toggle-minibuffer)
  ;;(setq exwm-workspace-minibuffer-position 'top)
  (setq exwm-layout-show-all-buffers t ; Automatically move EXWM buffer to current workspace when selected
        exwm-workspace-show-all-buffers t ; Display all EXWM buffers in every workspace buffer list
        )


  ;; Set the screen resolution (update this to be the correct resolution for your screen!)
  (require 'exwm-randr)
  (exwm-randr-enable)

  ;; This will need to be updated to the name of a display!  You can find
  ;; the names of your displays by looking at arandr or the output of xrandr
  (setq exwm-randr-workspace-monitor-plist '(0 "HDMI-1"
                                             1 "HDMI-2"
                                             2 "HDMI-2"
                                             3 "HDMI-2"
                                             4 "HDMI-2"
                                             5 "VGA1-1"
                                             6 "LVDS-1"
                                             7 "LVDS-1"
                                             8 "LVDS-1"
                                             9 "LVDS-1"))
  ;; Automatically send the mouse cursor to the selected workspace's display
  (setq exwm-workspace-warp-cursor t)

  ;; Window focus should follow the mouse pointer
  (setq mouse-autoselect-window t
        focus-follows-mouse t)

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          (,(kbd "s-r") . exwm-reset)

          ;; Move between windows
          (,(kbd "s-h") . windmove-left)
          (,(kbd "s-l") . windmove-right)
          (,(kbd "s-k") . windmove-up)
          (,(kbd "s-j") . windmove-down)
          (,(kbd "s-H") . shrink-window-horizontally)
          (,(kbd "s-L") . enlarge-window-horizontally)

          ;; Launch applications via shell command
          (,(kbd "s-p") . (lambda (command)
                            (interactive (list (read-shell-command "$ ")))
                            (start-process-shell-command command nil command)))

          ;; Switch workspace
          (,(kbd "s-w") . exwm-workspace-switch)
          (,(kbd "s-v") . +vterm/toggle)
          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))



  (exwm-input-set-key (kbd "s-SPC")  #'eshell)
  (exwm-input-set-key (kbd "s-<return>") (lambda ()
                                           (interactive)
                                           (+vterm/here "~/")))

  (cl-macrolet ((bwrapper (file &optional (title file))
                          `(lambda () (interactive)
                             (start-process-shell-command
                              ,title nil (expand-file-name ,file "~/.local/bin/bw/"))))
                (start (name)
                       `(lambda () (interactive)
                          (start-process ,name nil ,name))))
    (map! :leader
          (:prefix-map ("x" . "X11 applications")
                       (:desc "brave wrapped"         "b" (bwrapper "brave"))
                       (:desc "deltachat wrapped"     "d" (bwrapper "deltachat-desktop" "deltachat"))
                       (:desc "whatsdesk wrapped"     "w" (bwrapper "whatsdesk"))
                       (:desc "telegram wrapped"      "t" (bwrapper "telegram-desktop"))
                       (:desc "lycheeslicer wrapped"  "M-l" (bwrapper "lycheeslicer"))
                       (:desc "librewolf unwrapped"   "l" (start "librewolf"))
                       ))
    ) ;; cl-macrolet ends here
  ) ;; (use-package) exwm ends here

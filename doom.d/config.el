;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(eval-when-compile (require 'cl-lib))

 (require 'tab-bar)
 (require 'xterm-color nil t)

 (defgroup xmobar nil
   "xmobar status display for Emacs."
   :version "0.0.1"
   :group 'mode-line)

 (defcustom xmobar-command '("~/.local/bin/xmobar-emacs" "-TAnsi")
   "The xmobar command and flags."
   :type '(choice (string :tag "Shell Command")
                  (repeat (string))))

 (defcustom xmobar-tab-bar t
   "Whether to dispaly xmobar output in the tab bar."
   :type 'boolean)
 (setq xmobar-tab-bar nil)
 (defcustom xmobar-tab-split nil
   "Split on this string for `xmobar-left-string' and `xmobar-right-string'."
   :type 'string)

 (defcustom xmobar-tab-bar-format
   '(xmobar-left-string xmobar-elastic-space xmobar-right-string)
   "Format for the tab bar when `xmobar-tab-bar' is t."
   :type 'list)

 (defvar xmobar--process nil
   "The running xmobar process, if any.")

 (defvar xmobar--left-string "")

 (defvar xmobar-string ""
   "The xmobar string to be displayed in the mode-line or tab-bar.")

 (put 'xmobar-string 'risky-local-variable t)

 (defvar xmobar--colorize-fn
   (if (featurep 'xterm-color) #'xterm-color-filter #'ansi-color-apply))

 (defvar xmobar--old-tab-format tab-bar-format)
 (defvar xmobar--len 0)

 (defun xmobar-string () xmobar-string)
 (defun xmobar-right-string () xmobar-string)
 (defun xmobar-left-string () xmobar--left-string)
 (defun xmobar-elastic-space () (make-string (- (frame-width) xmobar--len 3) ? ))

 ;;;###auto
 (define-minor-mode xmobar-mode
   "Display an xmobar in the mode-line."
   :global t :group 'xmobar
   (xmobar--stop)
   (if xmobar-mode
       (progn (if xmobar-tab-bar
                  (progn
                    (setq xmobar--old-tab-format tab-bar-format)
                    (setq tab-bar-format xmobar-tab-bar-format)
                    (tab-bar-mode 1))
                (or global-mode-string (setq global-mode-string '("")))
                (unless (memq 'xmobar-string global-mode-string)
                  (add-to-list 'global-mode-string 'xmobar-string t)))
              (xmobar--start))
     (when xmobar-tab-bar (setq tab-bar-format xmobar--old-tab-format))))

 (defun xmobar--update (update)
   "Apply an UPDATE to the xmobar bar."
   (when xmobar-mode
     (let* ((str (funcall xmobar--colorize-fn update))
            (strs (and xmobar-tab-split (split-string str xmobar-tab-split))))
       (setq xmobar-string (if strs (cadr strs) str)
             xmobar--left-string (or (car strs) "")
             xmobar--len (+ (string-width xmobar--left-string)
                            (string-width xmobar-string))))
     (force-mode-line-update t)))

 (defun xmobar--process-filter (proc string)
   "Process output from the xmobar process."
   (let ((buf (process-buffer proc)))
     (when (buffer-live-p buf)
       (with-current-buffer buf
         ;; Write the input to the buffer (might be partial).
         (save-excursion
           (goto-char (process-mark proc))
           (insert string)
           (set-marker (process-mark proc) (point)))
         (when (string-match-p "\n$" string)
           (xmobar--update (buffer-substring (point-min) (- (point-max) 1)))
           (delete-region (point-min) (point-max)))))))

 (defun xmobar--process-sentinel (proc status)
   "Handle events from the xmobar process (PROC).
 If the process has exited, this function stores the exit STATUS in
 `xmobar-string'."
   (unless (process-live-p proc)
     (setq xmobar--process nil)
     (let ((buf (process-buffer proc)))
       (when (and buf (buffer-live-p buf)) (kill-buffer buf)))
     (setq xmobar-string (format "xmobar: %s" status) xmobar--left-string "")))

 (defun xmobar--start ()
   "Start xmobar."
   (xmobar--stop)
   (condition-case err
       (setq xmobar--process
             (make-process
              :name "xmobar"
              :buffer " *xmobar process*"
              :stderr " *xmobar stderr*"
              :command (ensure-list xmobar-command)
              :connection-type 'pipe
              :noquery t
              :sentinel #'xmobar--process-sentinel
              :filter #'xmobar--process-filter))
     (error
      (setq xmobar-string
            (format "starting xmobar: %s" (error-message-string err))
            xmobar--left-string ""))))

 (defun xmobar--stop ()
   "Stop xmobar."
   (when (and xmobar--process (process-live-p xmobar--process))
     (delete-process xmobar--process))
   (setq xmobar-string "" xmobar--left-string ""))

 ;;;###autoload
 (defun xmobar-restart ()
   "Restart the xmobar program."
   (interactive)
   (unless xmobar-mode (user-error "The xmobar-mode is not enabled"))
   (xmobar--start))

 (provide 'xmobar)

 (defun xmobartrayer ()
   (interactive)
   "this just spawns the trayer for xmobar"
   (start-process-shell-command "trayer" nil "s6-rc -l /tmp/formula/s6-rc -u change trayer"))

(defun restart-xmobar-trayer ()
  "restarts trayers for xmobar"
  (interactive)
  (start-process-shell-command "pkill" nil "s6-svc -r /tmp/formula/service/trayer"))

(add-hook 'xmobar-mode-hook #'xmobartrayer)

(add-hook 'xmobar-restart-hook #'restart-xmobar-trayer)

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 15))

(require 'doom-modeline)
(doom-modeline 1)
(setq doom-modeline-support-imenu t
      doom-modeline-height  10
      doom-modeline-hud     t
      doom-modeline-icons   t)
(setq truncate-lines nil)

(setq vterm-kill-buffer-on-exit t)
(setq vterm-term-environment-variable "xterm")
(setq vterm-shell "/bin/zsh")

(setq doom-theme 'monochrome)
(setq doom-line-numbers-style 'relative)
(setq display-line-numbers-type 'relative)
 ;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
 (setq org-directory "~/org/")

(load! (concat (getenv "DOOMDIR") "/private"))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
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
   (setq mu4e-root-maildir "~/mail")

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

(setq org-directory "~/org/")
(load! (concat (getenv "DOOMDIR") "/private"))

(use-package frog-jump-buffer :ensure t)
(unbind-key (kbd "C-x C-b"))
(global-set-key (kbd "C-x C-b") #'frog-jump-buffer)
(global-set-key (kbd "C-x b") #'ibuffer)
(setq frog-jump-buffer-use-all-the-icons-ivy t)
(dolist (regexp '("^\\*Native-compile-log" "^\\*Async-native-compile-log" "^\\*Messages"))
  (push regexp frog-jump-buffer-ignore-buffers))

(when (string= (doom-system-distro) "gentoo")
(require 'portage)
(require 'magentoo))

(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

(defhydra hydra-window ()
   "
Movement^^        ^Split^         ^Switch^		^Resize^
----------------------------------------------------------------
_h_ ←       	_v_ertical                  	_q_ X←
_j_ ↓        	_x_ horizontal	_f_ind files	_w_ X↓
_k_ ↑        	_z_ undo      	_a_ce 1		_e_ X↑
_l_ →        	_Z_ reset      	_s_wap		_r_ X→
_F_ollow		_D_lt Other   	_S_ave		max_i_mize
_SPC_ cancel	   	_d_elete
"
   ("h" windmove-left )
   ("j" windmove-down )
   ("k" windmove-up )
   ("l" windmove-right )
   ("q" hydra-move-splitter-left)
   ("w" hydra-move-splitter-down)
   ("e" hydra-move-splitter-up)
   ("r" hydra-move-splitter-right)
  ; ("b" helm-mini)
   ("f" helm-find-files)
   ("F" follow-mode)
   ("a" (lambda ()
          (interactive)
          (ace-window 1)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
       )
   ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
       )
   ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
       )
   ("s" (lambda ()
          (interactive)
          (ace-window 4)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body)))
   ("S" save-buffer)
   ("d" delete-window)
   ("D" (lambda ()
          (interactive)
          (ace-window 16)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
       )
 ;  ("o" delete-other-windows)
   ("i" ace-maximize-window)
   ("z" (progn
          (winner-undo)
          (setq this-command 'winner-undo))
   )
   ("Z" winner-redo)
   ("SPC" nil)
   )

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

(map! :leader
      (:desc "modes" "m" #'hydra-modes/body)
      (:prefix-map ("b" . "buffer")
                   (:desc "new buffer"            "n" #'+default/new-buffer)
                   (:desc "kill this buffer"      "k" #'kill-this-buffer))
      (:prefix-map ("t" . "toggle")
                   (:prefix-map ("t" . "telega")
                                (:desc "start telega"       "t" (lambda () (interactive) (telega t))
                                       (:desc "telega chat with"   "c" #'telega-chat-with)
                                       (:desc "kill telega"        "q" #'telega-kill)))
                   (:prefix-map ("M-p" . "portage")
                                ))
      )

(global-set-key (kbd "C-\\") #'undo)

(defun efs/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)
  (xmobar-mode))

(use-package exwm
   :config
   ;; Set the default number of workspaces
   (setq exwm-workspace-number 9)

   ;; When EXWM starts up, do some extra confifuration
   (add-hook 'exwm-init-hook #'efs/exwm-init-hook)

   ;; NOTE: Uncomment the following two options if you want window buffers
   ;;       to be available on all workspaces!


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
                            ,title nil (expand-file-name ,file "~/.local/bin/"))))
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
                   )
) ; (use-package) exwm ends here

(defun efs/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)
  (xmobar-mode))

(defun efs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun efs/exwm-update-title ()
  (pcase exwm-class-name
    ("Librewolf" (exwm-workspace-rename-buffer (format "Librewolf: %s" exwm-title)))))

;; This function isn't currently used, only serves as an example how to
;; position a window
(defun efs/position-window ()
  (let* ((pos (frame-position))
         (pos-x (car pos))
          (pos-y (cdr pos)))
    (exwm-floating-move (- pos-x) (- pos-y))))

 (add-hook 'exwm-mode-hook '(lambda ()
                              (local-set-key (kbd "C-x C-b") #'consult-buffer)))

 (use-package exwm
   :config
   ;; Set the default number of workspaces
   (setq exwm-workspace-number 9)

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
           ([?\s-r] . exwm-reset)

           ;; Move between windows
            ([?\s-h] . windmove-left)
            ([?\s-l] . windmove-right)
            ([?\s-k] . windmove-up)
            ([?\s-j] . windmove-down)
            ([?\s-H] . shrink-window-horizontally)
            ([?\s-L] . enlarge-window-horizontally)

           ;; Launch applications via shell command
           ([?\s-p] . (lambda (command)
                        (interactive (list (read-shell-command "$ ")))
                        (start-process-shell-command command nil command)))

           ;; Switch workspace
           ([?\s-w] . exwm-workspace-switch)
           ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))
           ([?\s-v] . +vterm/toggle)
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
                                 ,title nil (expand-file-name ,file "~/.local/bin/"))))
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
       )
)

;; (setq telega-server-libs-prefix "/usr")
 (add-hook 'telega-load-hook 'telega-notifications-mode)
 (add-hook 'telega-load-hook 'telega-appindicator-mode)
 (setq telega-appindicator-use-labels t)

 ;(setq telega-chat-input-markups '(nil "org" "markdown2"))
 (setq telega-chat-input-markups '("org" "markdown2"))
 (setq telega-directory (concat (getenv "XDG_DATA_HOME") "/telega"))
 (setq telega-emoji-font-family "TerminessTTF Nerd Font")
 (setq telega-emoji-use-images 'nil)
 (add-hook 'telega-chat-mode-hook 'toggle-truncate-lines)

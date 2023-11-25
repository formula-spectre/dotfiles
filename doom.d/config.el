;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(straight-use-package 'leaf)
(straight-use-package 'leaf-keywords)


(require 'leaf)
(require 'leaf-keywords)
(leaf leaf-keywords
      :config (leaf-keywords-init))

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 15))

(leaf doom-modeline
  :straight t
  :setq
    ((doom-modeline-support-imenu . t)
       (doom-modeline-height . 10)
       (doom-modeline-hud . t)
       (doom-modeline-icons . t)
       (doom-modeline-buffer-file-name-style . 'auto)
       (doom-modeline-major-mode-color-icon . t)
       (doom-modeline-buffer-state-icon . t)
       (doom-modeline-buffer-modification-icon . t)
       (doom-modeline-major-mode-icon . t)))
(setq truncate-lines nil)
(remove-hook 'vterm-mode-hook #'hide-mode-line-mode)

(leaf cyberpunk
  :config
  (load-theme 'cyberpunk t))

(setq doom-line-numbers-style 'relative)
(setq display-line-numbers-type 'relative)

(leaf mu4e
  :setq (
  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (mu4e-change-filenames-when-moving . t)

  ;resh mail using isync every 10 minutes
  (mu4e-get-mail-command . "mbsync -a")
  (mu4e-root-maildir . "~/.local/mail")

  (mu4e-drafts-folder . "/[Gmail]/Drafts")
  (mu4e-sent-folder . "/[Gmail]/Sent Mail")
  (mu4e-refile-folder . "/[Gmail]/All Mail")
  (mu4e-trash-folder . "/[Gmail]/Trash")

  (mu4e-maildir-shortcuts .
        '(("/Inbox"             . ?i)
          ("/[Gmail]/Sent Mail" . ?s)
          ("/[Gmail]/Trash"     . ?t)
          ("/[Gmail]/Drafts"    . ?d)
          ("/[Gmail]/All Mail"  . ?a)))))

;TODO: encrypt the password
(leaf circe
  :setq
  (circe-reduce-lurker-spam .t))
;; (circe-set-display-handler "JOIN" (lambda (&rest ignored) nil))

(setq org-directory "~/org/")

(leaf org-modern
  :straight t
  :hook ((org-mode-hook . org-modern-mode)))

(use-package org-auto-tangle
  :load-path "site-lisp/org-auto-tangle/"    ;; this line is necessary only if you cloned the repo in your site-lisp directory
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(leaf org
  :hook ((org-mode-hook . org-auto-tangle-mode)
         (org-mode-hook . org-indent-mode))
  :config
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist
               '("m" . "src emacs-lisp")
               '("sw" "src conf-space")))

(after! org-babel
    (add-to-list 'org-src-lang-modes '("sway" . sway-lang-mode)))
(after! org-babel
    (add-to-list 'org-src-lang-modes '("sway" . sway-mode)))

(leaf ibuffer
  :setq ((ibuffer-default-sorting-mode 'major-mode))
  :hook ((ibuffer-mode-hook . ibuffer-auto-mode))
  :bind ("C-x b". ibuffer))

(when (file-exists-p (concat (getenv "DOOMDIR") "/private.el"))
  (load! (concat (getenv "DOOMDIR") "/private")))

(leaf all-the-icons-ivy
    :straight t
    :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(leaf frog-jump-buffer
    :straight t    
    :init (setq frog-jump-buffer-use-all-the-icons-ivy t)
    :bind ("C-x C-b" . frog-jump-buffer))

(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

(setq vterm-kill-buffer-on-exit t
      vterm-term-environment-variable "xterm"
      vterm-shell "/bin/nu")

(add-hook 'vterm-mode-hook
          (lambda ()
            (local-set-key (kbd "M-:") 'eval-expression)))

(leaf crux
  :straight t
  :bind ("C-k" . crux-kill-whole-line))

(leaf visual-regexp-steroids
  :straight t
  :bind ([remap query-replace] . vr/replace))

(leaf avy
  :bind ([remap isearch-forward] . swiper))

;; (leaf prism
;;   :straight t
;;   :hook ((prog-mode-hook . prism-mode)))

(leaf ement
  :straight t
  :setq
  (ement-save-sessions . t)
;  :config
;  ((keymap-set ement-room-minibuffer-map "TAB" 'completion-at-point)))
  )
;; #FIXME!
(require 'ement)
(setq ement-save-sessions t)

(defhydra hydra-modes ( :color pink :exit t)
  "various major modes"
  ("t" text-mode "text mode")
  ("o" org-mode "org mode")
  ("w" writeroom-mode "writeroom mode")
  ("e" emacs-lisp-mode "elisp mode")
  ("q" nil "quit"))

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

(map! :leader
      (:desc "modes" "m" #'hydra-modes/body)
      (:desc "pass-store-copy" "M-p" #'password-store-copy)
      (:desc "pass-Store-Copy-Field" "C-M-p" #'password-store-copy-field)
      (:desc "buffer management" "b" #'hydra-buffer/body)
      (:prefix-map ("t" . "toggle")
                   (:prefix-map ("t" . "telega")
                                (:desc "start telega"       "t" (lambda () (interactive) (telega t)))
                                        ;(:desc "start telega"       "t" #'telega)
                                (:desc "telega chat with"   "c" #'telega-chat-with)
                                (:desc "kill telega"        "q" #'telega-kill)
                                (:desc "pop telega rootbuf" "r" (lambda ()
                                                                  (interactive)
                                                                  (switch-to-buffer "*Telega Root*")))))
      (:prefix-map ("e" . "eval")
                   (:prefix-map ("e" . "ement")
                                (:desc "start ement"    "e" #'ement-connect)
                                (:desc "quit ement"     "q" #'ement-disconnect)))
      )

(global-set-key (kbd "C-\\") #'undo)
(global-set-key (kbd "M-:") #'eval-expression) ;just to enforce it. maybe not needed? TODO: investigate

(leaf telega
  :hook
  ((telega-load-hook . telega-notifications-mode)
   (telega-load-hook . telega-appindicator-mode)
   (telega-load-hook . telega-mode-line-mode))
  :setq
  ((telega-server-libs-prefix . "/usr")
   (telega-appindicator-use-labets . t)
   (telega-chat-input-markups . '("org" "markdown2"))
   (telega-emoji-font-family . "Iosevka Nerd Font")
   (telega-emoji-use-images . t))
  ;; :bind
  ;; (:global-map
  ;;  ("C-c t t" . telega-prefix-map))
  )

;; #FIXME! 
(require 'telega)
(define-key global-map (kbd "C-c t t") telega-prefix-map)

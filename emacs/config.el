(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package) ;;required to have leaf/use-package's :straight keyword

(straight-use-package 'leaf)
(straight-use-package 'leaf-keywords)

(require 'leaf)
(require 'leaf-keywords)
(leaf leaf-keywords
  :config (leaf-keywords-init))

(leaf all-the-icons-ivy :straight t)
(leaf hydra :straight t)
(leaf eglot :straight t)
(leaf nerd-icons :straight t)
(leaf all-the-icons-ivy :straight t)
(leaf general :straight t)
(leaf god-mode :straight t)
(leaf zen-mode :straight t)
(leaf writeroom-mode :straight t)

(leaf cyberpunk-theme
  :straight t
  :config
  (load-theme 'cyberpunk t))

(use-package emacs
  :straight nil
  :config
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (global-visual-line-mode 1)
  (global-display-line-numbers-mode)
  (setq display-line-numbers-type 'relative))

(setq inhibit-startup-message t
      initial-scratch-message nil)

(set-frame-font "Iosevka Nerd Font 10" nil t)

(leaf doom-modeline
  :straight t
  :init (doom-modeline-mode 1)
  :config
(setq doom-modeline-support-imenu t
      doom-modeline-height  25
      doom-modeline-hud     t
      doom-modeline-icons   t
      doom-modeline-buffer-file-name-style 'auto
      doom-modeline-major-mode-color-icon t
      doom-modeline-buffer-state-icon t
      doom-modeline-buffer-modification-icon t
      doom-modeline-major-mode-icon t))

(require 'general)
(general-auto-unbind-keys)

(defhydra main-hydra (global-map "C-c" :exit t)
  "one hydra to rule them all"
  ("f" hydra-emacs-files/body "emacs files")
  ("b" hydra-buffers/body "buffer management")
  ("m" hydra-modes/body "major modes")
  ("o" hydra-open/body "open stuff"))

(defhydra hydra-emacs-files (:exit t :hint nil)
  "
hydra to open personal emacs configuration.
^emacs files^            actions
^--------------------------------
_p_: open config.org     _r_: reload 
_i_: open init.el
_e_: open early-init.el
"
  ("p" (lambda ()
         (interactive)
         (find-file (expand-file-name "config.org" user-emacs-directory))))
  ("i" (lambda ()
         (interactive)
         (find-file user-init-file)))
  ("e" (lambda ()
         (interactive)
         (find-file (expand-file-name "early-init.el" user-emacs-directory))))
  ("r" (lambda ()
         (interactive)
         (org-babel-load-file (expand-file-name
                               "config.org"
                               user-emacs-directory)))))

(defhydra hydra-buffers (:exit t :hint nil)
  "
hydra to wrangle buffers.
^buffers^              ^navigation^           ^misc^  
^---------------------------------------------------
_k_: kill this buffer   _n_: next-buffer       _s_: switch to scratch
_c_: create buffer      _p_: previous buffer   
"
  ("k" kill-this-buffer)
  ("n" next-buffer)
  ("p" previous-buffer)
  ("c" (lambda () 			;;stolen from doom emacs
         (interactive)
         (let ((buffer (generate-new-buffer "*new*")))
           (set-window-buffer nil buffer)
           (with-current-buffer buffer
             (funcall (default-value 'major-mode))))))
  ("s" (lambda ()
         (interactive)
         (switch-to-buffer "*scratch*")))
  )

(defhydra hydra-open (:exit t)
      "
hydra to open various stuff
document me!
  "
      ("e" eshell "eshell"))

(defhydra hydra-modes (:exit t :hint nil)
  "
^an hydra to toggle various major/minor mode
^---------------------------------------------------------------------
   programming            writing               misc      
_l_: toggle lispy mode   _w_: toggle writeroom   _g_: toggle god-mode
                      ^^ _z_: toggle zen mode
                      ^^ _o_: toggle org mode
"
  ("l" lispy-mode )
  ("g" god-mode )
  ("z" zen-mode )
  ("w" writeroom-mode)
  ("o" org-mode))

(defhydra hydra-elisp (:exit t :hint nil)
  "
an hydra for emacs lisp interaction. here are the keybindings:
^Eval^                  ^goto^
^^^^^^^^-------------------------------------
_eb_: eval buffer       _gf_: function
_ed_: eval defun        _gv_: variable
_ee_: eval last sexp    _gl_: library
_er_: eval region
_el_: load library
"
  ("eb" eval-buffer )
  ("ed" eval-defun)
  ("ee" eval-last-sexp)
  ("er" eval-region)
  ("el" load-library)
  ("gf" find-function)
  ("gv" find-variable)
  ("gl" find-library))

(general-define-key
  :keymaps '(lisp-interaction-mode-map emacs-lisp-mode-map)
  :prefix "C-c"
  "l" 'hydra-elisp/body)

(leaf lispy
  :straight t
  :hook ((lisp-mode-hook . lispy-mode)
         (emacs-lisp-mode-hook . lispy-mode)
         (ielm-mode-hook . lispy-mode)
         (scheme-mode-hook . lispy-mode)
         (racket-mode-hook . lispy-mode)
         (hy-mode-hook . lispy-mode)
         (lfe-mode-hook . lispy-mode)
         (dune-mode-hook . lispy-mode)
         (clojure-mode-hook . lispy-mode)
         (fennel-mode-hook . lispy-mode)))

(leaf helm
  :straight t
  :config (helm-mode 1)
  :bind
  ("M-x" . helm-M-x)
  ([remap find-file] . helm-find-files)
  )

(leaf all-the-icons
  :straight t    
  :if (display-graphic-p))

(leaf all-the-icons-ivy
  :straight t    
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(leaf frog-jump-buffer
  :straight t    
  :init (setq frog-jump-buffer-use-all-the-icons-ivy t)
  :bind ("C-x C-b" . frog-jump-buffer))

(leaf kbd-mode
  :straight (kbd-mode :type git :host github :repo "kmonad/kbd-mode")
  :mode "\\.kbd\\'"
  :commands kbd-mode)

(leaf nerd-icons
  :straight t)

(leaf visual-regexp-steroids
  :straight t  
  :bind ([remap query-replace] . vr/replace))

(leaf crux
  :straight t    
  :bind ("C-k" . crux-kill-whole-line))

(leaf which-key
  :straight t    
  :config (which-key-mode))

(leaf company
  :straight t    
  :commands company-mode
  :init (add-hook 'after-init-hook #'global-company-mode))

(leaf eshell
  :straight t)

(leaf org-modern
  :straight t
  :hook ((org-mode-hook . org-modern-mode)))

(leaf rainbow-delimiters
  :straight t    
  :hook ((lisp-mode-hook . rainbow-delimiters-mode)
           (emacs-lisp-mode-hook . rainbow-delimiters-mode)
           (ielm-mode-hook . rainbow-delimiters-mode)
           (scheme-mode-hook . rainbow-delimiters-mode)
           (racket-mode-hook . rainbow-delimiters-mode)
           (hy-mode-hook . rainbow-delimiters-mode)
           (lfe-mode-hook . rainbow-delimiters-mode)
           (dune-mode-hook . rainbow-delimiters-mode)
           (clojure-mode-hook . rainbow-delimiters-mode)
           (fennel-mode-hook . rainbow-delimiters-mode)))

(leaf ibuffer
  :straight t    
  :bind ("C-x b" . ibuffer))

(leaf avy
  :bind ([remap isearch-forward] . swiper))

(leaf org
  :hook ((org-mode-hook . org-auto-tangle-mode)
         (org-mode-hook . org-indent-mode))
  :config
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist
               '("m" . "src emacs-lisp")
               '("s" . "src")))

(leaf org-auto-tangle 
  :straight t
  :after async)

(leaf hl-todo
  :straight t
  :hook ((prog-mode-hook . hl-todo-mode)
         (org-mode-hook . hl-todo-mode)))

(leaf helpful
  :straight t
  :custom
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ("C-h f" . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

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

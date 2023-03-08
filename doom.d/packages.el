;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.
;;

;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)
(package! ednc)
(package! vterm)
(package! ement)
(package! org-caldav)
;;(package! telega)
;;(package! pdf-tools)
(package! w3m)
;(package! neotree)
;(package! exwm)
(package! dot-mode)
;(package! mu4e)
;(package! cyberpunk-theme)
;(package! wand)


;(package! feebleline)
;(package! autothemer)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))
;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

(package! keychain-enironment
  :recipe (:host github :repo "tarsius/keychain-environment"
                 :files ("keychain-environment.el")))
(package! pomodoro.el
  :recipe (:host github :repo "baudtack/pomodoro.el"
                 :files ("pomodoro.el")))
(package! gitconfig-mode
  :recipe (:host github :repo "magit/git-modes"
           :files ("gitconfig-mode.el")))

(package! gitignore-mode
  :recipe (:host github :repo "magit/git-modes"
           :files ("gitignore-mode.el")))

(package! kbd-mode
  :recipe (:host github
           :repo "kmonad/kbd-mode"))

;(package! almost-mono-theme
;   :recipe (:host github :repo "cryon/almost-mono-themes"))
(package! monochrome
  :recipe (:host github :repo "fxn/monochrome-theme.el"))

(package! sxhkd-mode
  :recipe (:host github :repo "xFA25E/sxhkd-mode"))
;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)
;;(package! dired :disable)
;;(package! doom-modeline :disable t)
;;disable all evil related things
;;(package! evil-dvorak :disable t)
;;(package! evil-easymotion :disable t)
;;(package! evil-ediff :disable t)
;;(package! evil-embrace :disable t)
;;(package! evil-escape :disable t)
;;(package! evil-ex-fasd :disable t)
;;(package! evil-ex-shell-command :disable t)
;;(package! evil-exchange :disable t)
;;(package! evil-exchange :disable t)
;;(package! evil-expat :disable t)
;;(package! evil-extra-operator :disable t)
;;(package! evil-find-char-pinyin :disable t)
;;(package! evil-fringe-mark :disable t)
;;(package! evil-god-state :disable t)
;;(package! evil-goggles :disable t)
;;(package! evil-goggles :disable t)
;;(package! evil-iedit-state :disable t)
;;(package! evil-indent-plus :disable t)
;;(package! evil-indent-plus :disable t)
;;(package! evil-indent-textobject :disable t)
;;(package! evil-leader :disable t)
;;(package! evil-ledger :disable t)
;;(package! evil-lion :disable t)
;;(package! evil-lisp-state :disable t)
;;(package! evil-lisp-state :disable t)
;;(package! evil-lispy :disable t)
;;(package! evil-mark-replace :disable t)
;;(package! evil-matchit :disable t)
;;(package! evil-matchit :disable t)
;;(package! evil-mc :disable t)
;;(package! evil-mc-extras :disable t)
;;(package! evil-mu4e :disable t)
;;(package! evil-multiedit :disable t)
;;(package! evil-nerd-commenter :disable t)
;;(package! evil-nerd-commenter :disable t)
;;(package! evil-nl-break-undo :disable t)
;;(package! evil-numbers :disable t)
;;(package! evil-numbers :disable t)
;;(package! evil-opener :disable t)
;;(package! evil-org :disable t)
;;(package! evil-owl :disable t)
;;(package! evil-paredit :disable t)
;;(package! evil-pinyin :disable t)
;;(package! evil-python-movement :disable t)
;;(package! evil-quickscope :disable t)
;;(package! evil-rails :disable t)
;;(package! evil-replace-with-char :disable t)
;;(package! evil-replace-with-register :disable t)
;;(package! evil-rsi :disable t)
;;(package! evil-ruby-text-objects :disable t)
;;(package! evil-search-highlight-persist :disable t)
;;(package! evil-smartparens :disable t)
;;(package! evil-snipe :disable t)
;;(package! evil-space :disable t)
;;(package! evil-string-inflection :disable t)
;;(package! evil-surround :disable t)
;;(package! evil-swap-keys :disable t)
;;(package! evil-tabs :disable t)
;;(package! evil-terminal-cursor-changer :disable t)
;;(package! evil-test-helpers :disable t)
;;(package! evil-tex :disable t)
;;(package! evil-text-object-python :disable t)
;;(package! evil-textobj-anyblock :disable t)
;;(package! evil-textobj-column :disable t)
;;(package! evil-textobj-entire :disable t)
;;(package! evil-textobj-line :disable t)
;;(package! evil-textobj-syntax :disable t)
;;(package! evil-textobj-tree-sitter :disable t)
;;(package! evil-traces :disable t)
;;(package! evil-tree-edit :disable t)
;;(package! evil-tutor :disable t)
;;(package! evil-tutor-ja :disable t)
;;(package! evil-vimish-fold :disable t)
;;(package! evil-visual-mark-mode :disable t)
;;(package! evil-visual-replace :disable t)
;;(package! evil-visualstar :disable t)
;;(package! evil-visualstar :disable t)



;;(package! org-plus-contrib)                                                                                                  
;; You can override the recipe of a built in package without having to specify                                                 
;; all the properties for `:recipe'. These will inherit the rest of its recipe                                                 
;; from Doom or MELPA/ELPA/Emacsmirror:                                                                                        
;(package! builtin-package :recipe (:nonrecursive t))                                                                          
;(package! builtin-package-2 :recipe (:repo "myfork/package"))                                                                 
                                                                                                                               
;; Specify a `:branch' to install a package from a particular branch or tag.                                                   
;; This is required for some packages whose default branch isn't 'master' (which                                               
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")

;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

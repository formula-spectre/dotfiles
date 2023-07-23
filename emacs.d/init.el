(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(pona:portage-dir
   (if
       (file-exists-p "/var/db/repos/gentoo")
       "/var/db/repos/gentoo" "/usr/portage")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-background-face ((t (:foreground "black"))))
 '(avy-lead-face ((t (:background "#e52b50" :foreground "black"))))
 '(avy-lead-face-0 ((t (:background "#4f57f9" :foreground "black"))))
 '(avy-lead-face-1 ((t (:background "gray" :foreground "black"))))
 '(frog-menu-prompt-face ((t (:foreground "black")))))

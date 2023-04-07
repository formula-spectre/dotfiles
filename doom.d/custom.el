(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(akater-misc-privileged-tramp-method "doas")
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00" "7ea883b13485f175d3075c72fceab701b5bf76b2076f024da50dff4107d0db25" "02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" "d0fd069415ef23ccc21ccb0e54d93bdbb996a6cce48ffce7f810826bb243502c" "8f5b54bf6a36fe1c138219960dd324aad8ab1f62f543bed73ef5ad60956e36ae" "e9d47d6d41e42a8313c81995a60b2af6588e9f01a1cf19ca42669a7ffd5c2fde" default))
 '(elfeed-feeds '("https://lobste.rs/rss"))
 '(magentoo-privileged-tramp-method "sudo")
 '(package-selected-packages '(@))
 '(pdf-info-epdfinfo-program "/usr/bin/epdfinfo")
 '(pona:portage-dir
   (if
       (file-exists-p "/var/db/repos/gentoo")
       "/var/db/repos/gentoo" "/usr/portage"))
 '(send-mail-function 'mailclient-send-it)
 '(smtpmail-smtp-server "imap.gmail.com")
 '(smtpmail-smtp-service 25)
 '(warning-suppress-types '((emacs) (emacs) (defvaralias))))
(put 'downcase-region 'disabled nil)
(put 'customize-face 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(vterm-color-blue ((t (:inherit vterm-color-white)))))
(put 'customize-group 'disabled nil)
(put 'customize-variable 'disabled nil)

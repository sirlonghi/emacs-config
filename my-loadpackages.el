; my-loadpackages.el
; loading package
(load "~/.emacs.d/my-packages.el")

;; magit
(require 'magit)
(define-key global-map (kbd "C-c m") 'magit-status)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(yas-load-directory "~/.emacs.d/snippets")
(add-hook 'term-mode-hook (lambda()
    (setq yas-dont-activate t)))

;; evil-mode
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; theme
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

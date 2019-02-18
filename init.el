;; -*- coding: utf-8; lexical-binding: t; -*-

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *is-a-mac* (eq system-type 'darwin))
(setq *win64* (eq system-type 'windows-nt))
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *emacs24* (>= emacs-major-version 24))
(setq *emacs25* (>= emacs-major-version 25))
(setq *emacs26* (>= emacs-major-version 26))

;; wrap line
(global-visual-line-mode t)

;; Mac keys (italian layout)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; no tabs, use spaces instead
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
;; Make tab key do indent first then completion.
(setq-default tab-always-indent 'complete)

;; group all backup files in one place
;; disabled because can cause prolems with Dropbox
;; (setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))

;; Set location for external custom packages.
(add-to-list 'load-path "~/.emacs.d/custom/")

;; babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (latex . t)
   (gnuplot . t)
   (calc . t)
   (lisp . t)
   (python . t)
   (R . t)
   (shell . t)
   (sql . t)
   (org . t)
   (ledger . t)))

;;(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
(setq org-confirm-babel-evaluate nil) 

;; odt exporter via MathML
(setq org-latex-to-mathml-convert-command
      "latexmlmath \"%i\" --presentationmathml=%o")

;; xelatex
(eval-after-load "tex"
    '(add-to-list 'TeX-command-list
                  '("xelatex" "xelatex -interaction=nonstopmode %s"
                    TeX-run-command t t :help "Run xelatex") t))

;; ;; koma-letter
;; (add-to-list 'auto-mode-alist '("\\.lco" . tex-mode))
;; (eval-after-load 'ox '(require 'ox-koma-letter))

;; (eval-after-load 'ox-latex
;;   '(add-to-list 'org-latex-packages-alist '("AUTO" "babel" t) t))

;; org-clock
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer "CLOCKING")
(setq org-log-into-drawer "LOGBOOK")

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
;; %a          annotation, normally the link created with org-store-link
;; %i          initial content, the region when capture is called with C-u.
;; %t, %T      timestamp, date only, or date and time
;; %u, %U      like above, but inactive timestamps
;; %?          After completing the template, position cursor here.


(setq org-capture-templates
      (quote (("t" "todo" entry (file+headline "~/Dropbox/cloudOrg/orgmode.org" "GTD")
               "* TODO %?\n%U\n")
              ("r" "reply" entry (file+headline "~/Dropbox/cloudOrg/orgmode.org" "GTD")
               "* NEXT Mail reply to %:from on %:subject\nEntered on %U\nSCHEDULED: %^t")
              ("n" "note" entry (file+headline "~/Dropbox/cloudOrg/orgmode.org" "Notes")
               "* %? :NOTE:\nEntered on %U\n")
              ("j" "Journal" entry (file+olp+datetree "~/Dropbox/cloudOrg/diary.org")
               "* %?\nEntered on %U\n")
              ("m" "Meeting" entry (file+headline "~/Dropbox/cloudOrg/orgmode.org" "GTD")
               "* MEETING with %? :MEETING:\nEntered on %U\nSCHEDULED: %^T")
              ("p" "Phone call" entry (file+headline "~/Dropbox/cloudOrg/orgmode.org" "GTD")
               "* PHONE %? :PHONE:\nEntered on %U\n")
	      ("w" "org-protocol" entry (file "~/Dropbox/cloudOrg/refile.org")
               "* TODO Review %c\nEntered on %U\n")
	      ("c" "Rescue mission" entry (file+headline "~/Dropbox/cloudOrg/CRI.org" "Missions") "* Mission %^{CODE}p  %^{DIAGNOSIS}p %^{BRIEFING}p\n Entered on %T\n")
              ("h" "Habit" entry (file+headline "~/Dropbox/cloudOrg/orgmode.org" "Habits")
               "* NEXT %?\nEntered on %U\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
              ;; org-chef
              ("C" "Cookbook" entry (file "~/Dropbox/cloudOrg/cookbook.org")
               "%(org-chef-get-recipe-from-url)"
               :empty-lines 1)
              ("M" "Manual Cookbook" entry (file "~/Dropbox/cloudOrg/cookbook.org")
               "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n"))))

;; Set which files must be visible on agenda
(setq org-agenda-files (list "~/Dropbox/cloudOrg/Work.org"
			     "~/Dropbox/cloudOrg/orgmode.org"
			     "~/Dropbox/cloudOrg/francis_gtd.org"))

;; template for code source blocks
;; type '<s' followed by TAB to insert the snippet and position cursor after #+NAME: 
(add-to-list 'org-structure-template-alist
             '("s" "#+NAME: ?\n#+BEGIN_SRC \n\n#+END_SRC"))

;; config necessary to org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; agenda week starts at present day
(setq org-agenda-start-on-weekday nil)

;; ido mode
(ido-mode)
(setq org-completion-use-ido t)

;; beancount
(require 'beancount)

;; gnupg
(require 'epa-file)
 '(epg-gpg-program "/usr/local/Cellar/gnupg/2.2.12/bin/gpg")
(epa-file-enable)

;; ledger
(autoload 'ledger-mode "ledger-mode" "A major mode for Ledger" t)
(add-to-list 'load-path
             (expand-file-name "/usr/local/share/emacs/site-lisp/ledger"))
(add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))

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
;;(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; theme
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

;; org-chef
(require 'org-chef)

;; from Aaron Bieber's config
(use-package helm
  :ensure t
  :diminish helm-mode
  :commands helm-mode
  :config
  (helm-mode 1)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-autoresize-mode t)
  (setq helm-buffer-max-length 40)
  (define-key helm-map (kbd "S-SPC") 'helm-toggle-visible-mark)
  (define-key helm-find-files-map (kbd "C-k") 'helm-find-files-up-one-level))

;; from Aaron Bieber's config
(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode)
  :config
  
  (defun org-keyword-backend (command &optional arg &rest ignored)
    "Company backend for org keywords.
COMMAND, ARG, IGNORED are the arguments required by the variable
`company-backends', which see."
    (interactive (list 'interactive))
    (cl-case command
      (interactive (company-begin-backend 'org-keyword-backend))
      (prefix (and (eq major-mode 'org-mode)
                   (let ((p (company-grab-line "^#\\+\\(\\w*\\)" 1)))
                     (if p (cons p t)))))
      (candidates (mapcar #'upcase
                          (cl-remove-if-not
                           (lambda (c) (string-prefix-p arg c))
                           (pcomplete-completions))))
      (ignore-case t)
      (duplicates t)))
  (add-to-list 'company-backends 'org-keyword-backend)

  (setq company-idle-delay 0.4)
  (setq company-selection-wrap-around t)
  (define-key company-active-map (kbd "ESC") 'company-abort)
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

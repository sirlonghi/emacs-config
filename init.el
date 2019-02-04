;; wrap line
(global-visual-line-mode t)

;; Mac keys (italian layout)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; group all backup files in one place
(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))

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
               "* NEXT %?\nEntered on %U\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

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
(custom-set-variables '(epg-gpg-program "/usr/local/Cellar/gnupg/2.2.9/bin/gpg"))
(epa-file-enable)

;; ledger
(autoload 'ledger-mode "ledger-mode" "A major mode for Ledger" t)
(add-to-list 'load-path
             (expand-file-name "/usr/local/share/emacs/site-lisp/ledger"))
(add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))

;; load selected packages in my-loadpackages.el
(load "~/.emacs.d/my-loadpackages.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil zenburn-theme yasnippet use-package org-edna magit ledger-mode helm company))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

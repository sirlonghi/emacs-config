
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; don't use this but use-package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

;; see use-package syntax below
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

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

;; Mac keys (italian layout)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

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

;; ido mode
(ido-mode)
(setq org-completion-use-ido t)

;; Set location for external custom packages.
(add-to-list 'load-path "~/.emacs.d/custom/")

;; Set which files must be visible on agenda
(setq org-agenda-files (list "~/Dropbox/cloudOrg/Work.org"
			     "~/Dropbox/cloudOrg/orgmode.org"
			     "~/Dropbox/cloudOrg/francis_gtd.org"))

;; config necessary to org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; agenda week starts at present day
(setq org-agenda-start-on-weekday nil)

;; if you want headlines indented
;;(setq org-startup-indented t)

;; for nice bullets - commented
;; (require 'org-bullets)
;; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; beancount
(require 'beancount)

;; ledger
(autoload 'ledger-mode "ledger-mode" "A major mode for Ledger" t)
(add-to-list 'load-path
             (expand-file-name "/usr/local/share/emacs/site-lisp/ledger"))
(add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))

;; gnupg
;; (require 'epa-file)
;; (setq epg-gpg-program "/usr/local/Cellar/gnupg@2.1")
;; (epa-file-enable)

;; evil-mode
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

;; ;; mu4e
(add-to-list 'load-path "/usr/local/Cellar/mu/1.0/share/emacs/site-lisp/mu/mu4e/")
(require 'mu4e)

(setq mu4e-mu-binary "/usr/local/bin/mu")
(setq mu4e-maildir "~/Mail")
(setq mu4e-drafts-folder "/Gmail/Drafts")
(setq mu4e-sent-folder   "/Gmail/Sent Mail")
;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)
;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; shortcuts
(setq mu4e-maildir-shortcuts
    '(("/Gmail/INBOX"       . ?i)
      ("/Gmail/Sent Mail"   . ?s)
      ("/libero/INBOX"      . ?l)))

;; something about ourselves
(setq
   user-mail-address "longhi.francesco@gmail.com"
   user-full-name  "Francesco Longhi"
   mu4e-compose-signature
    (concat
     "Francesco Longhi\n"
     "via Canturina 312\n"
     "22100 Como\n"))


;; show images
(setq mu4e-show-images t)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; convert html emails properly
;; Possible options:
;;   - html2text -utf8 -width 72
;;   - textutil -stdin -format html -convert txt -stdout
;;   - html2markdown | grep -v '&nbsp_place_holder;' (Requires html2text pypi)
;;   - w3m -dump -cols 80 -T text/html
;;   - view in browser (provided below)
(setq mu4e-html2text-command "textutil -stdin -format html -convert txt -stdout")

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed

(require 'smtpmail)

(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo.gpg")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)

;; spell check
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (set-fill-column 72)
           (flyspell-mode)))

;; add option to view html message in a browser
;; `aV` in view to activate
;; (add-to-list 'mu4e-view-actions
;;   '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; fetch mail every 10 mins
(setq mu4e-update-interval 600)

;; xelatex
(eval-after-load "tex"
    '(add-to-list 'TeX-command-list
                  '("xelatex" "xelatex -interaction=nonstopmode %s"
                    TeX-run-command t t :help "Run xelatex") t))

;; koma-letter
;; (add-to-list 'auto-mode-alist '("\\.lco" . tex-mode))
;; (eval-after-load 'ox '(require 'ox-koma-letter))

(eval-after-load 'ox-latex
  '(add-to-list 'org-latex-packages-alist '("AUTO" "babel" t) t))

  ;; babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (lisp . t)
     (python . t)
     (R . t)
<<<<<<< HEAD
     (sh . t)))
=======
     (shell . t)
     (ledger . t)))
>>>>>>> 046e8a4e84dd3f7326fd06b2300696594821a005

;; logging into drawers
(setq org-log-done (quote time))
(setq org-log-into-drawer t)
(setq org-log-redeadline (quote note));; record when the deadline date of a tasks is modified
(setq org-log-reschedule (quote time))

;; refile targets
(setq org-refile-targets (quote ((org-agenda-files :level . 1))))

;; Flyspell, aspell
;; you must enable with M-x flyspell-mode
;; change default dictionary (en) with "ispell-change-dictionary"
;; auto correct associated to C-M-i
(require 'flyspell)
(flyspell-mode +1)

(add-hook 'LaTeX-mode-hook 'flyspell-mode) ;start flyspell-mode
(setq ispell-dictionary "italian")    ;set the default dictionary
(add-hook 'LaTeX-mode-hook 'ispell)   ;start ispell

;; yasnippet
(add-to-list 'load-path
              "~/.emacs.d/elpa/yasnippet-0.13.0")
(require 'yasnippet)
(yas-global-mode 1)

;; org-edna
(add-to-list 'load-path "~/.emacs.d/custom/org-edna-1.0beta6")

(org-edna-load)

(setq make-backup-files nil) ; stop creating backup~ files

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; thanks to Rainer Konig
;; this snippet creates unique ID properties to the headlines of current file which do not have one
;; temporarly commented out
;; (defun francis-org-add-ids-to-headlines-in-file ()
;;   "Add ID properties to all headlines in the current file which
;; do not already have one."
;;   (interactive)
;;   (org-map-entries 'org-id-get-create))
 
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'francis-org-add-ids-to-headlines-in-file nil 'local)))

;; this snippet copies to clipboard the ID; if headline has no ID property, it creates one
(defun francis-copy-id-to-clipboard ()
"Copy to ID link with the headline to killring, if no ID is there then create
a new unique ID. This works only in org-mode or org-agenda buffers.
The purpose of this function is to construct easily: -links to 
org-mode items. If its assigned to a key it saves you marking the
text and copying to the killring."
       (interactive)
       (when (eq major-mode 'org-agenda-mode); switch to orgmode
	 (Org-agenda-show)
	 (Org-agenda-goto))       
       (when (eq major-mode 'org-mode); do this only in org-mode buffers
	 (setq mytmphead (nth 4 (org-heading-components)))
         (setq mytmpid (funcall 'org-id-get-create))
	 (setq mytmplink (format "[[id:% s] [% s]]" mytmpid mytmphead))
	 (kill-new mytmplink)
	 (message "Copied% s to killring (clipboard)" mytmplink)))

; (global-set-key (kbd ) 'francis-copy-id-to-clipboard)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; to jump back to previous position after following link
;; (add-hook 'org-load-hook
;;   (lambda ()
;;     (define-key org-mode-map "\C-b" 'org-mark-ring-goto)))
    
;; taskjuggler
(require 'ox-taskjuggler)

;; set property inheritance (which is not set by default)
(setq org-use-property-inheritance t)

;; ledger
(require 'ledger-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
<<<<<<< HEAD
    (auctex org-edna yasnippet zenburn-theme use-package helm company))))
=======
    (ledger-mode org-edna yasnippet zenburn-theme use-package helm company)))
 '(safe-local-variable-values (quote ((Tex-engine . xetex)))))
>>>>>>> 046e8a4e84dd3f7326fd06b2300696594821a005
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

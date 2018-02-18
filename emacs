;;;;;;;;;;;;;;;;;;;;;
;; global settings ;;
;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/lisp")

;; ace jump mode
(define-key global-map (kbd "C-c C-SPC" ) 'ace-jump-mode)

;;better frame navigation
(windmove-default-keybindings)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;code folding
(add-hook 'prog-mode-hook #'hs-minor-mode)

(global-set-key (kbd "M-=") 'hs-show-all)
(global-set-key (kbd "M--") 'hs-hide-all)
(global-set-key (kbd "C-=") 'hs-show-block)
(global-set-key (kbd "C--") 'hs-hide-block)

;;faster than scp
(setq tramp-default-method "ssh")

;; highlight long lines
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;;melpa packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(require 'req-package)

(custom-set-variables
 '(custom-safe-themes
   (quote
    ("ed317c0a3387be628a48c4bbdb316b4fa645a414838149069210b66dd521733f" "e9460a84d876da407d9e6accf9ceba453e2f86f8b86076f37c08ad155de8223c" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "0b6cb9b19138f9a859ad1b7f753958d8a36a464c6d10550119b2838cedf92171" "d6922c974e8a78378eacb01414183ce32bc8dbf2de78aabcc6ad8172547cb074" default)))
 '(inhibit-startup-screen t)
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . emacs)
     ("\\.pdf\\'" . emacs)))))
(custom-set-faces
 )

;; ispell autocomplete

;; Completion words longer than 4 characters
   (custom-set-variables
     '(ac-ispell-requires 4)
     '(ac-ispell-fuzzy-limit 4))

   (eval-after-load "auto-complete"
     '(progn
         (ac-ispell-setup)))

   (add-hook 'git-commit-mode-hook 'ac-ispell-ac-setup)
   (add-hook 'mail-mode-hook 'ac-ispell-ac-setup)
   (add-hook 'org-mode-hook 'ac-ispell-ac-setup)
   (setq ac-delay 0)
   
;;;;;;;;;;;;;;;;;;;;;;
;; major mode hooks ;;
;;;;;;;;;;;;;;;;;;;;;;

;; org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done 'note)
(setq org-agenda-files (list "~/org/thesis.org"
			     "~/org/machine_learning.org"
			     "~/org/personal.org"
			     "~/org/commands.org"))
(add-hook 'org-mode-hook 'auto-fill-mode)
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; syntax highlight code blocks
(setq org-src-fontify-natively t)
(setq org-html-postamble nil)

;; Some initial languages we want org-babel to support
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (gnuplot t)
   (ditaa . t)
   (C . t)
   ))

;; python configs
(elpy-enable)

;; use flycheck
(defvar myPackages
  '(better-defaults
    elpy
    flycheck ;; add the flycheck package
    material-theme))

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; auto pep8
 (defvar myPackages
   '(better-defaults
     elpy
     flycheck
     material-theme
     py-autopep8)) ;; add the autopep8 package

 (require 'py-autopep8)
 (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; ipython
(elpy-use-ipython)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")

(setq python-shell-native-complete nil)

;; c/c++

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)

(setq-default irony-cdb-compilation-databases '(irony-cdb-libclang
                                                irony-cdb-clang-complete))

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
  
(setq company-idle-delay 0)

;; Spaces not tabs 
(setq-default indent-tabs-mode nil)
(setq tab-width 8) ; or any other preferred value
;;(defvaralias 'c-basic-offset 'tab-width)

;; ;; gdb settings
;; (setq
;;  ;; use gdb-many-windows by default
;;  gdb-many-windows t

;;  ;; Non-nil means display source file containing the main routine at startup
;;  gdb-show-main t
;; )

;; fix the gdb dedicated windows non-sense
(defun set-window-undedicated-p (window flag)
 "Never set window dedicated."
 flag)

(advice-add 'set-window-dedicated-p :override #'set-window-undedicated-p)

;;;;;;;;;;;;;;;;
;; appearance ;;
;;;;;;;;;;;;;;;;

;;line numbers
;;(global-linum-mode 1)
;;(setq linum-format "%d ")

;; set font size
(set-face-attribute 'default nil :height 95)
(set-frame-font '-simp-Hack-bold-italic-normal-*-*-*-*-*-m-0-iso10646-1)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; disable useless menus
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; change the speedbar to be in a frame
(require 'sr-speedbar)

;; mode line
(display-time-mode 1)
(require 'smart-mode-line)
(setq sml/theme 'respectful)
(smart-mode-line-enable)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b"))

;;Load custom themes

;;(load-theme 'ample t t)
;;(load-theme 'ample-flat t t)
;;(load-theme 'ample-light t t)
;; choose one to enable
;;(enable-theme 'ample)
;; (enable-theme 'ample-flat)
;; (enable-theme 'ample-light)

(load-theme 'wombat)
(enable-theme 'wombat)

;;(load-theme 'grandshell)
;;(enable-theme 'grandshell)

;;(load-theme 'cyberpunk t t)
;;(enable-theme 'cyberpunk)

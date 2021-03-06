; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(add-to-list 'load-path "~/.emacs.d/")
(setq stack-trace-on-error t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq paredit-mode 0)
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(require 'xclip)
(require 'uniquify)
(require 'buff-menu+)
(require 'dired+-face-settings)
(require 'column-marker)
(require 'repository-root)
(require 'grep-o-matic)
;;(require 'fix-buffers-list)
;;(setq list-buffers-compact nil)
;;(setq list-buffers-modified-face 'bold)

(setq uniqueify-buffer-name-style 'reverse)
(autoload 'muttrc-mode "muttrc-mode.el"
  "Major mode to edit muttrc files" t)
(setq auto-mode-alist
      (append '(("muttrc\\'" . muttrc-mode))
              auto-mode-alist))

;; Evil =============================================================================
(require 'evil)
(require 'evil-search)
;;http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
(evil-mode 1)
(setq evil-default-state 'normal)
(setq evil-flash-delay 60)
(define-key global-map [f3] 'buffer-menu)
(define-key evil-insert-state-map (kbd "C-w") 'evil-window-map)
(define-key evil-insert-state-map (kbd "C-w <left>") 'evil-window-left)
(define-key evil-insert-state-map (kbd "C-w <right>") 'evil-window-right)
(define-key evil-insert-state-map (kbd "C-w <up>") 'evil-window-up)
(define-key evil-insert-state-map (kbd "C-w <down>") 'evil-window-down)
(define-key evil-normal-state-map (kbd "`") 'find-file)
;;(define-key global-map (kbd "`") 'find-file)
(evil-define-command "Ve" (function 
                            lambda() (split-window-horizontally)))
(defun vex ()
  (interactive)
  (split-window-horizontally))

(defun fileinfo ()
  (interactive)
  ;;(keyboard-quit)
  (message nil)
  (evil-show-file-info))

(global-set-key (kbd "C-g") 'fileinfo)
(global-set-key (kbd "C-c") 'quit)


;; Dired =============================================================================
(require 'dired+)
(defun start-dired ()
  (interactive)
  (dired "."))
(global-set-key [f4] 'start-dired)
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)
(define-key dired-mode-map [f3] 'buffer-menu)                              ;;
(define-key dired-mode-map (kbd "<ret>") 'diredp-find-file-reuse-dir-buffer)
(define-key dired-mode-map (kbd "-") 'dired-up-directory)
(toggle-diredp-find-file-reuse-dir 1)
(diredp-toggle-find-file-reuse-dir 1)

;;(add-hook 'dired-mode-hook
;;          '(lambda ()
;;            (print "dired-mode-hook Called !!")
;;            (toggle-diredp-find-file-reuse-dir 1)
;;            (diredp-toggle-find-file-reuse-dir 1)
;;            ;;(define-key evil-normal-state-map (kbd "-") 'dired-up-directory)
;;            ;;(evil-mode 0)
;;            ))
;;Recent Files===========================================================================
(require 'recentf)
(recentf-mode 1)
 (defun recentf-open-files-compl ()
      (interactive)
      (let* ((all-files recentf-list)
        (tocpl (mapcar (function 
           (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
        (prompt (append '("File name: ") tocpl))
        (fname (completing-read (car prompt) (cdr prompt) nil nil)))
        (find-file (cdr (assoc-ignore-representation fname tocpl))))) 
;;(global-set-key "\C-x\C-r" 'recentf-open-files-compl)
(global-set-key "\C-x\C-r" 'recentf-open-files)

;;Menu Bar ===========================================================================
(menu-bar-mode 0)
(setq mode-line-format
          (list
           ;; value of `mode-name'
           "%m: "
           ;; value of current buffer name
           "buffer %b, "
           ;; value of current line number
           "line %l "
           "-- user: "
           ;; value of user
           (getenv "USER")))

;:q; Color Themes ================================================================================ 
(load-file "~/.emacs.d/tango-2-steven-theme.el")
;(load-file "~/.emacs.d/color-theme-cool-dark.el")
;;(load-theme "tango-2-steven")

;; Python Mode ================================================================================ 
;;(autoload 'python-mode "python-mode.el" "Python mode." t)
;;(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))
;;;;http://emacs-fu.blogspot.com.au/2008/12/showing-and-hiding-blocks-of-code.html
(add-hook 'python-mode-hook
      #'(lambda ()
    (local-set-key (kbd "C-c <right>") 'hs-show-block)
    (local-set-key (kbd "C-c <left>")  'hs-hide-block)
    (local-set-key (kbd "C-c <up>")    'hs-hide-all)
    (local-set-key (kbd "C-c <down>")  'hs-show-all)
    ;;(local-set-key (kbd "C-]")  'cscope-find-symbol)
    ;;(hs-minor-mode t)
    ;;(hs-hide-all)
    ;;(setq autopair-handle-action-fns
      ;;(list #'autopair-default-handle-action
        ;;  #'autopair-python-triple-quote-action
    ))
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pycheckers"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
;;(global-set-key [f10] 'flymake-goto-prev-error)
;;(global-set-key [f11] 'flymake-goto-next-error)
;;======= Code folding =======
(defun jao-toggle-selective-display ()
  (interactive)
  (set-selective-display (if selective-display nil 1)))

;;(global-set-key [(f1)] 'jao-toggle-selective-display)
;;(define-key global-map (kbd "M-o p") 'jao-toggle-selective-display)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ack-and-a-half-prompt-for-directory t)
 '(compilation-disable-input t)
 '(custom-enabled-themes (quote (tango-2-steven)))
 '(custom-safe-themes (quote ("13b2915043d7e7627e1273d98eb95ebc5b3cc09ef4197afb2e1ede78fe6e0972" "1057947e1144d06a9fc8e97b6a72b72cf533a4cfe1247c4af047dc9221e9b102" "3800c684fc72cd982e3366a7c92bb4f3975afb9405371c7cfcbeb0bee45ddd18" "7c66e61cada84d119feb99a90d30da44fddc60f386fca041c01de74ebdd934c2" "f41ff26357e8ad4d740901057c0e2caa68b21ecfc639cbc865fdd8a1cb7563a9" "1797bbff3860a9eca27b92017b96a0df151ddf2eb5f73e22e37eb59f0892115e" "21d9280256d9d3cf79cbcf62c3e7f3f243209e6251b215aede5026e0c5ad853f" default)))
 '(display-buffer-reuse-frames t)
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ("/home/steven/iress/xplan/")))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(evil-search-module (quote evil-search))
 '(grep-command "ack --with-filename --nogroup --all")
 '(lazy-highlight-cleanup nil)
 '(lazy-highlight-initial-delay 0)
 '(lazy-highlight-max-at-a-time nil)
 '(paredit-mode nil t)
 '(recentf-mode t)
 '(repository-root-matchers (quote (repository-root-matcher/git repository-root-matcher/svn)))
 '(same-window-regexps (quote (".*Buffer Menu.*")))
 '(split-width-threshold 95)
 '(split-window-keep-point nil)
 '(window-min-width 90))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diredp-date-time ((((type tty)) :foreground "yellow") (t :foreground "goldenrod1")))
 '(diredp-dir-heading ((((type tty)) :background "yellow" :foreground "blue") (t :background "Pink" :foreground "DarkOrchid1")))
 '(diredp-display-msg ((((type tty)) :foreground "blue") (t :foreground "cornflower blue")))
 '(flymake-errline ((t (:background "color-53"))))
 '(flymake-warnline ((t (:background "color-58")))))
 

(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)
;;grep window
(defun my-grep ()
  "Run grep and resize the grep window"
  (interactive)
  (progn
    (call-interactively 'grep)
    (setq cur (selected-window))
    (setq w (get-buffer-window "*grep*"))
    (select-window w)
    (setq h (window-height w))
    (shrink-window (- h 15))
    (select-window cur)
    )
  )
(defun my-grep-hook () 
  "Make sure that the compile window is splitting vertically"
  (progn
    (if (not (get-buffer-window "*grep*"))
       (progn
      (split-window-vertically)))))
(add-hook 'grep-mode-hook 'my-grep-hook)
(global-set-key [f6] 'my-grep)

;; python ropemacs and pyemacs
;;https://github.com/mzc/ropemacs
(require 'pymacs)
;(pymacs-load "ropemacs" "rope-")
;; code to insert word under point into minibuffer
;;http://stackoverflow.com/questions/8257009/emacs-insert-word-at-point-into-replace-string-query
(defun my-minibuffer-insert-word-at-point ()
  "Get word at point in original buffer and insert it to minibuffer."
  (interactive)
  (let (word beg)
    (with-current-buffer (window-buffer (minibuffer-selected-window))
      (save-excursion
        (skip-syntax-backward "w_")
        (setq beg (point))
        (skip-syntax-forward "w_")
        (setq word (buffer-substring-no-properties beg (point)))))
    (when word
      (insert word))))

(defun my-minibuffer-setup-hook ()
  (local-set-key (kbd "C-w") 'my-minibuffer-insert-word-at-point))

;;(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

(defun reload-emacs-config ()
  "reload emacs config"
  (interactive)
  (load-file "~/.emacs"))

(defun edit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/emacs.el"))


;; ediff cleanup 
(defvar my-ediff-bwin-config nil "Window configuration before ediff.")
(defcustom my-ediff-bwin-reg ?b
  "*Register to be set up to hold `my-ediff-bwin-config'
    configuration.")

(defun my-ediff-bsh ()
  "Function to be called before any buffers or window setup for
    ediff."
  (remove-hook 'ediff-quit-hook 'ediff-cleanup-mess)
  (window-configuration-to-register my-ediff-bwin-reg))

(defun my-ediff-aswh ()
"setup hook used to remove the `ediff-cleanup-mess' function.  It causes errors."
  (remove-hook 'ediff-quit-hook 'ediff-cleanup-mess))

(defun my-ediff-qh ()
  "Function to be called when ediff quits."
  (remove-hook 'ediff-quit-hook 'ediff-cleanup-mess)
  (ediff-cleanup-mess)
  (jump-to-register my-ediff-bwin-reg))

(add-hook 'ediff-before-setup-hook 'my-ediff-bsh)
(add-hook 'ediff-after-setup-windows-hook 'my-ediff-aswh);
(add-hook 'ediff-quit-hook 'my-ediff-qh)
;; CScope =============================================================================
(require 'xcscope)
(setq cscope-do-not-update-database t)
(add-hook 'cscope-list-entry-hook 
      #'(lambda ()
            (setq w (get-buffer-window "*cscope*"))
            (select-window w)
            (setq h (window-height w))
            (shrink-window (- h 15))
            ;;(print "cscope-list-entry-hook")
            ))
(add-hook 'cscope-minor-mode-hooks
      #'(lambda ()
            (define-key evil-normal-state-map (kbd "C-]") 'cscope-find-global-definition-no-prompting)
            (evil-define-key 'normal evil-normal-state-map "C-c d" 'cscope-find-symbol)
            (define-key evil-normal-state-map (kbd "C-t") 'cscope-pop-mark)
            (evil-declare-key 'motion cscope-list-entry-keymap (kbd "<return>") 'cscope-select-entry-other-window)
            (evil-declare-key 'motion cscope-list-entry-keymap (kbd "RET") 'cscope-select-entry-other-window)
            ;;(print "cscope-minor-mode-hook Called !!")
            ))
(setq-default c-basic-offset 4)
(setq c-default-style "linux"
                c-basic-offset 4)
(setq x-select-enable-clipboard t)
;;
;; String methods
(defun string/ends-with (s ending)
      "return non-nil if string S ends with ENDING."
      (let ((elength (length ending)))
        (string= (substring s (- 0 elength)) ending)))
(defun string/starts-with (s arg)
      "returns non-nil if string S starts with ARG.  Else nil."
      (cond ((>= (length s) (length arg))
             (string-equal (substring s 0 (length arg)) arg))
            (t nil)))
;; Debug statements ==================================================================
(defun breakpoint-set nil
  (interactive)
  (save-excursion 
    (next-line)
    (beginning-of-line)
    ;;(open-line)
    (insert "sj_debug() ###############################################################\n")
    (previous-line)
    (python-indent-line)
    (goto-char (point-min))
    (flush-lines "^from.*sj_debug$")
    (insert "from debug import shell, debug as sj_debug\n"))
  )
(define-key global-map [f8] 'breakpoint-set)
(defun breakpoint-uset nil
  (interactive)
  (save-excursion 
    (goto-char (point-min))
    (flush-lines ".*sj_debug.*"))
  )
(define-key global-map [f7] 'breakpoint-uset)
;; kill all other buffers
(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))
;; PSVN ================================================================================
(require 'psvn)
(setq svn-status-hide-unknown t)
(setq svn-status-hide-unmodified t)
;;(add-hook 'svn-status-mode-hook 
;;          #'(lambda ()
;;              (evil-mode 0)
;;              )
;;          )
;; CTemplate  ==========================================================================
(require 'mustache-mode)
(require 'jinja)
;; SCSS =======================================================================
(setq scss-compile-at-save nil)
(setq exec-path (cons (expand-file-name "~/.gem/ruby/1.9/bin") exec-path))
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
;;(setq auto-mode-alist (cons '("\\.tpl$" . tpl-mode) auto-mode-alist))
;;   (autoload 'tpl-mode "tpl-mode" "Major mode for editing CTemplate
;;    files." t)
;;(add-hook 'tpl-mode-hook '(lambda () (font-lock-mode 1)))
;;(defvar svn-log-edit-mode-hook nil "Hook run when entering `svn-log-edit-mode'.")
;;(defvar svn-log-edit-done-hook nil "Hook run after commiting files via svn.")
;;            (define-key evil-normal-state-map (kbd "=") 'svn-status-show-svn-diff)
;;(defun do-svn-prep ()
;;  (cd '~/iress/xplan')
;;  (svn-status)
;;  )
;;(add-to-list 'default-frame-alist '(background-mode . dark))

(toggle-diredp-find-file-reuse-dir 1)

(defun diff-version (version)
  (interactive "nVersion: \n")
  ;;(print (format "%s%s" "xplan" (if (equal version 0) "" version))))
  (ediff buffer-file-name (replace-regexp-in-string "xplan[0-9]*" (format "%s%s" "xplan" (if (equal version 0) "" version)) buffer-file-name)))

(defun switch-version (version)
  (interactive "nVersion: \n")
  (goto-line  (line-number-at-pos) (find-file (replace-regexp-in-string "xplan[0-9]*" (format "%s%s" "xplan" (if (equal version 0) "" version)) buffer-file-name))))

(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

(global-auto-revert-mode t)
(add-to-list 'load-path "~/.emacs.d/jslint-v8")
(require 'flymake-jslint)
(add-hook 'javascript-mode-hook
                    (lambda () (flymake-mode t)))
(setq jslint-v8-shell "/usr/bin/d8")

(require 'project-buffer-mode)
(require 'fsproject)

;;http://stackoverflow.com/questions/8257009/emacs-insert-word-at-point-into-replace-string-query
(defun my-minibuffer-insert-word-at-point ()
  "Get word at point in original buffer and insert it to minibuffer."
  (interactive)
  (let (word beg)
    (with-current-buffer (window-buffer (minibuffer-selected-window))
      (save-excursion
        (skip-syntax-backward "w_")
        (setq beg (point))
        (skip-syntax-forward "w_")
        (setq word (buffer-substring-no-properties beg (point)))))
    (when word
      (insert word))))

(defun my-minibuffer-setup-hook ()
  (local-set-key (kbd "C-w") 'my-minibuffer-insert-word-at-point))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

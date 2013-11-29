;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; GNU Emacs Configuration by Eric James Michael Ritz
;;;;
;;;;     http://ericjmritz.name/
;;;;     https://github.com/ejmr/DotEmacs
;;;;
;;;; Conventions for key-bindings:
;;;;
;;;;     - C-c t:    Text commands.
;;;;     - C-c d:    Desktop commands.
;;;;     - C-c m:    Major modes.
;;;;     - C-c n:    Minor modes.
;;;;     - C-c x:    General commands.
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; First, setup my load path before anything else so that Emacs can
;;; find everything.

(add-to-list 'load-path "/home/eric/.emacs.d/")

;;; I often alias 'emacs' to 'emacsclient' in my shell, so the server
;;; needs to be running.

(server-start)

;;; Now comes a long section of general, global settings, minor modes,
;;; display configuration, and so on.

(setq inhibit-startup-message t
      make-backup-files nil
      auto-save-default t
      auto-save-interval 50
      auto-save-timeout 5
      delete-auto-save-files t
      case-fold-search t
      tooltip-delay 1
      major-mode 'text-mode
      imenu-sort-function 'imenu--sort-by-name
      kill-read-only-ok t
      show-trailing-whitespace t
      size-indication-mode t
      read-quoted-char-radix 16
      line-move-visual nil
      initial-scratch-message nil
      delete-by-moving-to-trash t
      visible-bell nil
      save-interprogram-paste-before-kill t
      history-length 250
      tab-always-indent 'complete
      save-abbrevs nil
      select-active-region t
      shift-select-mode nil
      x-select-enable-clipboard t
      auto-hscroll-mode t
      delete-active-region 'kill)

(setq scroll-preserve-screen-position 'always
      scroll-conservatively           most-positive-fixnum
      scroll-step                     0)

(setq-default truncate-lines t)
(setq-default abbrev-mode 1)
(setq-default indent-tabs-mode nil)

(transient-mark-mode t)
(delete-selection-mode t)
(column-number-mode t)
(show-paren-mode t)
(global-hi-lock-mode 1)
(which-function-mode t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-auto-revert-mode 1)
(blink-cursor-mode 0)
(tooltip-mode 1)
(electric-pair-mode 0)

(put 'narrow-to-page 'disabled nil)

(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-14"))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/usr/local/bin/conkeror")

(setq custom-file "/home/eric/.emacs.d/.emacs-custom.el")
(load custom-file 'noerror)

;;; Setup registers for files I commonly edit.

(set-register ?e '(file . "/home/eric/Projects/DotEmacs/.emacs"))
(set-register ?m '(file . "/home/eric/Temp/mail.md"))
(set-register ?n '(file . "/home/eric/.notes.org"))
(set-register ?t '(file . "/home/eric/.todo.org"))

;;; Load use-package and bind-key before anything else so that I can
;;; use those for loading all other packages.

(add-to-list 'load-path "/home/eric/.emacs.d/use-package/")
(require 'use-package)
(require 'bind-key)

;;; Setup my basic, global key-bindings.

(bind-key "<RET>" 'newline-and-indent)
(bind-key "<C-return>" 'newline)
(bind-key "<M-return>" 'indent-new-comment-line)
(bind-key "M-/" 'hippie-expand)

;;; These packages provide functions that others rely on so I want to
;;; load them early.

(use-package dash :load-path "dash.el/")
(use-package s)
(use-package f)
(use-package ido :config (ido-mode 1))

;;; Replace 'C-x C-b' with Ibuffer:

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :config (setq ibuffer-default-sorting-mode 'major-mode))

;;; These are some personal editing commands that I use everywhere.

(defun ejmr/move-line-up ()
  "Move the current line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun ejmr/move-line-down ()
  "Move the current line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(bind-key "<C-up>" 'ejmr/move-line-up)
(bind-key "<C-down>" 'ejmr/move-line-down)

(defun ejmr/top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))

(bind-key "C-^" 'ejmr/top-join-line)

;;; These are commands that I mostly use for text editing, or more
;;; specifically not for programming.  So they use the 'C-c t' prefix
;;; for 'text'.

(bind-key "C-c m t" 'text-mode)
(bind-key "C-c t a" 'align-regexp)
(bind-key "C-c t c" 'flyspell-auto-correct-word)
(bind-key "C-c t f" 'toggle-text-mode-auto-fill)
(bind-key "C-c t s" 'sort-lines)

;;; These keys are for desktop commands, hence 'C-c d'.

(bind-key "C-c d c" 'desktop-clear)
(bind-key "C-c d d" 'desktop-change-dir)
(bind-key "C-c d s" 'desktop-save)

;;; These keys are for commands I often use and use the 'C-c x' prefix
;;; as an association with 'M-x'.

(defun ejmr/open-project-log-file (project)
  "Opens a log file for a project."
  (interactive
   (list
    (completing-read "Project: " (directory-files "/home/eric/Documents/Logs/"))))
  (find-file (concat "/home/eric/Documents/Logs/" project)))

(bind-key "C-c x i" 'imenu)
(bind-key "C-c x l" 'ejmr/open-project-log-file)
(bind-key "C-c x v" 'visit-tags-table)
(bind-key "C-c x w" 'whitespace-cleanup)

;;; Configure the key chords I use globally.

(use-package key-chord
  :bind ("C-c n k" . key-chord-mode)
  :init (key-chord-mode 1)
  :config
  (progn
    (key-chord-define-global "##" 'server-edit)
    (key-chord-define-global "VV" 'other-window)
    (key-chord-define-global "KK" 'ido-kill-buffer)
    (key-chord-define-global "RR" 'toggle-read-only)))

;;; Easier navigation between windows.

(use-package winner-mode
  :config
  (progn
    (winner-mode 1)
    (windmove-default-keybindings)))

;;; I use these packages to navigate and edit text in semantic terms,
;;; with the Expand Region package being the foundation for the rest.

(use-package expand-region
  :load-path "expand-region.el/"
  :bind ("C-=" . er/expand-region)
  :config
  (progn
    (use-package change-inner
      :load-path "change-inner.el/"
      :bind (("M-i" . change-inner)
             ("M-o" . change-outer)))
    (use-package smart-forward
      :load-path "smart-forward.el/"
      :bind (("M-<up>" . smart-up)
             ("M-<down>" . smart-down)
             ("M-<left>" . smart-backward)
             ("M-<right>" . smart-forward)))))

;;; These packages also help navigate through text but are more
;;; focused on jumping to specific characters or fixed positions.

(use-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

;;; Load snippets that I use in a variety of major modes.

(use-package yasnippet
  :load-path "yasnippet/"
  :config
  (progn
    (yas-load-directory "/home/eric/.emacs.d/yasnippet/snippets/")
    (yas-global-mode)))

;;; These are packages I use for editing plain text in general.

(use-package artbollocks-mode
  :config (add-hook 'text-mode-hook 'artbollocks-mode))

(use-package anchored-transpose
  :bind ("C-c t t" . anchored-transpose))

(use-package unfill)

(use-package typopunct
  :bind ("C-c n t" . typopunct-mode)
  :config
  (progn
    (typopunct-change-language 'english t)
    (add-hook 'text-mode-hook 'typopunct-mode)))

(use-package flyspell
  :config (flyspell-mode 1))

(use-package writeroom-mode
  :load-path "writeroom-mode/"
  :bind ("C-c n w" . writeroom-mode))

;;; My Pomodoro timer of choice.

(use-package tomatinho
  :load-path "tomatinho/"
  :bind ("<f12>" . tomatinho))

;;; I use Flycheck in many programming modes by default.

(use-package flycheck
  :load-path "flycheck/"
  :bind ("C-c n f" . flycheck-mode)
  :config (add-hook 'after-init-hook #'global-flycheck-mode))

;;; Git:

(use-package conf-mode
  :mode (".gitignore" . conf-mode))

(use-package diff-mode
  :mode ("COMMIT_EDITMSG" . diff-mode))

;;; Tup:

(use-package tup-mode)

;;; Lua:

(use-package lua-mode
  :config
  (progn
    (setq lua-indent-level 4)
    (use-package lua-block
      :config (lua-block-mode t)))
  :mode (("\\.lua" . lua-mode)
         ("\\.rockspec" . lua-mode)
         ("\\.busted" . lua-mode)
         ("\\.spec.lua" . fundamental-mode)
         ("\\.slua" . lua-mode)))

;;; CC Mode:

(use-package cc-mode
  :init
  (progn
    (setq c-default-style
          '((csharp-mode . "linux")
            (java-mode . "java")
            (other . "linux")))))

;;; Rust:

(use-package rust-mode
  :mode ("\\.rs" . rust-mode))

;;; Emacs Lisp:

(defun ejmr/byte-compile-current-elisp-file ()
  (interactive)
  (byte-compile-file (buffer-file-name) t))

(bind-key "C-c l" 'ejmr/byte-compile-current-elisp-file emacs-lisp-mode-map)

;;; Perl:

(use-package perl-mode
  :init (defalias 'perl-mode 'cperl-mode)
  :config
  (progn
    (use-package perl-find-library)
    (setq cperl-invalid-face nil
          cperl-close-paren-offset -4
          cperl-continued-statement-offset 0
          cperl-indent-level 4
          cperl-indent-parens-as-block t)))

;;; JavaScript:

(use-package js3-mode
  :load-path "js3-mode/"
  :mode (("\\.json" . js3-mode)
         ("\\.js" . js3-mode))
  :init (defalias 'js-mode 'js3-mode))

;;; PHP:

(use-package php-mode
  :load-path "/home/eric/Projects/php-mode")

;;; These packages affect my modeline.

(use-package powerline
  :load-path "powerline/"
  :config (powerline-default-theme))

(use-package anzu
  :load-path "emacs-anzu/"
  :config (global-anzu-mode 1))

;;; Twitter:

(use-package twittering-mode
  :load-path "twittering-mode/"
  :bind ("C-c x t" . twit)
  :config
  (progn
    (setq twittering-use-master-password t)
    (setq twittering-number-of-tweets-on-retrieval 50)))

;;; BBCode:

(use-package bbcode-mode)

;;; Markdown:

(use-package markdown-mode
  :bind ("C-c m k" . markdown-mode)
  :mode (("\\.md" . markdown-mode)
         ("\\.markdown" . markdown-mode))
  :config
  (progn
    (defun ejmr/insert-mail-signature ()
      (interactive)
      (when (string= (buffer-file-name) "/home/eric/Temp/mail.md")
        (mail-signature)))

    (bind-key "C-c s" 'ejmr/insert-mail-signature markdown-mode-map)

    (defun ejmr/toggle-markdown-mode-wrapping ()
      (interactive)
      (let ((normal-settings (and auto-fill-function (not word-wrap))))
        (cond (normal-settings
               (auto-fill-mode -1)
               (visual-line-mode 1)
               (message "Using email settings"))
              (t
               (auto-fill-mode 1)
               (visual-line-mode -1)
               (message "Using normal settings")))))

    (bind-key "C-c w" 'ejmr/toggle-markdown-mode-wrapping markdown-mode-map)))

;;; Mail:

(use-package sendmail
  :bind ("C-c m a" . mail-mode))

;;; Org Mode:

(use-package org-install
  :load-path "org-mode/lisp/"
  :config
  (progn
    (setq org-todo-keywords '((sequence "TODO(t)"
                                        "REVIEW(r)"
                                        "TESTING(e)"
                                        "FEEDBACK(f)"
                                        "|"
                                        "DONE(d)"
                                        "ABORTED(a)"))
          org-drawers '("PROPERTIES" "CLOCK" "NOTES" "LOGBOOK")
          org-log-done 'time)))

;;; Load Projectile for project management, using the default 'C-c p'
;;; prefix for its commands.

(use-package projectile
  :load-path "projectile/"
  :init
  (progn
    (use-package recentf)
    (projectile-global-mode))
  :config
  (progn
    (setq projectile-enable-caching t)
    (setq projectile-switch-project-action 'projectile-dired)
    (setq projectile-completion-system 'ido)))

;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

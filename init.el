;; WARNING!
;;
;; This file is a result of `org-babel-tangle` execution on `.emacs.d/README.org`.
;; Don't change it manually.

(setq native-comp-async-report-warnings-errors nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; NO HELPERS YET

(straight-use-package 'org)
(require 'org)

(straight-use-package 'dash)
(require 'dash)

(straight-use-package 'f)
(require 'f)

(straight-use-package 's)
(require 's)

(straight-use-package 'gcmh)
(require 'gcmh)
(gcmh-mode 1)

(setq read-process-output-max (* 1024 1024))

(setq undo-limit (* 80 1000 1000)
      recentf-max-saved-items 1000)

;; when you visit a file, point goes to the last place where it was
;; when you previously visited the same file
(save-place-mode 1)

;; saves minibuffer history (use M-p/n in minibuffer)
(savehist-mode 1)

;; visualization of matching parens
(show-paren-mode 1)

;; typing an open parenthesis automatically inserts the corresponding
;; closing parenthesis
(electric-pair-mode 1)

;; allows to 'undo' window configuration changes
(winner-mode 1)

;; word-based commands stop inside symbols with mixed uppercase and
;; lowercase letters, e.g. "GtkWidget", "EmacsFrameClass",
;; "NSGraphicsContext".
(global-subword-mode 1)

;; keeping track of opened files
(require 'recentf)

(straight-use-package 'no-littering)
(require 'no-littering)

;; I'm ok with security risks here but before you do this, make sure
;; you understand the risks and read the documentation of
;; no-littering-theme-backups for details
(no-littering-theme-backups)

(setq custom-file (no-littering-expand-etc-file-name "custom.el"))

(setq create-lockfiles nil)

(add-to-list 'recentf-exclude no-littering-etc-directory)
(add-to-list 'recentf-exclude no-littering-var-directory)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)

;; disabling menu-bar-mode on MacOS leads to incorrect
;; window maximization behaviour
(unless (eq system-type 'darwin)
  (menu-bar-mode -1))

(let* ((family "Iosevka SS10")
       (size (if (eq system-type 'darwin)
                 18 ;; on MacOS HiDPI scaling works out of the box
               26)) ;; in Gnome HiDPI scaling doesn't work properly
       (spec (font-spec :family family :size size :weight 'semi-light)))
  (set-face-attribute 'default nil :font spec)
  ;; fixed-pitch was set to "Monospace" font by default
  (set-face-attribute 'fixed-pitch nil :family family)
  ;; variable-pitch was is set "non-monospace" font by default
  (set-face-attribute 'variable-pitch nil :family family))

(straight-use-package 'nord-theme)
(require 'nord-theme)
(load-theme 'nord t)

(let ((nord0 "#2E3440")
      (nord1 "#3B4252")
      (nord3 "#4C566A")
      (nord9 "#81A1C1")
      (nord10 "#5E81AC"))
  (custom-set-faces
   `(tab-bar ((t (:background ,nord1))))
   `(tab-bar-tab ((t (:background ,nord0
                                  :weight bold
                                  :box (:line-width -1 :style released-button)))))
   `(tab-bar-tab-inactive ((t (:foreground "gray39"
                                           :background ,nord1))))

   `(org-block ((t (:inherit org-block :background ,nord1))))
   `(org-headline-done ((t (:inherit org-headline-done :foreground ,nord10))))
   ))

(defun my-what-the-face ()
  "Show face under point in the minibuffer."
  (interactive)
  (let ((face (get-char-property (point) 'face)))
    (if face
        (message "Face: %s" face)
      (message "No face at point"))))

(defvar my-what-the-face-last-point nil
  "Last point where face was described.")

(defun my-what-the-face-adviced ()
  "Show face under point in the minibuffer. (Only once after point change)"
  (unless (equal my-what-the-face-last-point (point))
    (setq my-what-the-face-last-point (point))
    (my-what-the-face)))

(define-minor-mode my-what-the-face-mode
  "Minor mode to show face under point when cursor is moved."
  :global t
  :lighter " WTFace"
  (if my-what-the-face-mode
      (add-hook 'post-command-hook #'my-what-the-face-adviced 0 t)
        (remove-hook 'post-command-hook #'my-what-the-face-adviced t)))

(setq visible-bell nil)

(straight-use-package 'doom-modeline)
(setq doom-modeline-minor-modes t
      doom-modeline-buffer-encoding nil
      doom-modeline-project-detection 'project
      doom-modeline-modal-icon nil
      doom-modeline-workspace-name nil)
(require 'doom-modeline)

(doom-modeline-mode 1)

(column-number-mode 1)

(doom-modeline-def-modeline 'very-minimal
  '(bar buffer-info-simple)
  '(major-mode))

(defun my-set-inactive-buffer-modeline ()
  (doom-modeline-set-modeline 'very-minimal))

(defun my-set-active-buffer-modeline ()
  (unless (doom-modeline-auto-set-modeline)
    (doom-modeline-set-main-modeline)))

(defun my-set-modeline-hook ()
  (dolist (buf (buffer-list))
          (with-current-buffer buf
            (if (eq (current-buffer) (window-buffer (selected-window)))
                (my-set-active-buffer-modeline)
              (my-set-inactive-buffer-modeline)))))

(let ((nord9 "#81A1C1"))
  (custom-set-faces
   `(mode-line-inactive ((t (:inherit mode-line-inactive
                                      :foreground ,nord9))))
   `(doom-modeline-buffer-minor-mode ((t (:foreground ,nord9)))))) 

(add-hook 'buffer-list-update-hook #'my-set-modeline-hook)

(straight-use-package 'undo-tree)
(require 'undo-tree)

(global-undo-tree-mode)

(straight-use-package 'goto-chg)
(require 'goto-chg)

(defun my-undo-tree-save-history (undo-tree-save-history &rest args)
  (let ((message-log-max nil)
        (inhibit-message t))
    (apply undo-tree-save-history args)))

(advice-add 'undo-tree-save-history :around 'my-undo-tree-save-history)

;; it's required by evil-collection
(setq evil-want-keybinding nil)

(straight-use-package 'evil)

;; smaller undo steps
(setq evil-want-fine-undo t)

(setq evil-undo-system 'undo-tree)

(require 'evil)
(evil-mode 1)

(straight-use-package 'evil-collection)
(require 'evil-collection)

(evil-collection-image-setup)
(evil-collection-xref-setup)
(evil-collection-bookmark-setup)
(evil-collection-compile-setup)

(setq which-key-idle-delay 0.4
      which-key-max-description-length 120)

(straight-use-package 'which-key)
(require 'which-key)

(which-key-mode)

(straight-use-package 'general)
(require 'general)

(general-create-definer my-leader-def :states
  '(normal insert emacs)
  :prefix "SPC" :non-normal-prefix "C-s-SPC")

(when (eq system-type 'darwin)
  (setq locate-command "mdfind")
  (setq mac-command-modifier 'super
        mac-option-modifier 'meta)

  (general-define-key
   "s-c" 'kill-ring-save
   "s-v" 'yank
   "s-x" 'kill-region

   "s-s" 'save-buffer
   "s-o" 'find-file

   "s-a" 'mark-whole-buffer
   "s-z" 'undo
   "s-f" 'consult-line

   "s-<left>" 'beginning-of-line
   "s-<right>" 'end-of-line
   "s-<up>" 'beginning-of-buffer
   "s-<down>" 'end-of-buffer
   "M-<up>" 'backward-paragraph
   "M-<down>" 'forward-paragraph

   "s-/" 'comment-line
   ))

(straight-use-package 'keyfreq)
(setq keyfreq-excluded-commands
      '(mac-mwheel-scroll ;; mouse movement
        evil-forward-char ;; basic VIM movement
        evil-backward-char
        evil-forward-word-end
        evil-backward-word-begin
        evil-next-line
        evil-previous-line))
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

(setq save-interprogram-paste-before-kill t)

(straight-use-package 'exec-path-from-shell)
(require 'exec-path-from-shell)

(add-to-list 'exec-path-from-shell-variables "LANG")
(add-to-list 'exec-path-from-shell-variables "LC_ALL")
(add-to-list 'exec-path-from-shell-variables "LC_CTYPE")

(exec-path-from-shell-initialize)

(straight-use-package 'vertico)
(setq vertico-cycle t)
(vertico-mode)

(defun my-vertico-replace-with-common-prefix ()
  "Replaces current vertico input with common prefix query.

Replaces vertico input with '^str' where str is the common prefix
for candidates that starts with the first component of current
vertico input."
  (interactive)
  (when-let* ((current-input (or (car vertico--input) (minibuffer-contents-no-properties)))
              (prefix-from-input (->> current-input
                                      (s-split " ")
                                      (-first-item)
                                      (s-replace "^" "")))
              (common-prefix (-some->> vertico--candidates
                               (--select (s-prefix? prefix-from-input it))
                               (--reduce (fill-common-string-prefix it acc))))
              (next-search-query (s-concat "^" common-prefix)))
    (delete-minibuffer-contents)
    (insert next-search-query)))

(general-def :keymaps 'vertico-map
  (kbd "C-<tab>") #'my-vertico-replace-with-common-prefix)

(straight-use-package 'orderless)
(require 'orderless)

(setq completion-styles '(orderless basic))
(setq completion-category-defaults nil)
(setq completion-category-overrides '((file (styles basic partial-completion))))

(straight-use-package 'consult)
(require 'consult)

(advice-add #'multi-occur :override #'consult-multi-occur)

(defun consult-preview-p ()
  "Return true when minibuffer in a 'consult preview' state'"
  (when-let
      (win (active-minibuffer-window))
    (not (eq nil (buffer-local-value 'consult--preview-function (window-buffer win))))))

(defun my-inhibit-if-consult-preview (oldfun &rest args)
  "An around advice to disable some functions in the case of consult preview"
  (unless (consult-preview-p)
    (apply oldfun args)))

(straight-use-package 'marginalia)
(require 'marginalia)
(marginalia-mode)

(setq
 ;; no extra frames!
 ediff-window-setup-function 'ediff-setup-windows-plain 
 ;; horizontal split instead of vertical
 ediff-split-window-function 'split-window-horizontally)

(require 'ediff)

(setq insert-directory-program (if (eq system-type 'darwin) "gls" "ls"))

(setq dired-listing-switches "-lah -v --group-directories-first")

(defun my-remote-dired-hook ()
  "Adjusts Dired behaviour in the case of remote dirs"
  (when (file-remote-p default-directory)
    (setq-local dired-actual-switches "-lah")
    (setq-local insert-directory-program "ls")))

(add-hook 'dired-mode-hook #'my-remote-dired-hook)
(add-hook 'dired-mode-hook #'diff-hl-dired-mode)

(evil-collection-dired-setup)

;; fix of evil-collection
(general-unbind
  :states '(normal visual)
  :keymaps 'dired-mode-map
  "SPC")

(straight-use-package 'all-the-icons-dired)
(setq all-the-icons-dired-monochrome nil)
(require 'all-the-icons-dired)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(evil-collection-ibuffer-setup)

(straight-use-package 'all-the-icons-ibuffer)
(require 'all-the-icons-ibuffer)
(add-hook 'ibuffer-mode-hook #'all-the-icons-ibuffer-mode)

(straight-use-package 'helpful)
(require 'helpful)

(evil-collection-helpful-setup)

(general-def
  "C-h f" #'helpful-callable
  "C-h v" #'helpful-variable
  "C-h k" #'helpful-key
  "C-h x" #'helpful-command
  "C-h F" #'helpful-function)

;; evil uses `K` for `evil-lookup` so I need to unbind it first
(general-unbind evil-motion-state-map "K")

(general-def
  :states '(normal visual)
  :keymaps 'emacs-lisp-mode-map
  "K" #'helpful-at-point)

(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(require 'uniquify)

(defun my-kill-this-buffer ()
  "Kill current buffer if it isn't used in other windows or tabs. Otherwise switch to previous buffer, with a message."
  (interactive)
  (let ((buffer (current-buffer)))
    (if (or
         (delq (selected-window) (get-buffer-window-list buffer nil t))
         (tab-bar-get-buffer-tab (current-buffer) nil t))
        (progn
          (switch-to-prev-buffer)
          (message "Buffer is used in other window or tab. Switched to previous buffer."))
      (kill-buffer buffer))))

(defun my-force-kill-this-buffer ()
  "Kill current buffer unconditionally."
  (interactive)
  (kill-buffer (current-buffer)))

(defun my-kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(straight-use-package 'avy)
(require 'avy)

(general-def "C-;" #'avy-goto-char)

(defvar my-split-window-aspect-ratio-threshold 2.0
  "If window aspect ratio lower than this
`my-split-window' will split verically.

Ratio calculated as width divided by height.")

(defun my-split-window (&optional window)
  "Alternative to `split-window-sensibly' that
relies on current window aspect ratio.

See `my-split-window-aspect-ratio-threshold'."
  (let* ((window (or window (selected-window)))
         (width (float (window-width window)))
         (height (float (window-height window)))
         (ratio (/ width height)))
    (with-selected-window window
      (if (< ratio my-split-window-aspect-ratio-threshold)
          (split-window-below)
        (split-window-right)))))

(setq split-window-preferred-function 'my-split-window)

(straight-use-package 'ace-window)
(require 'ace-window)

(general-def :states '(normal visual)
  "C-w C-w" #'ace-window)

;; better visual appearance
(setq tab-bar-show 1)
(setq tab-bar-close-button-show nil)
(setq tab-bar-new-button-show nil)

;; MacOS-style keybindings
(general-def
  "s-{" #'tab-bar-switch-to-prev-tab
  "s-}" #'tab-bar-switch-to-next-tab
  "s-n" #'tab-bar-duplicate-tab
  "s-t" #'tab-bar-duplicate-tab
  "s-w" #'tab-bar-close-tab
  "s-r" #'tab-bar-rename-tab)

(defun my-text-scale-0 ()
  "Text scale reset"
  (interactive)
  (text-scale-set 0))

(defun my-text-scale-big ()
  "Toggles big text scale"
  (interactive)
  (if (= text-scale-mode-amount 0)
      (text-scale-set 2)
    (my-text-scale-0)))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(defun my-switch-line-numbers-mode ()
  "Changes line numbers mode between relative and absolute"
  (interactive)
  (if (eq display-line-numbers-type 'relative)
      (setq display-line-numbers-type t)
    (setq display-line-numbers-type 'relative))
  (display-line-numbers-mode t))

(straight-use-package 'diminish)
(require 'diminish)

(defun diminish-minor-modes ()
  "Diminishes non-informative modeline minore-modes' entries."
  (diminish 'which-key-mode)
  (diminish 'undo-tree-mode)
  (diminish 'gcmh-mode)
  (diminish 'subword-mode)
  (with-eval-after-load 'org-indent
    (diminish 'org-indent-mode))
  (diminish 'auto-revert-mode)
  (diminish 'org-auto-tangle-mode))

(add-hook 'emacs-startup-hook #'diminish-minor-modes)

(setq-default indent-tabs-mode nil)

(setq require-final-newline t)

(defun my-rm-all-watches ()
  "Remove all existing file notification watches from EMACS."
  (interactive)
  (maphash
   (lambda (key _value)
     (file-notify-rm-watch key))
   file-notify-descriptors))

(straight-use-package 'rainbow-delimiters)
(require 'rainbow-delimiters)

(straight-use-package 'smartparens)
(require 'smartparens-config)

(straight-use-package 'xr)
(require 'xr)

(server-start)

(my-leader-def
  "a" '(:ignore t :which-key "app")
  "a u" #'undo-tree-visualize

  "b" '(:ignore t :which-key "buffer")
  "b b" #'consult-buffer
  "b k" #'my-kill-this-buffer
  "b K" #'my-force-kill-this-buffer
  "b C-k" #'my-kill-other-buffers
  "b n" #'next-buffer
  "b p" #'previous-buffer
  "b i" #'ibuffer

  "B" '(:ignore t :which-key "bookmark")
  "B m" #'bookmark-set
  "B B" #'consult-bookmark
  "b x" #'bookmark-delete
  "B C-x" #'bookmark-delete-all

  "b d" #'dired-jump

  "c" '(:ignore t :which-key "code")

  "e" '(:ignore t :which-key "edit")
  "e s" #'smartparens-mode
  "e [" #'show-smartparens-mode
  "e p" #'consult-yank-from-kill-ring

  "f" '(:ignore t :which-key "file")
  "f f" #'find-file
  "f r" #'consult-recent-file

  "j" '(:ignore t :which-key "jump")
  "j j" #'consult-imenu

  "m" '(:ignore t :which-key "mode")

  "p" '(:ignore t :which-key "project")

  "s" '(:ignore t :which-key "search")

  "t" '(:ignore t :which-key "toggles")
  "t +" #'text-scale-increase
  "t -" #'text-scale-decrease
  "t =" #'my-text-scale-0
  "t b" #'my-text-scale-big

  "t l" #'toggle-truncate-lines
  "t w" #'toggle-word-wrap

  "t n" #'my-switch-line-numbers-mode


  "u" '(:ignore t :which-key "utils")
  "u f" #'my-what-the-face-mode
  "u k" #'keyfreq-show
  "u C-k" #'keyfreq-reset
  )

(my-leader-def
  "SPC" #'project-find-file
  
  "p p" #'project-switch-project
  "p b" #'consult-project-buffer
  "p k" #'project-kill-buffers)

(defun my-copy-file-path-relative-to-project-root ()
  "Copy the current buffer's file path and line number relative to the project root into the kill ring."
  (interactive)
  (if-let ((file-path (buffer-file-name))
           (project-root (when (project-current) (expand-file-name (project-root (project-current)))))
           (line-number (line-number-at-pos))
           (relative-path (format "%s:%d" (file-relative-name file-path project-root) line-number)))
      (progn
        (kill-new relative-path)
        (message "Copied: %s" relative-path))
    (message "No file associated with buffer or not in a project.")))

(my-leader-def
  "p y" #'my-copy-file-path-relative-to-project-root)

(straight-use-package 'rg)
(require 'rg)

(rg-enable-default-bindings)
(evil-collection-rg-setup)
(evil-collection-wgrep-setup)

(my-leader-def
  "p s" #'consult-ripgrep
  "p S" #'rg-menu)

(defvar my-bookmarks-directory
  (expand-file-name "bookmarks" no-littering-var-directory)
  "Directory where bookmark lists are stored.")

(unless (file-directory-p my-bookmarks-directory)
  (make-directory my-bookmarks-directory))

(defun my-bookmark-list--files ()
  "Return a list of bookmark files in `my-bookmarks-directory`."
  (directory-files my-bookmarks-directory t ".*\\.el"))

(defun my-bookmark-list-save ()
  "Prompt for a bookmark file and save bookmarks to it."
  (interactive)
  (let* ((selected-file (consult--read
                         (my-bookmark-list--files)
                         :prompt "Save bookmarks to file: "
                         :require-match nil
                         :category 'file))
         (selected-file-with-ext (if (string-suffix-p ".el" selected-file t)
                                     selected-file
                                   (concat selected-file ".el")))
         (file (expand-file-name selected-file-with-ext my-bookmarks-directory)))
    (bookmark-write-file file)))

(defun my-bookmark-list-load ()
  "Prompt for a bookmark file and load bookmarks from it."
  (interactive)
  (let* ((selected-file (consult--read
                         (my-bookmark-list--files)
                         :prompt "Load bookmarks from file: "
                         :require-match t
                         :category 'file))
         (file (expand-file-name selected-file my-bookmarks-directory)))
    (bookmark-load file)))
         
(defun my-bookmark-list-delete ()
  "Prompt for a bookmark file and delete it."
  (interactive)
  (let* ((selected-file (consult--read
                         (my-bookmark-list--files)
                         :prompt "Delete bookmark file: "
                         :require-match t
                         :category 'file))
         (file (expand-file-name selected-file my-bookmarks-directory)))
    (delete-file file)
    (message "Deleted: %s" file)))

(my-leader-def
  "B s" #'my-bookmark-list-save
  "B l" #'my-bookmark-list-load
  "B D" #'my-bookmark-list-delete)

(defvar my-favourite-files
  '("~/.emacs.d/README.org"
    "~/Work/ongoing.org"
    "~/Desktop/TODO.org"
    "~/Desktop/highlights.org")
  "Important files list")

(defun my-open-favourite-file ()
  "Select and open an important file from my-important-files"
  (interactive)
  (find-file (consult--read
              my-favourite-files
              :prompt "Favourite files: "
              :category 'file
              :sort nil)))

(my-leader-def
  "f F" #'my-open-favourite-file)

(straight-use-package 'magit)
(require 'magit)

;; word-granularity diff highlighting
(setq magit-diff-refine-hunk t)

(evil-collection-magit-setup)

(my-leader-def
  "g" '(:ignore t :which-key "git")
  "g SPC" #'magit-dispatch
  "g g" #'magit-status
  "g b" #'magit-blame)

(straight-use-package 'magit-delta)
(require 'magit-delta)

(setq magit-delta-default-dark-theme "Nord")

(add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1)))

(straight-use-package 'diff-hl)
(setq diff-hl-show-staged-changes nil)
(require 'diff-hl)

(global-diff-hl-mode)

(straight-use-package 'git-modes)
(require 'git-modes)

(evil-collection-vc-git-setup)

(straight-use-package 'vterm)
(require 'vterm)

(evil-collection-vterm-setup)

(my-leader-def
  "a t" #'vterm)

(straight-use-package 'corfu)
(setq corfu-auto t
      corfu-preview-current nil
      corfu-auto-delay 1.0)
(require 'corfu)

(global-corfu-mode)
(evil-collection-corfu-setup)

;; while in autocompletion press <tab> to mimic orderless behaviour
;; (orderless search by multiple regexps in any order)
(general-def :keymaps 'corfu-map
  (kbd "<tab>") #'corfu-insert-separator)

(require 'corfu-popupinfo)
(setq corfu-popupinfo-delay (cons 0.5 0.1))
(corfu-popupinfo-mode)

(my-leader-def
  "t p" #'corfu-popupinfo-mode)

(straight-use-package 'kind-icon)
(require 'kind-icon)

(add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)

(straight-use-package 'cape)
(require 'cape)

(add-to-list 'completion-at-point-functions #'cape-dabbrev)
(add-to-list 'completion-at-point-functions #'cape-file)

(general-def :keymaps 'evil-insert-state-map
  "C-<tab> C-<tab>" #'completion-at-point
  "C-<tab> f" #'cape-file
  "C-<tab> d" #'cape-dabbrev
  "C-<tab> w" #'cape-dict
  "C-<tab> l" #'cape-line)

(straight-use-package 'tempel)
(setq tempel-path '("~/.emacs.d/templates.eld" "~/.emacs.d/templates_private.eld"))
(require 'tempel)

(defun my-tempel-setup-capf ()
  "Add the Tempel Capf to the beginning of `completion-at-point-functions'."
  (setq-local completion-at-point-functions
              (cons #'tempel-complete
                    (remove 'tempel-complete completion-at-point-functions))))

(add-hook 'conf-mode-hook 'my-tempel-setup-capf)
(add-hook 'prog-mode-hook 'my-tempel-setup-capf)
(add-hook 'text-mode-hook 'my-tempel-setup-capf)
(add-hook 'eglot-managed-mode-hook 'my-tempel-setup-capf)

(my-leader-def
  "e s" #'tempel-insert)

(straight-use-package 'eglot)
(setq jsonrpc-default-request-timeout 20) ;; for heavy projects
(require 'eglot)

(straight-use-package 'consult-eglot)
(require 'consult-eglot)

(my-leader-def
  "j SPC" #'consult-eglot-symbols)

(defun my-xref-find-references-with-new-buffer (orig-fun &rest args)
  "An around advice to create a new xref buffer for each `xref-find-references' command."
  (let ((xref-buffer-name (format "%s %s" xref-buffer-name (symbol-at-point))))
    (apply orig-fun args)))

(advice-add 'xref-find-references :around #'my-xref-find-references-with-new-buffer)

(defun my-get-pass (name)
  "Retrieve secret under NAME from Pass."
  (let ((pass-command (concat "pass " name)))
    (string-trim (shell-command-to-string pass-command))))

(straight-use-package '(copilot :host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; copilot.el requires nodejs to be installed, but I don't want to
;; install it globally so I'm using Nix to link non-globally installed
;; nodejs binaries to ~/.emacs.d/nodejs-bin
(setq exec-path (append exec-path
                        (list (s-concat (getenv "HOME") "/.emacs.d/nodejs-bin"))))
(setq copilot-indent-offset-warning-disable t)
(require 'copilot)

(defun toggle-copilot ()
  "Toggles between Copilot and Corfu completion engines."
  (interactive)
  (if corfu-mode
      (progn
        ;; close auto-completion popup if enabled
        (corfu-quit)
        (corfu-mode -1)
        (copilot-mode 1)
        (message "Copilot enabled"))
    (progn
      (copilot-mode -1)
      (corfu-mode 1)
      (message "Copilot disabled"))))

(my-leader-def
  "t c" #'toggle-copilot)

(general-def
  "s-j" #'toggle-copilot)

(general-def
  :states '(insert)
  :keymaps 'copilot-mode-map
  "s-<return>" #'copilot-accept-completion
  "C-s-<return>" #'copilot-accept-completion-by-word
  "C-s-j" #'copilot-next-completion
  "C-s-k" #'copilot-previous-completion)

(straight-use-package 'gptel)
(setq-default gptel-model "gpt-4o")
(setq gptel-api-key (my-get-pass "openai/api_key"))

(with-eval-after-load 'markdown-mode
  (require 'gptel)

  (add-hook 'gptel-mode-hook #'toggle-word-wrap))

(my-leader-def
  "a g" #'gptel)

(straight-use-package 'restclient)
(require 'restclient)

(add-to-list 'auto-mode-alist
             `(,(rx ".restclient" eos) . restclient-mode))

(straight-use-package 'envrc)
(require 'envrc)

(add-hook 'after-init-hook #'envrc-global-mode)

;; install optional requirements
(straight-use-package 'page-break-lines)
(require 'page-break-lines)

(straight-use-package 'all-the-icons)
(require 'all-the-icons)

(straight-use-package 'dashboard)
(setq dashboard-startup-banner "~/.emacs.d/logo.png")
(require 'dashboard)

(dashboard-setup-startup-hook)

(straight-use-package 'nix-ts-mode)
(require 'nix-ts-mode)

(add-to-list 'auto-mode-alist
             `(,(rx ".nix" eos) . nix-ts-mode))

(add-to-list 'eglot-server-programs
             '(nix-ts-mode . ("nixd")))
(add-hook 'nix-ts-mode-hook #'eglot-ensure)

(straight-use-package 'heex-ts-mode)
(require 'heex-ts-mode)

(straight-use-package 'elixir-ts-mode)
(require 'elixir-ts-mode)

(add-to-list 'eglot-server-programs
             '(elixir-ts-mode . ("lexical")))
(add-hook 'elixir-ts-mode-hook
          #'eglot-ensure)

(straight-use-package 'exunit)
(require 'exunit)

(add-hook 'elixir-ts-mode-hook #'exunit-mode)

(my-leader-def
  :keymaps 'elixir-ts-mode-map
  :major-modes t
  "m" '(:ignore t :which-key "elixir")
  "m t" #'exunit-transient)

(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

(require 'ruby-mode)
(add-hook 'ruby-mode-hook #'eglot-ensure)

(straight-use-package 'rspec-mode)
(require 'rspec-mode)

(straight-use-package 'minitest)
(require 'minitest)

(my-leader-def
  :keymaps 'ruby-mode-map
  :major-modes t
  "m" '(:ignore t :which-key "ruby")
  "m t" #'rspec-mode-keymap
  "m m" '(:ignore t :which-key "minitest")
  "m m v" #'minitest-verify
  "m m s" #'minitest-verify-single
  "m m t" #'minitest-toggle-test-and-target
  "m m r" #'minitest-rerun
  "m m a" #'minitest-verify-all)

(add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))

(add-to-list 'auto-mode-alist `(,(rx ".ya" (? "m") "l" eos) . yaml-ts-mode))

(setq org-startup-indented t
      org-src-preserve-indentation t
      org-html-head-include-scripts nil
      org-pretty-entities t)

(evil-collection-org-setup)

(add-hook 'org-src-mode-hook #'evil-insert-state)
(add-hook 'org-mode-hook #'toggle-word-wrap)
(add-hook 'org-mode-hook #'toggle-truncate-lines)

(straight-use-package 'org-auto-tangle)
(require 'org-auto-tangle)

(add-hook 'org-mode-hook #'org-auto-tangle-mode)

(straight-use-package 'htmlize)
(require 'htmlize)

(straight-use-package 'edit-indirect)
(require 'edit-indirect)

(straight-use-package 'markdown-mode)
(setq markdown-fontify-code-blocks-natively t)
(require 'markdown-mode)

(add-to-list 'auto-mode-alist
             `(,(rx "README.md" eos) . gfm-mode))

(straight-use-package 'markdown-toc)
(setq markdown-toc-indentation-space 2)
(require 'markdown-toc)

(my-leader-def
  :keymaps 'markdown-mode-map
  :major-modes t
  "m" '(:ignore t :which-key "markdown")
  "m t" '(:ignore t :which-key "toggle")
  "m t t" #'markdown-toggle-markup-hiding
  "m t s" #'markdown-toggle-fontify-code-blocks-natively
  "m t i" #'markdown-toggle-inline-images
  "m t m" #'markdown-toggle-math
  "m t u" #'markdown-toggle-url-hiding
  "m t w" #'markdown-toggle-wiki-links
  "m T" #'markdown-toc-generate-or-refresh-toc
  "m P" #'plantuml-preview-current-block)

(add-to-list 'auto-mode-alist
             (cons (rx (any "/\\")
                       (or "Containerfile" "Dockerfile")
                       (opt "."
                            (zero-or-more
                             (not (any "/\\"))))
                       eos)
                   'dockerfile-ts-mode))

(add-to-list 'auto-mode-alist `(,(rx ".dockerfile" eos) . dockerfile-ts-mode))

(add-hook 'dockerfile-ts-mode-hook #'eglot-ensure)

(straight-use-package 'docker)
(require 'docker)

(evil-collection-docker-setup)

(my-leader-def
  "a d" #'docker)

(straight-use-package 'earthfile-mode)
(require 'earthfile-mode)

(straight-use-package 'terraform-mode)
(require 'terraform-mode)

(add-to-list 'eglot-server-programs
             '(terraform-mode . ("terraform-ls" "serve")))

(add-hook 'terraform-mode-hook #'eglot-ensure)

(add-to-list 'auto-mode-alist
             `(,(rx ".go" eos) . go-ts-mode))
(add-to-list 'auto-mode-alist
             `(,(rx (any "/\\") "go.mod" eos) . go-mod-ts-mode))

(add-hook 'go-ts-mode-hook #'eglot-ensure)

(straight-use-package 'gotest)
(require 'gotest)

(my-leader-def
  :keymaps 'go-ts-mode-map
  :major-modes t
  "m" '(:ignore t :which-key "go")
  "m t" '(:ignore t :which-key "gotest")
  "m t v" #'go-test-current-file
  "m t s" #'go-test-current-test
  "m t a" #'go-test-current-project)

(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

(add-hook 'python-ts-mode-hook #'eglot-ensure)

(straight-use-package 'mastodon)
(setq mastodon-instance-url "https://genserver.social"
      mastodon-active-user "ffloyd")
(require 'mastodon)

(straight-use-package '(mastodon-alt :type git :host github :repo "rougier/mastodon-alt"))
(require 'mastodon-alt)

(mastodon-alt-tl-activate)

(add-to-list 'auto-mode-alist `(,(rx ".js" (? "x") eos) . js-ts-mode))
(add-hook 'js-ts-mode-hook #'eglot-ensure)

(add-to-list 'auto-mode-alist `(,(rx ".ts" eos) . typescript-ts-mode))
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)

(add-to-list 'auto-mode-alist `(,(rx ".tsx" eos) . tsx-ts-mode))
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)

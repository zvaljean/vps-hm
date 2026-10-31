(require 'package)
  ;;      (setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/") 
  ;;                                 ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/") 
  ;;                                 ("nongnu" . "http://mirrors.ustc.edu.cn/elpa/nongnu/")))

;; https://stable.melpa.org/#/getting-started
      (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

       (package-initialize)

        (unless package-archive-contents
         (package-refresh-contents))

        (unless (package-installed-p 'use-package) 
          (package-install 'use-package))

        ;; install packages automatically if not already present on your
        ;; system to be global for all packages
        (require 'use-package)
        (setq use-package-always-ensure t)


        ;; (let ((dir (locate-user-emacs-file "lisp"))) 
        ;;   (add-to-list 'load-path (file-name-as-directory dir)))

        ;; (setq custom-file (locate-user-emacs-file "lisp/custom.el"))
        (setq custom-file (locate-user-emacs-file "etc/custom.el"))
        (when (file-exists-p custom-file) 
          (load custom-file))

          ;;; auto save when emacs lose focus
        (if (version< emacs-version "27") 
            (add-hook 'focus-out-hook 'zv-save-all-unsaved) 
          (setq after-focus-change-function 'zv-save-all-unsaved))

      ;; Disabling External Pin Entry for gpg
      ;; https://www.masteringemacs.org/article/keeping-secrets-in-emacs-gnupg-auth-sources

    ;;  (setq browse-url-browser-function 'browse-url-chromium)
    (setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "/bin/chromium")


    (setq dired-dwim-target t)
    (setq frame-resize-pixelwise t)
    (setq image-types (cons 'svg image-types))

(defun zv-save-all-unsaved () 
  "Save all unsaved files. no ask.
see http://xahlee.info/emacs/emacs/emacs_auto_save.html" 
  (interactive) 
  (save-some-buffers t ))

;; open initial file for edit
(defun open-zv-initial-file() 
  "open zv initial fiel for edit" 
  (interactive) 
  (find-file "~/.local/share/chezmoi/context-org/emacs-init.org"))

;; (defun zv-package-installed-p () 
;;   "predicate the package wether install"
;;   (cl-loop for pkg in zv-packages when (not (package-installed-p pkg)) do
;;            (return nil) finally (return t)))


;; replace template
(defun autoinsert-yas-expand() 
  "Replace text in yasnippet template."
  (yas-expand-snippet (buffer-string) 
                      (point-min) 
                      (point-max)))

(defun zv-file-name (filename) 
  "return the file name with extension no directory"
  (let (ext (file-name-extension filename)) 
    (if (null ext) 
        (file-name-base filename) 
      (file-name-with-extension (file-name-base filename) ext))))


(defun zv-render-config-path (default-path) 
  "change package default config file path to mysql"
  (expand-file-name (zv-file-name default-path) zv-config-dir))


;; (defun zv-agenda-files () 
;;   (let ( (zv-agenda-dir (expand-file-name zv-private-dir)) 
;;          (agenda-files)) 
;;     (push (expand-file-name "tasks.org" zv-agenda-dir) agenda-files ) 
;;     (push (expand-file-name "habits.org" zv-agenda-dir) agenda-files ) 
;;     (push (expand-file-name "archive.org" zv-agenda-dir) agenda-files )))

(defun zv-org-agenda-files ()
  (list
   (concat zv-private-dir "task/task.org.gpg")
   (concat zv-private-dir "misc/habits.org")))

(defun zv-org-refile-files ()
  (list
   (concat zv-private-dir "task/task.org.gpg")
   (concat zv-private-dir "ideas/idea.org")))


(defun zv-scroll-other-window() 
  (interactive) 
  (scroll-other-window 1))

(defun zv-scroll-other-window-down () 
  (interactive) 
  (scroll-other-window-down 1))

;; (defun insert-current-time()
;;   "Insert time at point with format-time-string."
;;   (interactive)
;;   (save-excursion
;;     (insert (format-time-string " %R "))))

(defun insert-current-time()
  "Insert time at point with format-time-string."
  (interactive)
  (insert (format-time-string "%R ")))



(defun insert-current-date()
  "Insert date at point with format-time-string."
  (interactive)
  (insert (format-time-string "%m-%d %A ")))

(defun font-installed-p (font-name)
"Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(setenv "GPG_AGENT_INFO" nil)
    (require 'epa-file)
;;    (custom-set-variables '(epg-gpg-program  "/usr/bin/gpg2"))
    (epa-file-enable)
;; comment this config for sshd RemoteForward
;;    (setq epg-pinentry-mode 'loopback)

(defconst zv-config-dir (locate-user-emacs-file "config") 
  "custom config path for setting file example: recentf bookmark etc .. ")

;; (defconst zv-config-recentf-file (expand-file-name "recentf" zv-config-dir)
;;   "recentf open file history")

;; (defconst zv-config-bookmark-file (expand-file-name "bookmarks" zv-config-dir)
;;   "user bookmark file")

(defconst zv-config-undo-file (expand-file-name "undo" zv-config-dir) 
  "user undo tree file")

(defconst zv-private-dir "~/private/daily/"
  "custom config path for private file")

;; https://orgmode.org/manual/Template-elements.html
(defconst zv-capture-habits (concat zv-private-dir "misc/habits.org")
  "org capture template special file: habits")

(defconst zv-capture-tasks (concat zv-private-dir "task/task.org.gpg")
  "org capture template special file: tasks")

(defconst zv-capture-journal (concat zv-private-dir "journal/journal.org.gpg")
  "org capture template special file: journal")

(defconst zv-capture-study (concat zv-private-dir "misc/study.org")
  "org capture template special file: study")


(defconst zv-font-size 160 "font size default")

(when  (eq system-type 'gnu/linux)
  (setq zv-font-size 120))

(require 'server)
  (or (server-running-p)
      (server-start))

;; better default setting
  ;; tool-bar-mode either is function or is variable
  ;; see C-h v and C-h f
  ;; function
  (progn (tool-bar-mode -1) 
         (tooltip-mode -1) 

         ;; F10 call menu bar mode
         (menu-bar-mode -1) 

         ;; emacs-nox， disable blew variable 
         (set-fringe-mode 10)
         (set-scroll-bar-mode nil) 

         ;; save file open location
         (save-place-mode 1) 

         ;; M-x , M-n ,M-p
         (savehist-mode 1)

         (global-hl-line-mode t) 
         (column-number-mode) 
         (global-display-line-numbers-mode t)
         ;; when enabled, typing an open parenthesis automatically insert
         ;; the corresponding closing parentheses,and vice versa;
         (electric-pair-mode 1)
         ;; run server mode
         ;;(server-start)

         ;; A cool mode to revert window configurations.
         (winner-mode 1)

         ;; Revert buffers when the underlying file has changed
         (global-auto-revert-mode 1)
         ;; auto save visited
         (auto-save-visited-mode 1))

  (progn
    ;; inhibit create lock files
    (setq create-lockfiles nil)
    ;; press C-g ,show difference result
    (setq visible-bell t)


    (if (eq system-type 'darwin)
        (setq visible-bell nil))

    (setq auto-save-default t)
    ;; (setq auto-save-visited-interval 30)
    (setq make-backup-files nil)

    ;; use command ls options '--dired' for dired mode ,avoid check.

    ;; linux setting
     (setq dired-use-ls-dired t)
    ;; mac setting
      (if (eq system-type 'darwin)
          (setq ls-lisp-use-insert-directory-program nil)
          (require 'ls-lisp))

    ;; variable
    (setq inhibit-startup-screen t)      ; close start up screen display

    ;; When emacs asks for "yes" or "no", let "y" or "n" suffice
    (setq use-short-answers t)

    ;; Confirm to quit
    ;; (setq confirm-kill-emacs 'yes-or-no-p)

    ;; (setq initial-buffer-choice 'recentf-open-files)
    ;; https://github.com/emacscollective/no-littering
    (setq kill-whole-line t)

    (setq use-dialog-box nil)

    ;; (setq tab-width 4)
    ;; (setq default-tab-width 4) 
    (setq-default tab-width 4 )

    ;; Revert Dired and other buffers
    (setq global-auto-revert-non-file-buffers t)

    (setq history-length 25)
    ;; tab bar mode
    (setq tab-bar-show nil)
    (setq tab-bar-close-button-show nil)
    (setq tab-bar-new-button-show nil)
    (setq tab-bar-new-tab-choice "*scratch*"))


  ;;; change new tab bar name
  ;; (add-hook 'tab-bar-tab-post-open-functions
  ;; 	  (lambda (&rest _) (call-interactively #'tab-bar-rename-tab)))


  ;; Disable line numbers for some modes
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  shell-mode-hook
                  treemacs-mode-hook
                  vterm-mode-hook
                  eshell-mode-hook)) 
    (add-hook mode (lambda () 
                     (display-line-numbers-mode -1 ))))

  (defun zv-set-font-faces ()
    (when (display-graphic-p)
      ;; setting font
      (set-face-attribute 'default nil 
                          :family "JetBrains Mono" 
                          :foundry "JB" 
                          ;; :slant 'italic 
                          :weight 'extra-bold 
                          :height zv-font-size
                          :width 'normal)


      ;; Set the variable pitch face
      (set-face-attribute 'variable-pitch nil 
                          :font "JetBrains Mono" 
                          :height zv-font-size 
                          :weight 'regular)


      ;; Set the fixed pitch face
      (set-face-attribute 'fixed-pitch nil 
                          :font "JetBrains Mono" 
                          :height zv-font-size
                          :width 'regular)
      ;; https://baohaojun.github.io/perfect-emacs-chinese-font.html
      ;; https://emacs-china.org/t/emacs/15676
      ;; (if (eq system-type 'darwin)
      ;;     (set-fontset-font t 'unicode (font-spec
      ;;                                 :family "Songti SC"
      ;;                                 :height 160
      ;;                                 :width 'regular)))
      ;; (if (eq system-type 'gnu/linux)
      ;;     (set-fontset-font t 'unicode (font-spec
      ;;                                 :family "WenQuanYi Zen Hei"
      ;;                                 :height 120
      ;;                                 :width 'regular)))
      ;;  ;; Specify font for Chinese characters
      (cl-loop for font in '("Songti SC" "Noto Sans Mono CJK TC" "WenQuanYi Zen Hei" "PingFang SC" "Microsoft Yahei" "STFangsong" )
              when (font-installed-p font)
              return (progn
                      (setq face-font-rescale-alist `((,font . 1.2)))
                      (set-fontset-font t '(#x4e00 . #x9fff) (font-spec
                                                              :family font
                                                              ;; :size 25
                                                              :width 'normal
                                                              :height zv-font-size))))


      ;; (setq face-font-rescale-alist '(("Songti SC" . 1.2) ("WenQuanYi Zen Hei" . 1.2)))
      ;; (set-fontset-font t '(#x2ff0 . #x9ffc) (font-spec
      ;;                                         :family "Noto Color Emoji"
      ;;                                         :size 18
      ;;                                         :weight 'bold))

      (setq doom-modeline-icon t))
    )

(add-hook 'after-init-hook 'zv-set-font-faces)
(add-hook 'server-after-make-frame-hook 'zv-set-font-faces)

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;;               (lambda (frame)
;;                 ;; (setq doom-modeline-icon t)
;;                 (with-selected-frame frame
;;                   (efs/set-font-faces))))
;;     (efs/set-font-faces))


;; Let the desktop background show through
(set-frame-parameter (selected-frame) 'alpha '(97 . 100))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(use-package doom-themes 
  ;; :init (load-theme 'doom-palenight t))
  :init (load-theme 'doom-spacegrey t))

(use-package rainbow-delimiters 
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons)

(use-package doom-modeline 
  :init (doom-modeline-mode 1) 
  :custom ((doom-modeline-height 15)))

;; delete select region
(use-package hungry-delete 
  :config (global-hungry-delete-mode))

(use-package hydra)

(use-package general 
  :config (general-create-definer zv-leader-keys 
                                  :keymaps '(normal insert visual emacs) 
                                  :prefix "SPC" 
                                  :global-prefix "C-SPC"))

;;;  text controll
(defhydra hydra-text-scale 
  (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in") 
  ("k" text-scale-decrease "out") 
  ("f" nil "finished" 
   :exit t))


(zv-leader-keys "s" '(:ignore t :which-key "common setting")
                "st" '(counsel-load-theme :which-key "choose theme")
                "sf" '(hydra-text-scale/body :which-key "scale text"))

;;;  window controll
(defhydra hydra-window-size 
  (:color red)
  "Windows size" ("h" shrink-window-horizontally "shrink horizontal") 
  ("j" shrink-window "shrink vertical") 
  ("k" enlarge-window "enlarge vertical") 
  ("l" enlarge-window-horizontally "enlarge horizontal"))

(defhydra hydra-window-frame 
  (:color red)
  "Frame" ("f" make-frame "new frame") 
  ("x" delete-frame "delete frame"))

(defhydra hydra-window-scroll 
  (:color red)
  "Scroll other window" ("n" zv-scroll-other-window "scroll") 
  ("p" zv-scroll-other-window-down "scroll down"))


(zv-leader-keys "w" '(:ignore t :which-key "window")
                "ww" '(hydra-window-size/body :which-key "Window Size")
                "wo" '(hydra-window-scroll/body :which-key "window Scroll")
                "w;" '(hydra-window-frame/body :which-key "Window Frame"))

  ;;;  window controll
  (defhydra hydra-tab-bar
    (:color red)
    "Tab-Bar controll"
    ("c" tab-bar-new-tab "new tab-bar" :exit t) 
    ("r" tab-bar-switch-to-recent-tab "recent tab-bar" :exit t) 
    ("w" tab-list "list tab-bar" :exit t)  
    ("n" tab-bar-switch-to-next-tab "next tab-bar" :exit t)  
    ("p" tab-bar-switch-to-prev-tab "previous tab-bar" :exit t))
  (zv-leader-keys "t" '(hydra-tab-bar/body :which-key "Tab Bar"))

;;; org controll
(defun zv-org-task ()
             (interactive)
             (org-capture nil "tt"))

(defun zv-org-journal ()
             (interactive)
             (org-capture nil "jj"))

(defhydra hydra-org-fluent
  (:color red :timeout 3)
  "Org"
  ("a" org-agenda "agenda" :exit t)
  ("c" org-capture "capture" :exit t)
  ("t" zv-org-task "capture task" :exit t)
  ("j" zv-org-journal "capture journal" :exit t)
  ("l" org-store-link "store link" :exit t) 
  ("i" org-insert-last-stored-link "insert store link" :exit t)
  ("s" org-download-screenshot "screenshot" :exit t))


(zv-leader-keys "o" '(hydra-org-fluent/body :which-key "Org Fluent"))

;;; frequent file 
(defhydra hydra-file-frequent
  (:color red :timeout 3)
  "Frequent File"
  ("c" open-zv-initial-file "emacs config org" :exit t)
  ("j" (find-file zv-capture-journal) "journal org" :exit t)
  ("s" (find-file zv-capture-study) "study org" :exit t)
  ("t" (find-file zv-capture-tasks) "tasks org" :exit t))

(zv-leader-keys "f" '(hydra-file-frequent/body :which-key "Frequent File"))

;;; hideshow mode

(zv-leader-keys "h" '(:ignore t :which-key "hideshow block")
                "hb" '(hs-hide-block :which-key "hide block")
                "hs" '(hs-show-block :which-key "show block"))

(use-package no-littering)

(use-package which-key 
  :init (which-key-mode) 
  :diminish which-key-mode 
  :config (setq which-key-idle-delay 1))

(use-package helpful 
  :custom (counsel-describe-function-function #'helpful-callable) 
  (counsel-describe-variable-function #'helpful-variable) 
  :bind ([remap describe-function] . counsel-describe-function) 
  ([remap describe-command] . helpful-command) 
  ([remap describe-variable] . counsel-describe-variable) 
  ([remap describe-key] . helpful-key))

(use-package projectile 
  :demand t 
  :diminish projectile-mode 
  :config (progn 
          (setq projectile-enable-caching t))
  (projectile-mode t) 
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package recentf 
  :config (progn 
            (setq recentf-auto-cleanup 'never) 
            (setq recentf-max-menu-items 25) 
            (setq recentf-max-saved-items 25)
            ;; (setq recentf-save-file (zv-render-config-path recentf-save-file))
            ) 
  (recentf-mode t) 
  :bind ("C-x C-r" . 'counsel-recentf) 
  :diminish nil)

(use-package company 
  :hook (after-init . global-company-mode) 
  :config (setq company-tooltip-align-annotations t company-tooltip-limit 20
                company-show-numbers t company-idle-delay .3
                company-minimum-prefix-length 3) 
  :bind (:map company-active-map
                ("C-n" . company-select-next) 
                ("C-p" . company-select-previous)))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1))

(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode 1))

(prescient-persist-mode 1)

(use-package yasnippet 
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :after (yasnippet))

;; 模板生成工具，写代码时随手生成一个模板。强烈推荐使用
;; 使用方法： https://github.com/abo-abo/auto-yasnippet#usage
(use-package auto-yasnippet
  :bind
  (("C-c & w" . aya-create)
   ("C-c & y" . aya-expand))
  :config
  (setq aya-persist-snippets-dir (concat user-emacs-directory "snippets")))

(use-package autoinsert 
  :init
  ;; Don't want to be prompted before insertion:
  (setq auto-insert-query nil) 
  (setq auto-insert-directory (locate-user-emacs-file "templates")) 
  (add-hook 'find-file-hook 'auto-insert) 
  (auto-insert-mode 1) 
  :config
  ;; (define-auto-insert "\\.org?$" "org-header.org"))
  (define-auto-insert "\\.org?$" [ "org-header.org" autoinsert-yas-expand]))

(use-package  bookmark 
  :ensure nil 
  ;; :config (setq bookmark-default-file (zv-render-config-path bookmark-default-file))
  :config (setq bookmark-save-flag 1))

(use-package  just-mode )

(use-package  chezmoi )

(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))
(use-package nix-drv-mode
  :ensure nix-mode
  :mode "\\.drv\\'")
(use-package nix-shell
  :ensure nix-mode
  :commands (nix-shell-unpack nix-shell-configure nix-shell-build))
(use-package nix-repl
  :ensure nix-mode
  :commands (nix-repl))

(use-package  lua-mode)

(add-hook 'conf-space-mode-hook
         (lambda ()
           (setq indent-line-function 'insert-tab)
           (setq tab-width 4)
           (setq indent-tabs-mode t)))

(use-package hideshow
  ; 在所有编程模式中启用
  ;;:hook (prog-mode . hs-minor-mode) 
  :hook (sh-mode . hs-minor-mode))

(use-package  plantuml-mode
  :after org
  :config
  (setq plantuml-jar-path (expand-file-name "~/.local/lib/java/plantuml.jar"))

  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (setq plantuml-default-exec-mode 'jar))

;; (setq org-plantuml-jar-path (expand-file-name "~/.local/lib/java/plantuml.jar"))

(use-package graphviz-dot-mode
  :after org
  :config
  (add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))
  (setq graphviz-dot-indent-width 4))

(use-package  json-mode)

(use-package  yaml-mode)

(use-package format-all
  :preface
  (defun ian/format-code ()
    "Auto-format whole buffer."
    (interactive)
    (if (derived-mode-p 'prolog-mode)
        (prolog-indent-buffer)
      (format-all-buffer)))
  :config
  (global-set-key (kbd "M-F") #'ian/format-code)
  (add-hook 'prog-mode-hook #'format-all-ensure-formatter))

(use-package transpose-frame)

;; (use-package elisp-autofmt
;;              :commands (elisp-autofmt-mode)
;;              :hook (emacs-lisp-mode . elisp-autofmt-mode)
;;              :straight
;;              (elisp-autofmt
;;                :files (:defaults "elisp-autofmt")
;;                :host nil
;;                :type git
;;                :local-repo "~/.emacs.d/straight/repos/emacs-elisp-autofmt.git"))
;; (use-package 
;;   elisp-format 
;;   :ensure t 
;;   :init (progn (add-hook 'emacs-lisp-mode-hook #'eldoc-mode) 
;;                (setq indent-tabs-mode nil)) 
;;   :bind (:map emacs-lisp-mode-map
;;               ("C-x C-e" . pp-eval-last-sexp) 
;;               ("C-M-l" . elisp-format-buffer)) 
;;   :config (setq elisp-format-column 80 elisp-format-indent-comment t))

;; (use-package lispy
;;   :hook
;;   ((emacs-lisp-mode . lispy-mode)
;;    (scheme-mode . lispy-mode)))

;; (use-package srefactor
;;   :config (progn
;; 	    (require 'srefactor-lisp)
;; 	    (semantic-mode 1)):bind
;;   (:map emacs-lisp-mode-map
;; 	("C-x C-e" . pp-eval-last-sexp)
;; 	("C-M-l" . srefactor-lisp-format-buffer)))
;; (use-package emr)

;; (use-package paredit
;;   :ensure t
;;   :init
;;   (progn
;;     (add-hook 'clojure-mode-hook #'enable-paredit-mode)
;;     (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
;;     (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
;;     (add-hook 'ielm-mode-hook #'enable-paredit-mode)
;;     (add-hook 'lisp-mode-hook #'enable-paredit-mode)
;;     (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
;;     (add-hook 'scheme-mode-hook #'enable-paredit-mode))
;;   :config
;;   (show-paren-mode t)
;;   ;; (define-key paredit-mode-map (kbd "M-J") 'paredit-join-sexps)
;;   :bind
;;   (:map paredit-mode-map
;;         ("C-M-f" . paredit-forward)
;;         ("C-M-b" . paredit-backward)
;;         ("M-j" . paredit-join-sexps))
;;   )

;;   ;;  (load (expand-file-name "~/.quicklisp/slime-helper.el")) 
;;   ;;   (setq inferior-lisp-program "sbcl")

;; (define-key global-map (kbd "C-c t") (lambda ()
  ;; 				       (interactive)
  ;; 				       (org-capture nil "tt")))

  ;; (global-set-key (kbd "C-c a") #'org-agenda)
  ;; (global-set-key (kbd "C-c c") #'org-capture)
  ;; (global-set-key (kbd "C-c l") #'org-store-link)


  ;; 禁用左尖括号
  ;; (setq electric-pair-inhibit-predicate
  ;; `(lambda (c)
  ;; (if (char-equal c ?\<) t (,electric-pair-inhibit-predicate c))))

  (require 'org-tempo)
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local electric-pair-inhibit-predicate
                          `(lambda (c)
                             (if (char-equal c ?\<) t
                               (,electric-pair-inhibit-predicate c))))))



  (defun zv-org-font-setup ()

    ;; Load org-faces to make sure we can set appropriate faces
    (require 'org-faces)

    ;; Replace list hyphen with dot

    ;; (font-lock-add-keywords 'org-mode
    ;; 			  '(("^ *\\([-]\\) "
    ;; 			     (0
    ;; 			      (prog1 ()
    ;; 				(compose-region (match-beginning 1)
    ;; 						(match-end 1)
    ;; 						"•"))))))
    ;; ;; Set faces for heading levels

    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face)
                          nil
                          :font "JetBrains Mono"
                          :weight 'regular
                          :height (cdr face)))
    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil
                        :inherit 'fixed-pitch)
    (set-face-attribute 'org-code
                        nil
                        :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table
                        nil
                        :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim
                        nil
                        :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword
                        nil
                        :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line
                        nil
                        :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))


  (defun zv-org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode 1)
    (visual-line-mode 1))


  ;;; overwite org-mode-map org-reveal keybinding
  ;; (with-eval-after-load 'org
  ;;   (define-key org-mode-map (kbd "C-c C-r") #'ivy-resume ))

  ;; (use-package org-bullets
  ;;   :after org
  ;;   :hook (org-mode . org-bullets-mode)
  ;;   :custom
  ;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

  ;; (use-package 'org-id)

  (require 'org-id)

  (setq org-id-link-to-org-use-id "create-if-interactive")
  (setq org-M-RET-may-split-line nil)

  ;;;  https://github.com/akirak/org-reverse-datetree
(use-package org-reverse-datetree :after org)

(use-package org
          :hook (org-mode . zv-org-mode-setup)
          :config
          (progn
            ;; org-mode
            (setq org-src-fontify-natively t)
            (setq org-startup-folded 'content)
            (setq org-return-follows-link t)
            (setq org-startup-truncated nil)
            (setq org-startup-with-inline-images t)
            (setq org-startup-indented t)
            (setq org-adapt-indentation t)
            ;; (setq org-indent-mode-turns-off-org-adapt-indentation t)
            ;; (setq org-hide-leading-stars t)
            ;; (setq org-indent-mode-turns-on-hiding-stars t)
            ;; two stars will being added/taken away, not beautful
            ;; (setq org-odd-levels-only t)

            (setq org-tags-column 0)

            (setq org-yank-adjusted-subtrees t)
            (setq org-ellipsis " ▾")
            (setq org-hide-emphasis-markers t)
            (zv-org-font-setup)
            ;; agenda config
            (setq org-agenda-start-with-log-mode t)
            (setq org-log-done 'time)
            (setq org-log-into-drawer t)
            (setq org-agenda-files (zv-org-agenda-files))

            (require 'org-habit)
            (add-to-list 'org-modules 'org-habit)
            (setq org-habit-graph-column 60)
            (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
                                      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)"
                                                "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)"
                                                "|" "COMPLETED(c)" "CANC(k@)")))

            ;; archive config
            (setq org-archive-location (format "%s::datetree/* Archive-%%s"
                                               (concat zv-private-dir "archive/default_done.org")))

            (setq org-refile-targets '((zv-org-refile-files :maxlevel . 1)))

            (setq org-log-refile 'time)
            ;; Depending on org-reverse-note-order, it is either the first or last subitem
            (setq org-reverse-note-order t)
            ;; Save Org buffers after refiling!
            (advice-add 'org-refile :after 'org-save-all-org-buffers)
                                                ; Put mutually exclusive tags here
            (setq org-tag-alist '((:startgroup)
                                  (:endgroup)
                                  ("@errand" . ?E)
                                  ("@home" . ?H)
                                  ("@work" . ?W)
                                  ("agenda" . ?a)
                                  ("planning" . ?p)
                                  ("note" . ?n)
                                  ("noexport" . ?N)
                                  ("idea" . ?i)))
            ;; configure custom agenda views
            (setq org-agenda-custom-commands '(("d" "Dashboard"
                                                ((agenda ""
                                                         ((org-deadline-warning-days 7)))
                                                 (todo "NEXT"
                                                       ((org-agenda-overriding-header "Next Tasks")))
                                                 (tags-todo "agenda/ACTIVE"
                                                            ((org-agenda-overriding-header "Active Projects")))))
                                               ("n" "Next Tasks"
                                                ((todo "NEXT"
                                                       ((org-agenda-overriding-header "Next Tasks")))))
                                               ("W" "Work Tasks" tags-todo "+work-email")
                                               ;; Low-effort next actions
                                               ("e" tags-todo
                                                "+TODO=\"NEXT\"+Effort<15&+Effort>0"
                                                ((org-agenda-overriding-header "Low Effort Tasks")
                                                 (org-agenda-max-todos 20)
                                                 (org-agenda-files org-agenda-files)))
                                               ("w" "Workflow Status"
                                                ((todo "WAIT"
                                                       ((org-agenda-overriding-header "Waiting on External")
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "REVIEW"
                                                       ((org-agenda-overriding-header "In Review")
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "PLAN"
                                                       ((org-agenda-overriding-header "In Planning")
                                                        (org-agenda-todo-list-sublevels nil)
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "BACKLOG"
                                                       ((org-agenda-overriding-header "Project Backlog")
                                                        (org-agenda-todo-list-sublevels nil)
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "READY"
                                                       ((org-agenda-overriding-header "Ready for Work")
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "ACTIVE"
                                                       ((org-agenda-overriding-header "Active Projects")
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "COMPLETED"
                                                       ((org-agenda-overriding-header "Completed Projects")
                                                        (org-agenda-files org-agenda-files)))
                                                 (todo "CANC"
                                                       ((org-agenda-overriding-header "Cancelled Projects")
                                                        (org-agenda-files org-agenda-files)))))))

            (setq org-capture-templates `(("t" "Tasks/Projects")
                                          ("tt" "Task" entry (file+olp zv-capture-tasks "Inbox")
                                           "* TODO %?\n"
;;                                           :prepend "first child"
                                           :empty-lines 1)
                                          ("j" "Journal Entries")
                                          ;; ("jj" "Journal" entry (file+olp+datetree zv-capture-journal)
                                          ;;  "\n* %<%R> \n\n%?\n\n"
                                          ;;  :tree-type week
                                          ;;  ;; :prepend "first child"
                                          ;;  :prepend t
                                          ;;  :empty-lines 1)
                                          ("jj" "Jorunal" entry
                                           (file+function zv-capture-journal
                                                          (lambda ()
                                                            (org-reverse-datetree-goto-date-in-file nil )))
                                                            ;;(org-reverse-datetree-goto-date-in-file nil :olp '("Group" "Subgroup 1"))))
                                           "\n* %<%R> \n%?\n\n"
                                           :prepend t
                                           :empty-lines-after 1
                                           :empty-lines 0)
                                          ;; ("jm" "Meeting"
                                          ;;  entry
                                          ;;  (file+olp+datetree zv-capture-journal)
                                          ;;  "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
                                          ;;  :clock-in :clock-resume
                                          ;;  :empty-lines 1)
                                          ;; ("w" "Workflows")
                                          ;; ("we" "Checking Email"
                                          ;;  entry
                                          ;;  (file+olp+datetree zv-capture-journal)
                                          ;;  "* Checking Email :email:\n\n%?"
                                          ;;  :clock-in :clock-resume
                                          ;;  :empty-lines 1)
                                          ("m" "Metrics Capture")
                                          ("mp" "push-up"
                                           table-line
                                           (file+headline zv-capture-habits "push-up")
                                           "| %U | %^{Num} | %^{Notes} |"
                                           :prepend "first table line"
                                           :kill-buffer t))))
          :bind
        ;;; overwite org-mode-map org-reveal keybinding
          (:map org-mode-map
                ("C-c C-r" . ivy-resume)))

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :config
  (org-superstar-configure-like-org-bullets)
  ;; This is usually the default, but keep in mind it must be nil
  (setq org-hide-leading-stars nil)
  ;; This line is necessary.
  (setq org-superstar-leading-bullet ?\s)
  ;; If you use Org Indent you also need to add this, otherwise the
  ;; above has no effect while Indent is enabled.
  (setq org-indent-mode-turns-on-hiding-stars nil)

  ;; Set different bullets, with one getting a terminal fallback.
  (setq org-superstar-headline-bullets-list
        '("◉" "○" "●" "○" "●" "○" "●"))
  ;; Stop cycling bullets to emphasize hierarchy of headlines.
  (setq org-superstar-cycle-headline-bullets nil)
  ;; Hide away leading stars on terminal.
  (setq org-superstar-leading-fallback ?\s)

  (setq org-superstar-prettify-item-bullets t)
  (setq org-superstar-item-bullet-alist
        '((?* . ?•)
          (?+ . ?➤)
          (?- . ?•)))

  (set-face-attribute 'org-superstar-item nil :height 1.2)
  (set-face-attribute 'org-superstar-header-bullet nil :height 1.2)
  (set-face-attribute 'org-superstar-leading nil :height 1.3))

(use-package org-download
  :after org
  :defer nil
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  (org-image-actual-width nil)
  ;;(org-download-image-attr-list '("#+attr_html: :width 50% :align center" "#+attr_org: :width 100px"))
  (org-download-image-attr-list '("#+attr_html: :width 50% :align center" "#+attr_org: :width 50% :align left"))

  ;; (if (eq system-type 'gnu/linux)
    ;; (org-download-screenshot-method "export QT_AUTO_SCREEN_SCALE_FACTOR=0  QT_SCREEN_SCALE_FACTORS=\"1;1\" ;  flameshot  gui -s --raw > %s"))
  ;; (if (eq system-type 'gnu/linux)
  ;;   (org-download-screenshot-method "flameshot gui -s --raw > %s"))

  :bind
 ;; ("C-M-y" . org-download-screenshot)
  ("C-M-y" . org-download-clipboard)
  :config
  (require 'org-download))

(use-package ox-hugo
  :ensure t   
  :after ox)

(setq org-src-tab-acts-natively t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (dot . t)
   (plantuml . t)
   (python . t)))

(add-to-list 'org-structure-template-alist '("sc" . "src conf"))
(add-to-list 'org-structure-template-alist '("sd" . "src dot"))
(add-to-list 'org-structure-template-alist '("sy" . "src yaml"))
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("se" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sp" . "src python"))
(add-to-list 'org-structure-template-alist '("sl" . "src plantuml"))

(defun zv-sh-mode-visual-fill ()
  (setq
   ;; 设置这个值后，垂直切分窗口后，visual-fill-column 失效
   visual-fill-column-width 150			;
   visual-fill-column-center-text t
   ;; 边距在窗口内显示
   visual-fill-column-fringes-outside-margins nil 
   visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-mode 1))

(defun zv-org-mode-visual-fill ()
  (setq
   ;; 设置这个值后，垂直切分窗口后，visual-fill-column 失效
   visual-fill-column-width 150			;
   visual-fill-column-center-text t
   ;; 边距在窗口内显示
   visual-fill-column-fringes-outside-margins nil 
   visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-mode 1))

 (use-package visual-fill-column
   :hook (org-mode . zv-org-mode-visual-fill)
   :hook (sh-mode . zv-sh-mode-visual-fill)
      :config
      ;; 确保在窗口大小变化时重新计算
      (add-hook 'window-size-change-functions
                  (lambda (window)
                  (when (eq (buffer-local-value 'major-mode (window-buffer window))
                              'org-mode)
                      (zv-org-mode-visual-fill)))))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  ;; (setq org-roam-dailies-directory "journal/")
  (setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:10}" 'face 'org-tag)))
  :custom
  (org-roam-directory "~/private/notes")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%H:%M> \n%?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

  (org-roam-capture-templates
   '(("d" "default" plain
      "* %?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %<%D>\n\n")
      :unnarrowed t)

     ("b" "blogs" plain
      (file "~/.emacs.d/etc/templates/roam/blogs-temp.org")
      :if-new (file "blogs/content-org/${slug}/${slug}.org")
      :unnarrowed t)

     ("n" "tools notes" plain
      (file "~/.emacs.d/etc/templates/roam/tools-note.org")
      :if-new (file "tools/${slug}/${slug}.org")
      :unnarrowed t)

     ("t" "trivial notes" plain
      (file "~/.emacs.d/etc/templates/roam/trivial-note.org")
      :if-new (file "trivial/%<%Y%m%d%H%M%S>-${slug}.org")
      :unnarrowed t)

     ("w" "work" plain
      (file "~/.emacs.d/etc/templates/roam/work-note.org")
      :if-new (file "work/${slug}/${slug}.org")
      :unnarrowed t)))

  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         :map org-mode-map
         ("C-M-i"   . completion-at-point)
         ;; :map org-roam-dailies-map
         ;; ("Y" . org-roam-dailies-capture-yesterday)
         ;; ("T" . org-roam-dailies-capture-tomorrow))
         )

  ;; :bind-keymap
  ;; ("C-c n d" . org-roam-dailies-map)
  :config
  ;; (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-setup)
  ;; (setq org-roam-database-connector 'sqlite-builtin)

  (org-roam-db-autosync-mode))

(defun zv-org-present-prepare-slide ()
  (org-overview)
  (org-show-entry)
  (org-show-children))

(defun zv-org-present-hook ()
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.5) variable-pitch)
                                     (org-code (:height 1.55) org-code)
                                     (org-verbatim (:height 1.55) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))
  (setq header-line-format " ")
  (org-display-inline-images)
  (zv-org-present-prepare-slide))

(defun zv-org-present-quit-hook ()
  (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq header-line-format nil)
  (org-present-small)
  (org-remove-inline-images))

(defun zv-org-present-prev ()
  (interactive)
  (org-present-prev)
  (zv-org-present-prepare-slide))

(defun zv-org-present-next ()
  (interactive)
  (org-present-next)
  (zv-org-present-prepare-slide))

(use-package org-present
  :bind (:map org-present-mode-keymap
         ("C-c C-j" . zv-org-present-next)
         ("C-c C-k" . zv-org-present-prev))
  :hook ((org-present-mode . zv-org-present-hook)
         (org-present-mode-quit . zv-org-present-quit-hook)))

;; https://writequit.org/denver-emacs/presentations/2017-04-11-ivy.html
;; https://marcohassan.github.io/bits-of-experience/pages/emacs/
;; https://oremacs.com/swiper/
;; https://cestlaz.github.io/posts/using-emacs-6-swiper/
;; it looks like counsel is a requirement for swiper
(use-package counsel 
  :ensure t)

(use-package swiper 
  :ensure t 
  :config (progn (ivy-mode 1) 
                 (setq ivy-use-virtual-buffers t) 
                 (setq ivy-count-format "(%d/%d) ") 
                 (setq projectile-completion-system 'ivy)
                 ;; Ivy-based interface to standard commands
                 (global-set-key (kbd "C-s") 'swiper-isearch) 
                 (global-set-key (kbd "M-x") 'counsel-M-x) 
                 (global-set-key (kbd "C-x C-f") 'counsel-find-file) 
                 (global-set-key (kbd "M-y") 'counsel-yank-pop) 
                 (global-set-key (kbd "C-x b") 'ivy-switch-buffer) 
                 (global-set-key (kbd "C-c v") 'ivy-push-view) 
                 (global-set-key (kbd "C-c V") 'ivy-pop-view) 
                 ;; (global-set-key (kbd "C-c c") 'counsel-compile)
                 ;;	(global-set-key (kbd "C-c j") 'counsel-git-grep) 
                 (global-set-key (kbd "C-c L") 'counsel-git-log) 
                 (global-set-key (kbd "C-c k") 'counsel-rg) 
                 (global-set-key (kbd "C-c j") 'counsel-file-jump) 
                 (global-set-key (kbd "C-c m") 'counsel-linux-app) 
                 ;;(global-set-key (kbd "C-c n") 'counsel-fzf) 
                 ;;(global-set-key (kbd "C-x l") 'counsel-locate) 
                 ;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox) 
                 ;; (global-set-key (kbd "C-c w") 'counsel-wmctrl)
                 ;; Ivy-resume and other commands
                 (global-set-key (kbd "C-c C-r") 'ivy-resume) 
                 (global-set-key (kbd "C-c b") 'counsel-bookmark) 
                 (global-set-key (kbd "C-c d") 'counsel-descbinds) 
                 ;; (global-set-key (kbd "C-c g") 'counsel-git) 
                 (global-set-key (kbd "C-c o") 'counsel-outline) 
                 ;; (global-set-key (kbd "C-c t") 'counsel-load-theme) 
                 ;;	(global-set-key (kbd "C-c F") 'counsel-org-file)
                 ))

(use-package ivy-rich 
  :init (ivy-rich-mode 1))
;; (ivy-mode)
;; (setq ivy-use-virtual-buffers t)
;; (setq ivy-wrap t)

;;
;; https://config.daviwil.com/emacs#lets-be-evil
;;; Code:

;; (require 'init-constant)

(defun zv-evil-hook () 
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  org-present-mode
                  term-mode)) 
    (add-to-list 'evil-emacs-state-modes mode)))

(defun zv-dont-arrow-me-bro () 
  (interactive) 
  (message "Arrow keys are bad, you know?"))


(use-package undo-tree 
  :defer t 
  :diminish undo-tree-mode 
  :init (global-undo-tree-mode) 
  :config (progn 
            (setq undo-tree-visualizer-diff t)
            (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/config/undo" )))
            (setq undo-tree-visualizer-timestamps t)))

(use-package evil 
  :init (setq evil-want-integration t) 
  (setq evil-want-keybinding nil) 
  (setq evil-want-C-u-scroll t) 
  (setq evil-want-C-i-jump nil) 
  (setq evil-respect-visual-line-mode t) 
  (setq evil-undo-system 'undo-tree) 
  :config
  ;; :config (add-hook 'evil-mode-hook 'zv-evil-hook)
  (evil-mode 1) 
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state) 
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-normal-state-map (kbd "C-e") 'evil-end-of-line)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line) 
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;; 解邦org mode 下C-k键，在emacs中，按错后光标跑的太远了 
  ;;  https://github.com/noctuid/evil-guide
  (evil-define-key 'normal org-mode-map (kbd "C-k") nil)

  ;; 解决evil模式下， C-w C-h 显示help的界面 
  ;; https://www.reddit.com/r/emacs/comments/6bdoxp/evil_cw_h_bind/

  (define-key evil-window-map "\C-h" 'evil-window-left)

  ;; (unless zv-is-termux
  ;;   ;; Disable arrow keys in normal and visual modes
  ;;   (define-key evil-normal-state-map (kbd "<left>") 'zv-dont-arrow-me-bro)
  ;;   (define-key evil-normal-state-map (kbd "<right>") 'zv-dont-arrow-me-bro)
  ;;   (define-key evil-normal-state-map (kbd "<down>") 'zv-dont-arrow-me-bro)
  ;;   (define-key evil-normal-state-map (kbd "<up>") 'zv-dont-arrow-me-bro)
  ;;   (evil-global-set-key 'motion (kbd "<left>") 'zv-dont-arrow-me-bro)
  ;;   (evil-global-set-key 'motion (kbd "<right>") 'zv-dont-arrow-me-bro)
  ;;   (evil-global-set-key 'motion (kbd "<down>") 'zv-dont-arrow-me-bro)
  ;;   (evil-global-set-key 'motion (kbd "<up>") 'zv-dont-arrow-me-bro))
  (evil-set-initial-state 'messages-buffer-mode 'normal) 
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection 
  :after evil 
  :init (setq evil-collection-company-use-tng nil) ;; Is this a bug in evil-collection?
  :custom (evil-collection-outline-bind-tab-p nil) 
  :config (setq evil-collection-mode-list (remove 'lispy evil-collection-mode-list)) 
  (setq evil-collection-mode-list (remove 'org-present evil-collection-mode-list)) 
  (evil-collection-init))


;; https://github.com/emacs-evil/evil-surround
(use-package evil-surround 
  :ensure t 
  :config (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; https://github.com/Fuco1/dired-hacks/tree/7c0ef09d57a80068a11edc74c3568e5ead5cc15a
  ;; https://systemcrafters.net/emacs-from-scratch/effortless-file-management-with-dired/

  ;;; Code:
  (use-package dired 
    :ensure nil 
    :defer 1 
    :after evil-collection
    :commands (dired dired-jump) 
    :config (setq dired-listing-switches "-agho --group-directories-first"
                  ;; dired-omit-files "^\\.[^.].*"
                  ;; dired-omit-verbose nil
                  dired-hide-details-hide-symlink-targets nil
                  delete-by-moving-to-trash t) 

    ;; (autoload 'dired-omit-mode "dired-x") 
    ;; (add-hook 'dired-load-hook (lambda () 
    ;; 			       (interactive) 
    ;; 			       (dired-collapse))) 
    ;; (add-hook 'dired-mode-hook (lambda () 
    ;; 			       (interactive) 
    ;; 			       (dired-omit-mode 1) 
    ;; 			       (dired-hide-details-mode 1) 
    ;; 			       (hl-line-mode 1)))

;;   (use-package dired-single
;;     :load-path "other-packages/dired-single" )
;;     (evil-collection-define-key 'normal 'dired-mode-map
;;       "h" 'dired-single-up-directory
;;       "l" 'dired-single-buffer))

;; github config remote packages
  (use-package dired-single
    :vc (:url "https://github.com/emacsattic/dired-single.git" :rev :newest))
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer))

;; not use dired single
;;    (evil-collection-define-key 'normal 'dired-mode-map
;;      ;;"h" 'dired-single-up-directory
;;      "h" 'dired-up-directory
;;      ;; "H" 'dired-omit-mode
;;      "l" 'dired-find-file))

  ;; (use-package all-the-icons-dired
  ;;   :hook (dired-mode . all-the-icons-dired-mode))

  ;; (use-package dired-ranger) 

  ;; (use-package dired-collapse :defer t)

  (use-package dired-open
    :config
    ;; Doesn't work as expected!
    ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
    (setq dired-open-extensions '(("png" . "feh")
                                  ("mkv" . "mpv"))))

  (use-package dired-hide-dotfiles
    :hook (dired-mode . dired-hide-dotfiles-mode)
    :after evil-collection
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "H" 'dired-hide-dotfiles-mode))

(use-package magit 
  :bind ("C-M-;" . magit-status) 
  :commands (magit-status magit-get-current-branch) 
  :custom (magit-display-buffer-function
           #'magit-display-buffer-same-window-except-diff-v1))

;; https://github.com/emacs-evil/evil-magit
;; (use-package evil-magit
;;   :after magit)

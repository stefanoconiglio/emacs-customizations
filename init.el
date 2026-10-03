;; ./emacs.d/init.el --- Emacs configuration  -*- lexical-binding: nil -*-

(server-start)

;; ==================================
;; ==================================
;; NEW STUFF FROM https://realpython.com/emacs-the-best-python-editor/
;; ==================================
;; ==================================

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)

;; ;; Adds the Melpa archive to the list of available repositories
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/") t)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; Drop new deps in this list; they get installed automatically.
(defvar myPackages
  '(auctex
    better-defaults
    dashboard
    elpy
    ein
    flycheck
    markdown-mode
    use-package
    zerodark-theme))

(dolist (package myPackages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'use-package)

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
;; (load-theme 'zerodark t)            ;; Load zerodark theme
(if (fboundp 'global-display-line-numbers-mode)
    (global-display-line-numbers-mode 1)
  (global-linum-mode t))
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(defun my/python-fill-column ()
  "Show a helpful fill column marker in Python buffers."
  (cond
   ((fboundp 'display-fill-column-indicator-mode)
    (setq display-fill-column-indicator-column 79)
    (display-fill-column-indicator-mode 1))
   ((fboundp 'fci-mode)
    (setq fci-rule-column 79)
    (fci-mode 1))))

;; ;; ====================================
;; ;; Development Setup
;; ;; ====================================
(when (require 'elpy nil t)
  (elpy-enable)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (when (require 'flycheck nil t)
    (add-hook 'elpy-mode-hook #'flycheck-mode))
  (add-hook 'elpy-mode-hook #'my/python-fill-column))

;; (setq elpy-rpc-virtualenv-path 'current)


;; workon home
(setenv "WORKON_HOME" "/home/coniglio/miniconda3/envs")
(when (and (require 'pyvenv nil t)
           (file-directory-p "/home/coniglio/miniconda3/envs/boc"))
  (pyvenv-activate "/home/coniglio/miniconda3/envs/boc"))

;; User-Defined init.el ends here

;; open recent buffers: https://stackoverflow.com/questions/50417/how-do-i-get-list-of-recent-files-in-gnu-emacs
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)




;; (when (fboundp 'electric-indent-mode) (electric-indent-mode -1)) ;; disable auto-indent


;; load majod-dark theme on startup
;;(load-theme 'manoj-dark t)


;; ===============================
;; ===============================
;; ZATHURA
;; ===============================
;; ===============================

;; enable synctex and zathura---taken from here: https://www.reddit.com/r/emacs/comments/a27sg9/how_can_i_set_the_pdfviewer_in_auctex/
(with-eval-after-load 'tex
  (setq TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-mode 1)
  (setq TeX-source-correlate-start-server t)

  (add-to-list 'TeX-view-program-selection
               '(output-pdf "Zathura"))

  ;; latexmk as the default builder
  (setq TeX-command-default "LatexMk")
  (setq TeX-save-query nil) ; just run latexmk without asking to save
  (setq TeX-show-compilation t)
  (add-to-list 'TeX-command-list
               '("LatexMk" "latexmk -pdf -synctex=1 %s" TeX-run-TeX nil t
                 :help "Run latexmk for continuous builds")
               t))

;; ;; ;; enable melpa
;; ;; (require 'package)
;; ;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(TeX-view-program-list (quote (("Zathura" "zathura %o"))))
;;  '(TeX-view-program-selection
;;    (quote
;;     (((output-dvi style-pstricks)
;;       "dvips and gv")
;;      (output-dvi "xdvi")
;;      (output-pdf "Zathura")
;;      (output-html "xdg-open"))))
;;  '(custom-safe-themes
;;    (quote
;;     ("ff79b206ad804c41a37b7b782aca44201edfa8141268a6cdf60b1c0916343bd4" default)))
;;  '(package-selected-packages (quote (auctex markdown-mode zerodark-theme))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

;; ;; set Zathura as editor for auctex
;; ;; TAKEN FROM HERE
;; ;; https://lsandig.org/blog/2015/03/configuring-auctex-to-use-zathura-as-pdf-viewer/en/

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#282c34" "#ff6c6b" "#98be65" "#da8548" "#61afef" "#c678dd" "#1f5582" "#abb2bf"])
 '(custom-safe-themes
   '("e8830baf7d8757f15d9d02f9f91e0a9c4732f63c3f7f16439cc4fb42a1f2aa06" "ff79b206ad804c41a37b7b782aca44201edfa8141268a6cdf60b1c0916343bd4" default))
 '(ispell-dictionary "en_US")
 '(package-selected-packages
   '(pdf-tools eink-theme ein dashboard virtualenv julia-mode auto-complete-auctex zerodark-theme markdown-mode auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (setq ispell-dictionary "english") ; Default dictionary
;; (setq ispell-local-dictionary-alist
;;       '(("english" "[A-Za-z]" "[^A-Za-z]" nil ("-d" "en_US") nil utf-8)
;;         ("italian" "[A-Za-zÀ-ÿ]" "[^A-Za-zÀ-ÿ]" nil ("-d" "it_IT") nil utf-8)))


;; auto-complete-auctex---taken from here: https://tex.stackexchange.com/questions/58998/does-auctex-autocomplete
(add-hook 'LaTeX-mode-hook
      (lambda()
        (local-set-key [C-tab] 'TeX-complete-symbol)))

;; ampl-mode: not on MELPA; installed from its repository on first start
;; (:newest: the repository has no releases)
(use-package ampl-mode
  :vc (:url "https://github.com/ampl/ampl-mode" :lisp-dir "emacs" :rev :newest)
  :mode ("\\.mod\\'" "\\.dat\\'" "\\.ampl\\'" "\\.run\\'")
  :interpreter "ampl")
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


;; dashboard loaded on splash screen
;; from: https://emacs.stackexchange.com/questions/14282/replace-splash-screen-with-list-of-recentf
;; install 'use-package' from melpa before
(use-package dashboard
    :ensure t
    :diminish dashboard-mode
    :config
    ;; (setq dashboard-banner-logo-title "Stat rosa pristina")
    (setq dashboard-items '((recents  . 10)
                            (bookmarks . 10)))
    (dashboard-setup-startup-hook))

;; start maximized
;; https://emacs.stackexchange.com/questions/2999/how-to-maximize-my-emacs-frame-on-start-up
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))


;; org-mode stuff
;; https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


;;;_*======================================================================
;;;from: https://stackoverflow.com/questions/8993183/emacs-scroll-buffer-not-point
;;;_* define a function to scroll with the cursor in place, moving the
;;;_* page instead
;; Navigation Functions
(defun scroll-down-in-place (n)
  (interactive "p")
  (previous-line n)
  (unless (eq (window-start) (point-min))
    (scroll-down n)))

(defun scroll-up-in-place (n)
  (interactive "p")
  (next-line n)
  (unless (eq (window-end) (point-max))
    (scroll-up n)))

;;;mod to use arrow keys: see here: https://stackoverflow.com/questions/38442909/how-do-you-reference-the-meta-and-arrow-key-combinations-in-emacs-init-el
(global-set-key (kbd "<M-up>") 'scroll-up-in-place)
(global-set-key (kbd "<M-down>") 'scroll-down-in-place)


;; stop creating ~files
(setq make-backup-files nil) ; stop creating ~ files
;; ~/.emacs.d/init.el links into a Git repository: visit the target without asking
(setq vc-follow-symlinks t)

;; stop creating #..# files
(setq auto-save-default nil)


;; ;; to ctrl+v images into Latex
;; ;; src: chatGpt: https://chatgpt.com/
;; ;; (defun my-paste-image ()
;; ;;   "Paste an image from the clipboard into a file and insert LaTeX code to include it."
;; ;;   (interactive)
;; ;;   (let* ((image-dir (concat (file-name-directory (buffer-file-name)) "images/"))
;; ;;          (filename (concat (format-time-string "%Y%m%d%H%M%S") ".png"))
;; ;;          (filepath (concat image-dir filename)))
;; ;;     ;; Create the images directory if it doesn't exist
;; ;;     (unless (file-directory-p image-dir)
;; ;;       (make-directory image-dir t))
;; ;;     ;; Save the image from the clipboard to a file
;; ;;     (cond
;; ;;      ((eq system-type 'darwin)
;; ;;       ;; For macOS
;; ;;       (if (executable-find "pngpaste")
;; ;;           (shell-command (format "pngpaste %s" filepath))
;; ;;         (error "Please install 'pngpaste' command-line tool.")))
;; ;;      ((or (eq system-type 'gnu/linux) (eq system-type 'linux))
;; ;;       ;; For Linux
;; ;;       (if (executable-find "xclip")
;; ;;           (shell-command (format "xclip -selection clipboard -t image/png -o > %s" filepath))
;; ;;         (error "Please install 'xclip' command-line tool.")))
;; ;;      ((eq system-type 'windows-nt)
;; ;;       ;; For Windows
;; ;;       (if (executable-find "powershell")
;; ;;           (shell-command
;; ;;            (format "powershell -command \"Add-Type -AssemblyName System.Windows.Forms; \
;; ;; $img = [System.Windows.Forms.Clipboard]::GetImage(); \
;; ;; if ($img -ne $null) { $img.Save('%s'); } else { Write-Error 'No image in clipboard'; exit 1 }\""
;; ;;                    (replace-regexp-in-string "/" "\\\\" filepath t t)))
;; ;;         (error "PowerShell is required but not found.")))
;; ;;      (t
;; ;;       (error "Unsupported system type.")))
;; ;;     ;; Insert LaTeX code to include the image
;; ;;     (insert (format "\\includegraphics[width=\\textwidth]{%s}\n" (concat "images/" filename)))))
;; (defun my-paste-image ()
;;   "Paste an image from the clipboard into a file and insert LaTeX code to include it."
;;   (interactive)
;;   (let* ((image-dir (concat (file-name-directory (buffer-file-name)) "images/"))
;;          (filename (concat (format-time-string "%Y%m%d%H%M%S") ".png"))
;;          (filepath (concat image-dir filename)))
;;     ;; Create the images directory if it doesn't exist
;;     (unless (file-directory-p image-dir)
;;       (make-directory image-dir t))
;;     ;; Save the image from the clipboard to a file
;; ;;     (cond
;; ;;      ((eq system-type 'darwin)
;; ;;       ;; For macOS
;; ;;       (if (executable-find "pngpaste")
;; ;;           (shell-command (format "pngpaste %s" (shell-quote-argument filepath)))
;; ;;         (error "Please install 'pngpaste' command-line tool.")))
;; ;;      ((or (eq system-type 'gnu/linux) (eq system-type 'linux))
;; ;;       ;; For Linux
;; ;;       (if (executable-find "xclip")
;; ;;           (shell-command (format "xclip -selection clipboard -t image/png -o > %s" (shell-quote-argument filepath)))
;; ;;         (error "Please install 'xclip' command-line tool.")))
;; ;;      ((eq system-type 'windows-nt)
;; ;;       ;; For Windows
;; ;;       (if (executable-find "powershell")
;; ;;           (let ((escaped-filepath
;; ;;                  (replace-regexp-in-string
;; ;;                   "'" "''"
;; ;;                   (replace-regexp-in-string "/" "\\\\" filepath t t))))
;; ;;             (shell-command
;; ;;              (format "powershell -command \"Add-Type -AssemblyName System.Windows.Forms; \
;; ;; $img = [System.Windows.Forms.Clipboard]::GetImage(); \
;; ;; if ($img -ne $null) { $img.Save('%s'); } else { Write-Error 'No image in clipboard'; exit 1 }\""
;; ;;                      escaped-filepath)))
;; ;;         (error "PowerShell is required but not found.")))
;; ;;      (t
;; ;;       (error "Unsupported system type.")))
;; ;;     ;; Insert LaTeX code to include the image
;; ;;     (insert (format "\\begin\{center\}\n\\includegraphics[width=0.7\\textwidth]{%s}\n\\end\{center\}\n" (concat "images/" filename)))))
;; ((or (eq system-type 'gnu/linux) (eq system-type 'linux))
;;  ;; Prefer Wayland clipboard tool if available
;;  (cond
;;   ((executable-find "wl-paste")
;;    (let ((exit (call-process "wl-paste" nil (list filepath nil) nil "--type" "image/png")))
;;      (unless (and (numberp exit)
;;                   (= exit 0)
;;                   (file-exists-p filepath)
;;                   (> (nth 7 (file-attributes filepath)) 0))
;;        (error "wl-paste failed or clipboard had no PNG image"))))

;;   ;; X11 fallback
;;   ((executable-find "xclip")
;;    (let ((exit (call-process "xclip" nil (list filepath nil) nil
;;                              "-selection" "clipboard"
;;                              "-t" "image/png"
;;                              "-o")))
;;      (unless (and (numberp exit)
;;                   (= exit 0)
;;                   (file-exists-p filepath)
;;                   (> (nth 7 (file-attributes filepath)) 0))
;;        (error "xclip failed or clipboard had no PNG image"))))

;;   (t
;;    (error "Install wl-clipboard (wl-paste) or xclip"))))

;; ;; ctrl+v bind
;; (with-eval-after-load 'latex
;;   (define-key LaTeX-mode-map (kbd "C-c v") 'my-paste-image))

;; (defun my-paste-image ()
;;   "Paste an image from the clipboard into ./images/ and insert LaTeX \\includegraphics."
;;   (interactive)
;;   (unless (buffer-file-name)
;;     (error "Buffer is not visiting a file"))
;;   (let* ((image-dir (expand-file-name "images/" (file-name-directory (buffer-file-name))))
;;          (filename (concat (format-time-string "%Y%m%d%H%M%S") ".png"))
;;          (filepath (expand-file-name filename image-dir)))
;;     (unless (file-directory-p image-dir)
;;       (make-directory image-dir t))

;;     ;; Save clipboard image -> filepath
;;     (cond
;;      ;; macOS
;;      ((eq system-type 'darwin)
;;       (unless (executable-find "pngpaste")
;;         (error "Please install pngpaste"))
;;       (let ((exit (call-process "pngpaste" nil nil nil filepath)))
;;         (unless (and (numberp exit) (= exit 0)
;;                      (file-exists-p filepath)
;;                      (> (nth 7 (file-attributes filepath)) 0))
;;           (error "pngpaste failed or clipboard had no image"))))

;;      ;; Linux
;;      ((or (eq system-type 'gnu/linux) (eq system-type 'linux))
;;       (cond
;;        ;; Wayland preferred
;;        ((executable-find "wl-paste")
;;         (let ((exit (call-process "wl-paste" nil (list filepath nil) nil "--type" "image/png")))
;;           (unless (and (numberp exit) (= exit 0)
;;                        (file-exists-p filepath)
;;                        (> (nth 7 (file-attributes filepath)) 0))
;;             (error "wl-paste failed or clipboard had no PNG image"))))
;;        ;; X11 fallback
;;        ((executable-find "xclip")
;;         (let ((exit (call-process "xclip" nil (list filepath nil) nil
;;                                   "-selection" "clipboard" "-t" "image/png" "-o")))
;;           (unless (and (numberp exit) (= exit 0)
;;                        (file-exists-p filepath)
;;                        (> (nth 7 (file-attributes filepath)) 0))
;;             (error "xclip failed or clipboard had no PNG image"))))
;;        (t
;;         (error "Install wl-clipboard (wl-paste) or xclip"))))

;;      ;; Windows
;;      ((eq system-type 'windows-nt)
;;       (unless (executable-find "powershell")
;;         (error "PowerShell not found"))
;;       (let* ((escaped
;;               (replace-regexp-in-string
;;                "'" "''"
;;                (replace-regexp-in-string "/" "\\\\" filepath t t)))
;;              (cmd (format "powershell -command \"Add-Type -AssemblyName System.Windows.Forms; \
;; $img=[System.Windows.Forms.Clipboard]::GetImage(); \
;; if ($img -ne $null) { $img.Save('%s'); } else { exit 1 }\""
;;                           escaped))
;;              (exit (shell-command cmd)))
;;         (unless (and (numberp exit) (= exit 0)
;;                      (file-exists-p filepath)
;;                      (> (nth 7 (file-attributes filepath)) 0))
;;           (error "PowerShell clipboard image save failed"))))

;;      (t
;;       (error "Unsupported system type")))

;;     ;; Insert LaTeX
;;     (insert (format "\\begin{center}\n\\includegraphics[width=0.7\\textwidth]{images/%s}\n\\end{center}\n"
;;                     filename))))

;; (with-eval-after-load 'latex
;;   (define-key LaTeX-mode-map (kbd "C-c v") #'my-paste-image))


(defun my-paste-image ()
  "Paste an image from the clipboard into ./images/ and insert LaTeX \\includegraphics."
  (interactive)
  (unless (buffer-file-name)
    (error "Buffer is not visiting a file"))
  (let* ((image-dir (expand-file-name "images/" (file-name-directory (buffer-file-name))))
         (base-name (format-time-string "%Y%m%d%H%M%S"))
         (filepath (expand-file-name (concat base-name ".png") image-dir)))
    (unless (file-directory-p image-dir)
      (make-directory image-dir t))

    (cond
     ;; macOS
     ((eq system-type 'darwin)
      (unless (executable-find "pngpaste")
        (error "Please install pngpaste"))
      (let ((exit (call-process "pngpaste" nil nil nil filepath)))
        (unless (and (numberp exit) (= exit 0)
                     (file-exists-p filepath)
                     (> (nth 7 (file-attributes filepath)) 0))
          (error "pngpaste failed or clipboard had no image"))))

     ;; Linux / Wayland / X11
     ((memq system-type '(gnu/linux linux))
      (cond
       ;; Wayland
       ((executable-find "wl-paste")
        (with-temp-buffer
          (let ((exit (call-process "wl-paste" nil t nil "--type" "image/png")))
            (unless (and (numberp exit) (= exit 0) (> (buffer-size) 0))
              (error "wl-paste failed: exit=%S, output-size=%S" exit (buffer-size)))
            (write-region (point-min) (point-max) filepath nil 'silent))))
       ;; X11 fallback
       ((executable-find "xclip")
        (with-temp-buffer
          (let ((exit (call-process "xclip" nil t nil
                                    "-selection" "clipboard"
                                    "-t" "image/png"
                                    "-o")))
            (unless (and (numberp exit) (= exit 0) (> (buffer-size) 0))
              (error "xclip failed: exit=%S, output-size=%S" exit (buffer-size)))
            (write-region (point-min) (point-max) filepath nil 'silent))))
       (t
        (error "Install wl-clipboard (wl-paste) or xclip"))))

     ;; Windows
     ((eq system-type 'windows-nt)
      (unless (executable-find "powershell")
        (error "PowerShell not found"))
      (let* ((escaped
              (replace-regexp-in-string
               "'" "''"
               (replace-regexp-in-string "/" "\\\\" filepath t t)))
             (cmd (format "powershell -command \"Add-Type -AssemblyName System.Windows.Forms; \
$img=[System.Windows.Forms.Clipboard]::GetImage(); \
if ($img -ne $null) { $img.Save('%s'); exit 0 } else { exit 1 }\""
                          escaped))
             (exit (shell-command cmd)))
        (unless (and (numberp exit) (= exit 0)
                     (file-exists-p filepath)
                     (> (nth 7 (file-attributes filepath)) 0))
          (error "PowerShell clipboard image save failed"))))

     (t
      (error "Unsupported system type")))

    (insert
     (format "\\begin{center}\n\\includegraphics[width=0.7\\textwidth]{images/%s.png}\n\\end{center}\n"
             base-name))))

(with-eval-after-load 'latex
  (define-key LaTeX-mode-map (kbd "C-c v") #'my-paste-image))


; EIN -- ipynb in emacs
(require 'ein)
(add-to-list 'auto-mode-alist '("\\.ipynb\\'" . ein:notebook-mode))

;; aasdhsajdhsakjdahkjdhsajdhkjadhkjsadkja
;; aasdhsajdhsakjdahkjdhsajdhkjadhkjsadkja;; aasdhsajdhsakjdahkjdhsajdhkjadhkjsadkja;; aasdhsajdhsakjdahkjdhsajdhkjadhkjsadkja
;; aasdhsajdhsakjdahkjdhsajdhkjadhkjsadkja
;; Use Hunspell for spell-checking
(setq ispell-program-name "hunspell")

;; Enable both English and Italian dictionaries
(setq ispell-extra-args '("-d" "en_US,it_IT"))

;; Enable Flyspell by default in text modes
(add-hook 'text-mode-hook 'flyspell-mode)

;; Enable Flyspell for comments and strings in programming modes
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; (use-package pdf-tools
;;   :ensure t
;;   :config
;;   (pdf-tools-install :no-query))


;; ;; pdf insid emacs
;; ;; Ensure pdf-tools is installed and initialized
;; (use-package pdf-tools
;;   :ensure t
;;   :config
;;   (pdf-tools-install)
;;   (setq-default pdf-view-display-size 'fit-page))

;; ;; AUCTeX + PDF Tools integration
;; (use-package tex
;;   :ensure auctex
;;   :defer t
;;   :config
;;   (setq TeX-PDF-mode t) ;; compile to PDF
;;   (setq TeX-source-correlate-mode t)
;;   (setq TeX-source-correlate-start-server t)
;;   (add-hook 'LaTeX-mode-hook #'TeX-source-correlate-mode)

;;   ;; Always use pdf-tools to open PDFs
;;   (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;;         TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))
;;   ;; Enable forward/backward sync
;;   (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
;;   (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode))

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq pdf-view-midnight-colors '("#FFFFFF" . "#000000"))
  ;; white on black, unless omarchy-follow gives PDFs the Omarchy theme's colours (TEXSYNC below)
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (unless (bound-and-true-p omarchy-follow-mode)
                (pdf-view-midnight-minor-mode 1))))
  ;; no line numbers in PDFs (global-display-line-numbers-mode above): pdf-tools warns
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1))))

;; suppress auctex compile window
;;(setq TeX-show-compilation nil)

;; fixed-height compile window
(add-to-list 'display-buffer-alist
             '("\\*TeX Help\\*\\|\\*compilation\\*\\|\\*LaTeX output\\*"
               (display-buffer-reuse-window display-buffer-at-bottom)
               (window-height . 0.25)))

;; auto-scroll to bottom on recompile
(add-hook 'TeX-after-compilation-started-functions
          (lambda (_proc)
            (setq-local compilation-scroll-output t)))

;; compiled latex goes to .build
(setq-default TeX-output-dir "build")

(add-hook 'LaTeX-mode-hook
  (lambda ()
    (make-directory
     (expand-file-name "build"
                       (file-name-directory (buffer-file-name)))
     t)))

;; ===============================
;; ===============================
;; TEXSYNC: source and PDF side by side, kept in step both ways
;; https://github.com/stefanoconiglio/texsync (~/repos/texsync)
;; Only in graphical Emacs (/usr/bin/emacs): C-c C-v and C-c C-c View show
;; the PDF in pdf-tools on the right.  Terminal Emacs (emacs -nw) keeps Zathura.
;; omarchy-follow: Emacs and the PDF in the colours of the Omarchy theme,
;; following `omarchy theme set'.
;; https://github.com/stefanoconiglio/emacs-omarchy-theme (~/repos/emacs-omarchy-theme)
;; Also in the daemon (Emacs (Client)): it reads this file before it has a
;; graphical frame, so `display-graphic-p' alone would skip it.
;; ===============================
;; ===============================
(add-to-list 'load-path "~/repos/texsync")
(add-to-list 'load-path "~/repos/emacs-omarchy-theme")
(when (require 'texsync nil t)
  (add-hook 'LaTeX-mode-hook
            (lambda () (when (display-graphic-p) (texsync-mode 1)))))
(when (and (or (display-graphic-p) (daemonp)) (require 'omarchy-follow nil t))
  (omarchy-follow-mode 1))

;; The daemon (emacs.service) can start before the graphical session sets
;; WAYLAND_DISPLAY, and then wl-copy, wl-paste and every other program it
;; runs cannot reach the desktop.  Take it from the first client frame that
;; has it (Emacs (Client) frames carry the client's environment).
(defun my-adopt-wayland-display ()
  (unless (getenv "WAYLAND_DISPLAY")
    (let ((wd (getenv "WAYLAND_DISPLAY" (selected-frame))))
      (when wd (setenv "WAYLAND_DISPLAY" wd)))))
(add-hook 'server-after-make-frame-hook #'my-adopt-wayland-display)

;; copy to clipboard from emacs --nw: a terminal frame has no clipboard of
;; its own, so it goes through wl-copy / wl-paste; graphical frames use
;; Emacs's own (the defaults, gui-select-text / gui-selection-value)
(setq interprogram-cut-function
      (lambda (text &rest _)
        (if (display-graphic-p)
            (gui-select-text text)
          (let ((process-connection-type nil))
            (let ((proc (start-process "wl-copy" nil "wl-copy")))
              (process-send-string proc text)
              (process-send-eof proc))))))
(setq interprogram-paste-function
      (lambda ()
        (if (display-graphic-p)
            (gui-selection-value)
          ;; stderr dropped: a failure ("Failed to connect to a Wayland
          ;; server") must not be pasted as if it were the clipboard
          (with-temp-buffer
            (when (eql 0 (call-process "wl-paste" nil (list t nil) nil "-n"))
              (buffer-string))))))

;; mouse suport in emacs --nw
(xterm-mouse-mode 1)

;; ai-code-interface.el
(use-package ai-code
  ;; :straight (:host github :repo "tninja/ai-code-interface.el") ;; if you want to use straight to install, no need to have MELPA setting above
  :config
  ;; use codex as backend, other options are 'claude-code, 'gemini, 'github-copilot-cli, 'opencode, 'kilo, 'grok, 'cursor, 'kiro, 'codebuddy, 'aider, 'eca, 'agent-shell, 'claude-code-ide, 'claude-code-el
  (ai-code-set-backend 'codex)
  ;; Optional: default menu stays unchanged; use a narrower 2-column layout on smaller frames
  ;; (setq ai-code-menu-layout 'two-columns)
  ;; Enable global keybinding for the main menu
  (global-set-key (kbd "C-c a") #'ai-code-menu)
  ;; Optional: Use eat if you prefer, by default it is vterm
  ;; (setq ai-code-backends-infra-terminal-backend 'eat) ;; config for native CLI backends. for external backends such as agent-shell, claude-code-ide.el and claude-code.el, please check their own config
  ;; Optional: Try ghostel as an experimental backend infra
  ;; (setq ai-code-backends-infra-terminal-backend 'ghostel)
  ;; Optional: Disable @ file completion in comments and AI sessions
  ;; (ai-code-prompt-filepath-completion-mode -1)
  ;; Optional: Ask AI to run test after code changes, for a tighter build-test loop
  (setq ai-code-auto-test-type 'ask-me)
  ;; Optional: Offer numbered next steps for discussion prompts at send time
  ;; Customize `ai-code-discussion-auto-follow-up-enabled` to non-nil
  ;; or set it directly like this:
  ;; (setq ai-code-discussion-auto-follow-up-enabled t)
  ;; Optional: In AI session buffers, SPC in Evil normal state triggers the prompt-enter UI
  (with-eval-after-load 'evil (ai-code-backends-infra-evil-setup))
  ;; Optional: Turn on auto-revert buffer, so that the AI code change automatically appears in the buffer
  (global-auto-revert-mode 1)
  (setq auto-revert-interval 1) ;; set to 1 second for faster update
  ;; Optional: Set up Magit integration for AI commands in Magit popups
  (with-eval-after-load 'magit
    (ai-code-magit-setup-transients)))

;; claude-code-ide: Claude Code in a terminal, told which file is open and which
;; region is selected (https://github.com/manzaltu/claude-code-ide.el).
;; M-x claude-code-ide starts it for the current project; C-c C-' opens its
;; menu in graphical frames (a terminal cannot send C-' to emacs -nw).
(use-package vterm
  :ensure t
  :config
  ;; no line numbers in terminals (global-display-line-numbers-mode above)
  (add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1))))

;; ghostel: Claude Code's terminal, which it draws with fewer glitches than
;; vterm.  Its native module is a download (M-x ghostel-download-module),
;; offered on first use.
(use-package ghostel
  :ensure t
  :config
  (add-hook 'ghostel-mode-hook (lambda () (display-line-numbers-mode -1))))

;; Claude's window opens below the left pane when the frame has panes side by
;; side (TeX source | PDF), else beside the selected window
(defun my-claude-code-ide-display (buffer alist)
  (let* ((left (frame-first-window))
         (window (ignore-errors
                   (if (window-in-direction 'right left)
                       (split-window left nil 'below)
                     (split-window nil nil 'right)))))
    (when window
      (window--display-buffer buffer window 'window alist))))
(add-to-list 'display-buffer-alist
             '("\\`\\*claude-code\\["
               (display-buffer-reuse-window my-claude-code-ide-display)
               (dedicated . t)))

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  ;; Run the mise-installed binary, the one `claude' runs in a terminal: the
  ;; daemon started at boot has PATH /usr/local/bin:/usr/bin, without claude,
  ;; and a later PATH finds Omarchy's mise wrapper ~/.local/bin/claude first
  (let ((mise-claude
         (expand-file-name "~/.local/share/mise/installs/claude/latest/claude")))
    (setq claude-code-ide-cli-path
          (if (file-executable-p mise-claude) mise-claude "claude")))
  (setq claude-code-ide-terminal-backend 'ghostel)
  ;; a regular window, placed by my-claude-code-ide-display above
  (setq claude-code-ide-use-side-window nil)
  (claude-code-ide-emacs-tools-setup))


;; open auctex buffer always at the bo1
(add-to-list 'display-buffer-alist
             '("\\*.* output\\*"
               (display-buffer-in-side-window)
               (side . bottom)
               (slot . 0)
               (window-height . 0.1)))

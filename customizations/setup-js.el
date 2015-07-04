;; javascript / html
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-hook 'js-mode-hook 'subword-mode)
(add-hook 'js-mode-hook 'flycheck-mode)
(add-hook 'html-mode-hook 'subword-mode)
(setq js-indent-level 2)
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))


;; coffeescript
(add-to-list 'auto-mode-alist '("\\.coffee.erb$" . coffee-mode))
(add-hook 'coffee-mode-hook 'subword-mode)
(add-hook 'coffee-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'coffee-mode-hook
          (defun coffee-mode-newline-and-indent ()
            (define-key coffee-mode-map "\C-j" 'coffee-newline-and-indent)
            (setq coffee-cleanup-whitespace nil)))
(custom-set-variables
 '(coffee-tab-width 2))

;; Helpful editing stuff
(defun get-flipped-ext (extension)
  (cond ((string= extension "js")   "tmpl")
        ((string= extension "tmpl") "css")
        ((string= extension "css")  "js")
        (t                          nil)))

(defun try-file-flip (base extension tries)
  (let ((flipped-ext (get-flipped-ext extension)))
    (when (and (< tries 2) flipped-ext)
      (unless (open-if-exists (concat base "." flipped-ext))
        (try-file-flip base flipped-ext (+ tries 1))))))

(defun flip-between-viewparts ()
  ;; Open matching .js/.tmpl/.css part of the view
  (interactive)
  (let* ((file-name (buffer-file-name))
         (file-base (file-name-sans-extension file-name))
         (extension (file-name-extension file-name)))
    (try-file-flip file-base extension 0)))

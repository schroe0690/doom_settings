;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



;; ----追記した設定----
;; ファイラーの幅を指定
(setq treemacs-width 27) ;; 例: Treemacs の幅を30文字分に設定

;; テーマの設定
(put 'customize-themes 'disabled nil)
(setq doom-theme 'rebecca)

;; 終了時の確認をスキップ
(setq confirm-kill-emacs nil)


;; common-lispnの補完
(setq inferior-lisp-program "ros run")

;; パッケージを含めたコード保管の設定
(after! sly
  (setq sly-contribs '(sly-fancy sly-asdf sly-quicklisp))
  (setq sly-auto-configure-asdf t)
  (setq sly-eval-in-emacs t)

  (defun my-sly-setup-for-project ()
    "Configure Sly for the current project: load quicklisp-slime-helper and add local project path."
    ;; Quicklispのヘルパーをロード
    (sly-eval "(cl:when (cl:find-package :quicklisp) (ql:quickload :quicklisp-slime-helper))")
    ;; カレントプロジェクトのパスをASDFに登録
    (let ((project-root (replace-regexp-in-string "/$" "" default-directory)))
      (sly-eval `(pushnew (cl:pathname ,project-root) asdf:*central-registry* :test #'cl:equal))))

  ;; 既存のフックがあれば一旦クリアしてから追加する方が安全な場合もあるが、今回はそのまま追加
  (add-hook 'sly-connected-hook #'my-sly-setup-for-project 'append))


;; ----キーバインド----
;; ファイラーの幅調整
(with-eval-after-load 'treemacs
  ;; Treemacs のキーマップを設定
  (define-key treemacs-mode-map (kbd "C-l") 'treemacs-increase-width)
  (define-key treemacs-mode-map (kbd "C-h") 'treemacs-decrease-width)

  ;; もしTreemacsをグローバルに操作したい場合（Treemacsバッファがアクティブでなくても）
  ;; (map! :leader
  ;;       :desc "Treemacs increase width" "T I" #'treemacs-increase-width
  ;;       :desc "Treemacs decrease width" "T D" #'treemacs-decrease-width)
  )

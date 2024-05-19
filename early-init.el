;; WARNING!
;;
;; This file is a result of `org-babel-tangle` execution on `.emacs.d/README.org`.
;; Don't change it manually.

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

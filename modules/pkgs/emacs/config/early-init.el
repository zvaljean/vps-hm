(setq package-enable-at-startup nil)
;; (setq debug-on-error t)
;; https://www.reddit.com/r/emacs/comments/1hayavx/comment/mganfyy
;; https://jeffkreeftmeijer.com/emacs-native-comp-log/
(setq native-comp-jit-compilation-deny-list '(".*org-element.*" ".*ox-hugo.*")) 
(setq native-comp-async-report-warnings-errors nil)
(provide 'early-init)

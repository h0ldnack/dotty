(setq gc-cons-threshold 100000000)
(setq package-enable-at-startup nil)
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))


;; Hides UI shit
(scroll-bar-mode -1)
(menu-bar-mode 0)
(toggle-scroll-bar 0)
(tool-bar-mode 0)
(setq package-native-compile t)

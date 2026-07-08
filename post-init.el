;;; post-int.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ensure adding the following compile-angel code at the very beginning
;; of your `~/.emacs.d/post-init.el` file, before all other packages.
;; Нативная компиляция повышает производительность Emacs, преобразуя код Elisp в
;; машинный код, что приводит к более быстрому выполнению и улучшенной
;; отзывчивости.
;;
;; Убедитесь, что вы добавили следующий код compile-angel в самое начало
;; вашего файла `~/.emacs.d/post-init.el`, перед всеми остальными пакетами.

(use-package compile-angel
  :demand t
  :ensure t
  :custom
  ;; Установите `compile-angel-verbose' в nil, чтобы отключить сообщения compile-angel.
  ;; (Когда установлено в nil, compile-angel не будет показывать, какой файл компилируется.)
  (compile-angel-verbose t)

  :config
  ;; Следующая директива предотвращает компиляцию ваших файлов инициализации
  ;; compile-angel. Если вы решите удалить этот push из `compile-angel-excluded-files'
  ;; и скомпилировать ваши файлы pre/post-init, убедитесь, что вы понимаете
  ;; последствия и тщательно тестируете свой код. Например, если вы используете
  ;; макрос `use-package', вам нужно будет явно добавить:
  ;; (eval-when-compile (require 'use-package))
  ;; в начало вашего файла инициализации.

  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode-compile-once' was activated.
  (compile-angel-on-load-mode 1))
;;
;; Allow Emacs to upgrade built-in packages, such as Org mode
(setq package-install-upgrade-built-in t)


;;; Включение автоматической вставки и управления парными символами
;;; (например, (), {}, "") глобально с помощью `electric-pair-mode'.
(use-package elec-pair
  :ensure nil
  :config
  (electric-pair-mode 1))

;; Установка полей в соответствии с высотой пикселя символа. Это гарантирует,
;; что поле достаточно широкое, масштабируясь динамически с текущим размером шрифта.
(fringe-mode (frame-char-width))

;; Когда режим Delete Selection включён, вводимый текст заменяет выделение,
;; если выделение активно.
(delete-selection-mode 1)

;; Отображение текущих номеров строки и столбца в модельной строке
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Отображение номеров строк в буфере:
(setq-default display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Установка максимального уровня подсветки синтаксиса для режимов Tree-sitter
(setq treesit-font-lock-level 4)

(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
;; versions, except for emacs-mac.
;;
;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
;; this version of Emacs natively supports smooth scrolling.
;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
(setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
(pixel-scroll-precision-mode 1))

;;Отображение времени в модельной строке
(display-time-mode 1)

;; Подсветка парных скобок
(show-paren-mode 1)

;; Отслеживание изменений в конфигурации окон, позволяя отменять такие действия,
;; как закрытие окон.
(setq winner-boring-buffers '("*Completions*"
                                "*Minibuf-0*"
                                "*Minibuf-1*"
                                "*Minibuf-2*"
                                "*Minibuf-3*"
                                "*Minibuf-4*"
                                "*Compile-Log*"
                                "*inferior-lisp*"
                                "*Fuzzy Completions*"
                                "*Apropos*"
                                "*Help*"
                                "*cvs*"
                                "*Buffer List*"
                                "*Ibuffer*"
                                "*esh command on file*"))
(winner-mode 1)

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'reverse)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t))

;; Разделители окон визуально отделяют окна. Разделители окон — это полосы,
;; которые можно перетаскивать мышью, что позволяет легко изменять размер
;; соседних окон.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(window-divider-mode 1)

;; Ограничить вертикальное движение курсора строками в пределах буфера
(setq dired-movement-style 'bounded-files)

;; Dired buffers: Automatically hide file details (permissions, size,
;; modification date, etc.) and all the files in the `dired-omit-files' regular
;; expression for a cleaner display.
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                               "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.DS_Store\\'"
                               "\\|^\\.\\(?:svn\\|git\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)

;; Когда tooltip-mode включён, определённые элементы интерфейса (например, текст
;; справки, подсказки при наведении мыши) будут отображаться как собственные
;; системные подсказки (всплывающие окна), а не как сообщения в области эхо.
;; Это полезно в графических сессиях Emacs, где подсказки могут появляться
;; рядом с курсором.
(setq tooltip-hide-delay 20)    ; Время в секундах до исчезновения подсказки (по умолчанию: 10)
(setq tooltip-delay 0.4)        ; Задержка перед показом подсказки после наведения мыши (по умолчанию: 0.7)
(setq tooltip-short-delay 0.08) ; Задержка перед показом короткой подсказки (по умолчанию: 0.1)
(tooltip-mode 1)

;; Сохранять неизменённые буферы A/B/C в конце сессии
(setq ediff-keep-variants t)

;; Автоматически применять проверенные, безопасные файлово-локальные переменные.
;; Это устраняет запросы подтверждения при загрузке файлов, гарантируя, что
;; несанкционированные или рискованные конфигурации молча игнорируются.
(setq enable-local-variables :safe)

;; Сервер Emacs позволяет внешним программам, таким как `emacsclient', подключаться
;; к одному запущенному экземпляру Emacs. Это позволяет открывать файлы в
;; существующей сессии вместо запуска нового процесса Emacs каждый раз.
;;
;; После запуска сервера команда `emacsclient' может использоваться в
;; терминале для открытия файлов в активной сессии Emacs. Например, выполнение
;; следующей команды открывает файл в существующем фрейме Emacs без блокировки
;; процесса терминала.
;;   emacsclient -n filename.txt
;;
(use-package server
  :ensure nil
  :if (not (daemonp))
  :preface
  (defun my-server-start ()
    "Запустить сервер Emacs, если в данный момент нет активного процесса сервера."
    (unless (server-running-p)
      (server-start)))
  :config
  (my-server-start))
;;
;(use-package tomorrow-night-deepblue-theme
;  :ensure t
;  :config
  ;; Disable all themes and load the Tomorrow Night Deep Blue theme
;; (mapc #'disable-theme custom-enabled-themes)
;; (load-theme 'tomorrow-night-deepblue t ))
;;
;; Auto-revert в Emacs — это функция, которая автоматически обновляет
;; содержимое буфера для отражения изменений, внесённых в файл на диске.
(use-package autorevert
  :ensure nil
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil)
  :config
  (global-auto-revert-mode 1))

;; Recentf — это пакет Emacs, который поддерживает список недавно
;; открытых файлов, упрощая повторное открытие файлов, над которыми вы работали
;; недавно.
(use-package recentf
  :ensure nil
  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; Глубина очистки -90 гарантирует, что `recentf-cleanup' выполняется перед
  ;; `recentf-save-list', позволяя удалить устаревшие записи перед сохранением
  ;; списка `recentf-save-list', который автоматически добавляется в
  ;; `kill-emacs-hook' через `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90)
  ;; Включение `recentf-mode'
  (recentf-mode 1))

;; savehist — это функция Emacs, которая сохраняет историю минибуфера между
;; сессиями. Она сохраняет историю ввода в минибуфере, такую как команды,
;; строки поиска и другие подсказки, в файл. Это позволяет пользователям
;; сохранять историю минибуфера при перезапусках Emacs.
(use-package savehist
  :ensure nil
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600)
  :config
  (savehist-mode 1))

;; save-place-mode позволяет Emacs запоминать последнюю позицию в файле
;; при повторном открытии. Эта функция особенно полезна для возобновления работы
;; с того места, где вы остановились.
(use-package saveplace
  :ensure nil
  :init
  (setq save-place-limit 400)
  :config
  (save-place-mode 1))
;;
;; Включение `auto-save-mode' для предотвращения потери данных. Используйте `recover-file' или
;; `recover-session' для восстановления несохранённых изменений.
(setq auto-save-default t)
;; Запуск автосохранения после 300 нажатий клавиш
(setq auto-save-interval 300)
;; Запуск автосохранения через 30 секунд бездействия.
(setq auto-save-timeout 30)
;;
;; Когда auto-save-visited-mode включён, Emacs будет автоматически сохранять буферы,
;; связанные с файлами, через некоторое время бездействия, если пользователь забыл
;; сохранить их с помощью save-buffer или C-x s, например.
;;
;; Это отличается от auto-save-mode: auto-save-mode периодически сохраняет
;; все изменённые буферы, создавая резервные копии, включая те, которые не связаны
;; с файлом, в то время как auto-save-visited-mode сохраняет только буферы,
;; связанные с файлами, после периода бездействия, непосредственно сохраняя их
;; в сам файл без создания резервных копий.
(setq auto-save-visited-interval 5)   ; Сохранение через 5 секунд бездействия
(auto-save-visited-mode 1)
;;
(use-package buffer-guardian
  :custom
  ;; Когда non-nil, включать удалённые файлы в процесс автосохранения
  (buffer-guardian-inhibit-saving-remote-files t)

  ;; Когда non-nil, буферы, посещающие несуществующие файлы, не сохраняются
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Сохранять буфер, даже если изменение окна приводит к тому же буферу
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil для включения подробного режима для регистрации, когда буфер
  ;; автоматически сохраняется
  (buffer-guardian-verbose nil)

  ;; Сохранять все буферы через N секунд бездействия пользователя. (Отключено по умолчанию)
  ;; (buffer-guardian-save-all-buffers-idle 30)

  ;; Сохранять все буферы каждые N секунд. (Отключено по умолчанию)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :config
  (buffer-guardian-mode 1))

;; Пакет easysession Emacs является менеджером сессий для Emacs, который может сохранять
;; и восстанавливать буферы редактирования файлов, косвенные буферы/клоны, буферы Dired,
;; окна/разделения, встроенную панель вкладок (включая вкладки, их буферы и
;; окна) и фреймы Emacs. Он предлагает удобный и простой способ управления
;; сессиями редактирования Emacs и использует встроенные функции Emacs для
;; сохранения и восстановления фреймов.
(use-package easysession
  ;; ':demand t' гарантирует, что пакет загружается немедленно при запуске
  :demand t

  :config
  ;; Привязки клавиш
  (global-set-key (kbd "C-c sl") #'easysession-switch-to) ; Загрузка сессии
  (global-set-key (kbd "C-c ss") #'easysession-save) ; Сохранение сессии
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c su") #'easysession-unload)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  ;; Сохранение каждые 10 минут
  (setq easysession-save-interval (* 10 60))

  ;; Сохранение текущей сессии при использовании `easysession-switch-to'
  (setq easysession-switch-to-save-session t)

  ;; Не исключать текущую сессию при переключении сессий
  (setq easysession-switch-to-exclude-current nil)

  ;; Отображать имя активной сессии в индикаторе модельной строки.
  ;; (setq easysession-save-mode-lighter-show-session-name t)

  ;; Опционально, имя сессии может отображаться в информационной области модельной строки:
  ;; (setq easysession-mode-line-misc-info t)
  ;; non-nil: Заставить `easysession-setup' автоматически загружать сессию.
  ;; (nil: сессия не загружается автоматически; пользователь может загрузить её вручную.)
  (setq easysession-setup-load-session t)

  ;; Функция `easysession-setup' добавляет хуки:
  ;; - Для включения автоматической загрузки сессии во время `emacs-startup-hook' или
  ;;   `server-after-make-frame-hook' при работе в режиме демона.
  ;; - Для сохранения сессии через регулярные интервалы и при выходе из Emacs.
  (easysession-setup))
;;
;; Vertico предоставляет вертикальный интерфейс дополнения, упрощая
;; навигацию и выбор кандидатов дополнения (например, при нажатии `M-x').
(use-package vertico
  ;; :custom
  ;; (vertico-scroll-margin 0) ;; Другой отступ прокрутки
  ;; (vertico-count 20) ;; Показывать больше кандидатов
  ;; (vertico-resize t) ;; Увеличивать и уменьшать минибуфер Vertico
  ;; (vertico-cycle t) ;; Включить циклический перебор для `vertico-next/previous'
  :init
  (vertico-mode 1))

;; Vertico использует гибкие возможности сопоставления Orderless, позволяя
;; пользователям вводить несколько шаблонов, разделённых пробелами, которые
;; Orderless затем сопоставляет в любом порядке с кандидатами.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  ;; Emacs 31: partial-completion ведёт себя как substring
  (completion-pcm-leading-wildcard t))

;; Marginalia позволяет Embark предлагать вам предварительно настроенные
;; действия в большем количестве контекстов. Кроме того, Marginalia также
;; улучшает Vertico, добавляя богатые аннотации к кандидатам дополнения,
;; отображаемым в интерфейсе Vertico.
(use-package marginalia
  ;; Привязка `marginalia-cycle' локально в минибуфере. Чтобы сделать привязку
  ;; доступной в буфере *Completions*, добавьте её в
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; Секция :init выполняется всегда.
  :init

  ;; Marginalia должна быть активирована в секции :init use-package, чтобы
  ;; режим включался сразу. Обратите внимание, что это принудительно загружает
  ;; пакет.
  (marginalia-mode 1))

;; Embark интегрируется с Consult и Vertico, предоставляя контекстно-зависимые
;; действия и быстрый доступ к командам на основе текущего выбора, что ещё больше
;; повышает эффективность пользователя и рабочий процесс в Emacs. Вместе они
;; создают единую среду для управления дополнениями и взаимодействиями.
(use-package embark
  :bind
  (("C-." . embark-act)         ;; выберите удобную привязку
   ("C-;" . embark-dwim)        ;; хорошая альтернатива: M-.
   ("C-h B" . embark-bindings)) ;; альтернатива для `describe-bindings'

  :init

  ;; Опционально заменить справку по клавишам на интерфейс completing-read
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Показывать цель Embark в точке через Eldoc. Вы можете настроить
  ;; стратегию Eldoc, если хотите видеть документацию от
  ;; нескольких провайдеров. Имейте в виду, что использование этого может быть
  ;; немного непривычным, так как сообщение в минибуфере может занимать
  ;; более одной строки, заставляя модельную строку двигаться вверх и вниз:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Добавить Embark в контекстное меню мыши. Также включите `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Скрыть модельную строку буферов Embark live/completions
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

;; Consult предлагает набор команд для эффективного поиска, предпросмотра и
;; взаимодействия с буферами, содержимым файлов и другим, улучшая различные задачи.

(use-package consult
  ;; Замена привязок. Лениво загружается через `use-package'.
  :bind (;; Привязки C-c в `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; Привязки C-x в `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; оригинал repeat-complex-command
         ("C-x b" . consult-buffer)                ;; оригинал switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; оригинал switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; оригинал switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; оригинал switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; оригинал bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; оригинал project-switch-to-buffer
         ;; Пользовательские привязки M-# для быстрого доступа к регистрам
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; оригинал abbrev-prefix-mark (не связан)
         ("C-M-#" . consult-register)
         ;; Другие пользовательские привязки
         ("M-y" . consult-yank-pop)                ;; оригинал yank-pop
         ;; Привязки M-g в `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Альтернатива: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; оригинал goto-line
         ("M-g M-g" . consult-goto-line)           ;; оригинал goto-line
         ("M-g o" . consult-outline)               ;; Альтернатива: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; Привязки M-s в `search-map'
         ("M-s d" . consult-find)                  ;; Альтернатива: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Интеграция с Isearch
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; оригинал isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; оригинал isearch-edit-string
         ("M-s l" . consult-line)                  ;; необходимо для consult-line для обнаружения isearch
         ("M-s L" . consult-line-multi)            ;; необходимо для consult-line для обнаружения isearch
         ;; История минибуфера
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; оригинал next-matching-history-element
         ("M-r" . consult-history))                ;; оригинал previous-matching-history-element

  ;; Конфигурация :init выполняется всегда (не лениво)
  :init

  ;; Настройка предпросмотра регистров для `consult-register-load',
  ;; `consult-register-store' и встроенных команд. Это улучшает
  ;; форматирование регистров, добавляет тонкие разделительные линии, сортировку
  ;; регистров и скрывает модельную строку окна.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Использовать Consult для выбора мест xref с предпросмотром
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Настройка других переменных и режимов в секции :config,
  ;; после ленивой загрузки пакета.
  :config

  ;; Опционально настройте предпросмотр. Значение по умолчанию
  ;; 'any, так что любая клавиша запускает предпросмотр.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; Для некоторых команд и источников буферов полезно настроить
  ;; :preview-key для каждой команды с помощью макроса `consult-customize'.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Опционально настройте клавишу сужения.
  ;; < и C-+ работают достаточно хорошо.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Опционально сделайте справку по сужению доступной в минибуфере.
  ;; Вы можете использовать `embark-prefix-help-command' или which-key вместо этого.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)
;;
;; Пакет undo-fu является лёгкой обёрткой вокруг встроенной системы отмены
;; Emacs, предоставляя более удобную функциональность undo/redo.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :init
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; Пакет undo-fu-session дополняет undo-fu, позволяя сохранять
;; и восстанавливать историю отмены между сессиями Emacs, даже после перезапуска.
(use-package undo-fu-session
  :config
  (undo-fu-session-global-mode 1))
;;
(let ((inhibit-redisplay t))
  ;; Отключение всех активных тем
  (mapc #'disable-theme custom-enabled-themes)
  ;; Загрузка встроенной темы
  (load-theme 'modus-operandi-tinted t))
;;
;; Пакет markdown-mode предоставляет основной режим для Emacs для подсветки
;; синтаксиса, команд редактирования и поддержки предпросмотра для документов Markdown.
;; Он поддерживает основной синтаксис Markdown, а также расширения, такие как GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))
;;
;; Автоматическая генерация оглавления при редактировании файлов Markdown
(use-package markdown-toc
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Оглавление**"))
;;
;; Пакет stripspace Emacs предоставляет stripspace-local-mode — второстепенный
;; режим, который автоматически удаляет пробелы в конце строк и пустые строки
;; в конце буфера при сохранении.
(use-package stripspace
  :commands stripspace-local-mode

  ;; Включение для prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))

  :custom
  ;; Опция `stripspace-only-if-initially-clean':
  ;; - nil для всегда удаления пробелов в конце строк.
  ;; - Non-nil для удаления пробелов только когда буфер изначально чист.
  ;; (Проверка начальной чистоты выполняется при включении
  ;; `stripspace-local-mode'.)
  (stripspace-only-if-initially-clean nil)

  ;; Включение `stripspace-restore-column' сохраняет позицию столбца курсора
  ;; даже после удаления пробелов. Это полезно в сценариях, когда вы добавляете
  ;; дополнительные пробелы и затем сохраняете файл. Хотя пробелы удаляются
  ;; в сохранённом файле, курсор остаётся в той же позиции, обеспечивая
  ;; согласованный опыт редактирования без влияния на размещение курсора.
  (stripspace-restore-column t))
;;
;;Подсветка несохранённых изменений на полях буфера (for example Git)
(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Быстрее
  (setq diff-hl-show-staged-changes nil)  ; Обратная связь в реальном времени
  (setq diff-hl-update-async t)  ; Не блокировать Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))
;;
(use-package buffer-terminator
  :custom
  ;; Включение/Отключение подробного режима для регистрации событий очистки буферов
  (buffer-terminator-verbose nil)

  ;; Установка таймаута бездействия (в секундах), после которого буферы считаются
  ;; неактивными (по умолчанию 30 минут):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 минут

  ;; Определение частоты выполнения процесса очистки (по умолчанию каждые 10
  ;; минут):
  (buffer-terminator-interval (* 10 60)) ; 10 минут

  :config
  (buffer-terminator-mode 1))
;;
;; Read ePub files
  (use-package nov
    :init
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))
;;
;; Быстрый переход в видимом тексте с минимальным нажатием клавиш (по 2 символам)
(use-package avy
  :commands (avy-goto-char
             avy-goto-char-2
             avy-next)
  :init
  (global-set-key (kbd "C-'") 'avy-goto-char-2))
;;
;; `vterm' — это эмулятор терминала для Emacs, который обеспечивает полностью
;; интерактивный опыт работы с оболочкой в Emacs, поддерживая такие функции,
;; как цвет, движение курсора и расширенные возможности терминала. В отличие
;; от стандартных терминальных режимов Emacs, `vterm' использует библиотеку
;; libvterm на C для высокопроизводительной эмуляции. Это обеспечивает
;; точное поведение терминала при запуске программ оболочки, текстовых
;; приложений и REPL.
(use-package vterm
  :if (bound-and-true-p module-file-suffix)
  :commands (vterm
             vterm-send-string
             vterm-send-return
             vterm-send-key
             vterm-module-compile)

  :preface
  (when noninteractive
    ;; vterm ненужно запускает компиляцию vterm-module.so при загрузке.
    ;; Это предотвращает это во время байт-компиляции (`use-package' принудительно
    ;; загружает пакеты при компиляции).
    (advice-add #'vterm-module-compile :override #'ignore))

  (defun my-vterm--setup ()
    ;; Скрыть модельную строку
    (setq mode-line-format nil)

    ;; Предотвратить раннюю горизонтальную прокрутку
    (setq-local hscroll-margin 0)

    ;; Подавить запросы на завершение активных процессов при закрытии vterm
    (setq-local confirm-kill-processes nil))

  :init
  (add-hook 'vterm-mode-hook #'my-vterm--setup)

  (setq vterm-timer-delay 0.05)  ; Более быстрый vterm
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-max-scrollback 5000))
;;
;;
;; Org mode is a major mode designed for organizing notes, planning, task
;; management, and authoring documents using plain text with a simple and
;; expressive markup syntax. It supports hierarchical outlines, TODO lists,
;; scheduling, deadlines, time tracking, and exporting to multiple formats
;; including HTML, LaTeX, PDF, and Markdown.
(use-package org
  :ensure t
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :custom
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

  (org-startup-truncated t))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function: (my-org-insert-heading-respect-content-and-prepend-todo)
;; Author: James Cherti
;; License: MIT
;; Key binding: Ctrl-Enter
;; URL: https://www.jamescherti.com/emacs-add-todo-keyword-to-new-org-mode-headings/
;;
;; Description: The function inserts a new heading at the current cursor
;; position, and prepends it with "TODO " if activated while on a "TODO" task,
;; thus creating a new to-do item. In addition to that, for those utilizing
;; evil-mode the function transitions the user into insert mode right after the
;; "TODO " insertion.

(defun my-org-insert-heading-respect-content-and-prepend-todo ()
    "Insert a new org-mode heading respecting content and prepend it with 'TODO'.
  Additionally, ensure entry into insert state when evil-mode is active."
    (interactive)
    (let ((entry-is-todo (org-entry-is-todo-p)))
      (when (bound-and-true-p evil-mode)
        (evil-insert-state))
      (org-insert-heading-respect-content)
      (when entry-is-todo
        (just-one-space)
        (insert "TODO")
        (just-one-space))))

;; Replace the key bindings for inserting headings in Org mode
(define-key org-mode-map (kbd "C-<return>")
            'my-org-insert-heading-respect-content-and-prepend-todo)
;; Emacs Writing Studio Customisation
(defgroup ews ()
    "Emacs Writing Studio."
    :group 'files )

  (defcustom ews-documents-directory
    (concat (file-name-as-directory (getenv "HOME")) "Documents")
    "Location of documents."
    :group 'ews
    :type 'directory)

  (defcustom ews-bibliography-directory
    (concat (file-name-as-directory ews-documents-directory) "library")
    "Location of BibTeX bibliographies and attachments."
    :group 'ews
    :type 'directory)

  (defcustom ews-notes-directory
    (concat (file-name-as-directory ews-documents-directory) "notes")
    "Location of notes."
    :group 'ews
    :type 'directory)

  (defcustom ews-inbox-file
    (concat (file-name-as-directory ews-documents-directory) "inbox.org")
    "Location of notes."
    :group 'ews
    :type 'file)
;;
;; Fleeting notes
  (use-package org
    :after
    denote
    :bind
    (("C-c c" . org-capture)
     ("C-c l" . org-store-link)
     ("C-c a" . org-agenda))
    :custom
    (org-default-notes-file ews-inbox-file)
    (org-capture-bookmark nil)
    ;; Capture templates
    (org-capture-templates
     '(("f" "Fleeting note" item
        (file+headline org-default-notes-file "Заметки")
        "- %?")
       ("p" "Permanent note" plain
        (file denote-last-path)
        #'denote-org-capture
        :no-save t
        :immediate-finish nil
        :kill-buffer t
        :jump-to-captured t)
       ("t" "New task" entry
        (file+headline org-default-notes-file "Задачи")
        "* TODO %i%?"))))
;; Denote
;; Помните, что версия этого руководства на сайте показывает последние
;; разработки, которые могут быть недоступны в используемом вами пакете.
;; Вместо копирования с веб-сайта обратитесь к версии документации,
;; поставляемой с вашим пакетом. Выполните:
;;
;;     (info "(denote) Sample configuration")
(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name ews-notes-directory))
  :custom-face
  (denote-faces-link ((t (:slant italic)))))

;; Автоматически переименовывать буферы Denote при их открытии, чтобы
;; вместо длинного имени файла они имели, например, литеральный
;; "[D]", за которым следует заголовок файла. Прочитайте строку документации
;; `denote-rename-buffer-format', чтобы узнать, как это изменить.
(denote-rename-buffer-mode 1)

;; Denote extensions
(use-package consult-notes
  :commands (consult-notes
             consult-notes-search-in-all-notes)
  :custom
  (consult-notes-file-dir-sources
   `(("Denote" ?d ,ews-notes-directory))))
;;
;; Украшение орг моды (знаки, символы)
;;
 (use-package org-modern
        :hook
        (org-mode . global-org-modern-mode)
        :custom
        (org-modern-keyword nil)
        (org-modern-checkbox nil)
        (org-modern-table nil)
        (org-modern-star 'fold))

    ;; Choose some fonts
    (set-face-attribute 'default nil :height 140)
    (set-face-attribute 'default nil :family "Iosevka Term")
    (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
    ;;(set-face-attribute 'org-modern-symbol nil :family "Iosevka Term")
;;
(use-package persist-text-scale
  :custom
  (text-scale-mode-step 1.07)

  :config
  (persist-text-scale-mode 1))
;;
;; Add frame borders and window dividers
(modify-all-frames-parameters
 '((right-divider-width . 40)
   (internal-border-width . 40)))
    (dolist (face '(window-divider
                    window-divider-first-pixel
                    window-divider-last-pixel))
      (face-spec-reset-face face)
      (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "◀── now ─────────────────────────────────────────────────")

;; Ellipsis styling
(setq org-ellipsis "…")
(set-face-attribute 'org-ellipsis nil :inherit 'default :box nil)

(global-org-modern-mode)
;;
;; Auto completion
;;
;; Corfu enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu
  :ensure t
  :commands (corfu-mode global-corfu-mode)

  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)

  ;; Enable Corfu
  :config
  (global-corfu-mode))

;; Cape, or Completion At Point Extensions, extends the capabilities of
;; in-buffer completion. It integrates with Corfu or the default completion UI,
;; by providing additional backends through completion-at-point-functions.
(use-package cape
  :ensure t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))
;;
;; Automatically generate a table of contents when editing Markdown files
(use-package markdown-toc
  :ensure t
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Table of Contents**"))
;;
;;
;; Поддержка Julia и прочих языков
;;
;; Tree-sitter in Emacs is an incremental parsing system introduced in Emacs 29
;; that provides precise, high-performance syntax highlighting. It supports a
;; broad set of programming languages, including Bash, C, C++, C#, CMake, CSS,
;; Dockerfile, Go, Java, JavaScript, JSON, Python, Rust, TOML, TypeScript, YAML,
;; Elisp, Lua, Markdown, and many others.
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((julia . t)
 (shell . t)))
;;
;;Привязки клавиш
;;
(global-set-key [(control tab)] 'previous-buffer)
(global-set-key [(control shift tab)] 'next-buffer)
(global-set-key (kbd "<f3>") 'find-file) ; Open file or dir
(global-set-key (kbd "<f4>") 'ibuffer) ; list buffers - список буферов
(global-set-key (kbd "<f8>") 'menu-bar-mode) ; вызов графического меню
(global-set-key (kbd "<f2>") 'kill-current-buffer) ; Close file
;;
(defun unfill-paragraph ()
      "Takes a multi-line paragraph and makes it into a single line of text."
      (interactive)
      (let ((fill-column (point-max)))
        (fill-paragraph nil)))
;
(defun unfill-region (beg end)
      "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
      (interactive "*r")
      (let ((fill-column (point-max)))
        (fill-region beg end)))
;
(global-set-key (kbd "C-c f a") 'auto-fill-mode)
(global-set-key (kbd "C-c f p") 'fill-paragraph)
(global-set-key (kbd "C-c f r") 'refill-mode)
(global-set-key (kbd "C-c f u") 'unfill-paragraph)

;;Vi mode
;; Раскомментируйте следующее, если вы используете undo-fu
(setq evil-undo-system 'undo-fu)

;; Эмуляция Vim
(use-package evil
  :init
  ;; Должно быть определено до evil
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)

  :custom
  ;; Сделать :s в визуальном режиме работающим только для фактического
  ;; визуального выделения (символ или блок), вместо полных строк, покрытых выделением
  (evil-ex-visual-char-range t)
  ;; Использовать регулярные выражения в стиле Vim в командах поиска и замены,
  ;; позволяя такие возможности, как \v (very magic), \zs и \ze для точных совпадений
  (evil-ex-search-vim-style-regexp t)
  ;; Включить автоматическое горизонтальное разделение снизу
  (evil-split-window-below t)
  ;; Включить автоматическое вертикальное разделение справа
  (evil-vsplit-window-right t)
  ;; Отключить вывод состояния Evil, чтобы не заменять eldoc
  (evil-echo-state nil)
  ;; Не перемещать курсор назад при выходе из режима вставки
  (evil-move-cursor-back nil)
  ;; Сделать `v$` исключающим последний перевод строки
  (evil-v$-excludes-newline t)
  ;; Разрешить C-h удалять в режиме вставки
  (evil-want-C-h-delete t)
  ;; Включить C-u для удаления до отступа в режиме вставки
  (evil-want-C-u-delete t)
  ;; Включить детальное поведение отмены
  (evil-want-fine-undo t)
  ;; Отключить обёртывание поиска вокруг буфера
  (evil-search-wrap nil)
  ;; Будет ли Y копировать до конца строки
  (evil-want-Y-yank-to-eol t)

  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :init
  ;; Должно быть определено до evil-collection
  (setq evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

;; Пакет goto-chg полезен с Evil для перехода непосредственно к самому последнему
;; месту редактирования. Это отражает навигацию по изменениям Vim, позволяя быстро
;; возвращаться к тому месту, где текст был изменён, без использования списка переходов
;; или поиска.
;;
;; Команды goto-chg привязаны к g; и g,
(use-package goto-chg
  :commands (goto-last-change
             goto-last-change-reverse))

;; Придать панели вкладок Emacs стиль, похожий на Vim
(use-package vim-tab-bar
  :config
  (vim-tab-bar-mode 1))
;;
;; Пакет evil-surround упрощает работу с окружающими символами, такими как
;; скобки, кавычки и т.д. Он предоставляет привязки клавиш для лёгкого добавления,
;; изменения или удаления этих окружающих символов парами. Например, вы
;; можете окружить выделенный текст двойными кавычками в визуальном состоянии
;; с помощью S" или gS".
(use-package evil-surround
  :after evil
  :custom
  (evil-surround-pairs-alist
   '((?\( . ("(" . ")"))
     (?\[ . ("[" . "]"))
     (?\{ . ("{" . "}"))

     (?\) . ("(" . ")"))
     (?\] . ("[" . "]"))
     (?\} . ("{" . "}"))

     (?< . ("<" . ">"))
     (?> . ("<" . ">"))))
  :config
  (global-evil-surround-mode 1))
;;
;;Evil-org mode для работы с фолдингом в Vim режиме
;; https://github.com/Somelauw/evil-org-mode
;;(use-package evil-org
;;  :ensure t
;;  :after org
;;  :hook (org-mode . (lambda () evil-org-mode))
;; :config
;;  (require 'evil-org-agenda)
;;  (evil-org-agenda-set-keys))
;;
;;
;;(require 'evil-org-agenda)
;;(evil-org-agenda-set-keys)
;;
;; Локализация календаря
(setq calendar-week-start-day 1
          calendar-day-name-array ["Воскресенье" "Понедельник" "Вторник" "Среда"
                                   "Четверг" "Пятница" "Суббота"]
          calendar-day-header-array ["Вс" "Пн" "Вт" "Ср" "Чт" "Пт" "Сб"]
          calendar-day-abbrev-array ["Вск" "Пнд" "Втр" "Срд" "Чтв" "Птн" "Суб"]
          calendar-month-name-array ["Январь" "Февраль" "Март" "Апрель" "Май"
                                     "Июнь" "Июль" "Август" "Сентябрь"
                                     "Октябрь" "Ноябрь" "Декабрь"]
          calendar-month-abbrev-array ["Янв" "Фев" "Мар" "Апр" "Май" "Июн" "Июл" "Авг" "Сен" "Окт" "Ноя" "Дек"])
;;
;;
;;emacs --init-directory ~/.config/emacs/
;;

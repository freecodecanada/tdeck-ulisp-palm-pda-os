(defun cls () (write-byte 12))

(defvar *os-name* "Palm Pda OS")
(defvar *os-version* "1.5")
(defvar *boot-count* 0)

(defun pause ()
  (delay 10000))

(defvar *bat-adc-pin* 4)
(defvar *bat-adc-mult* 2.0)
(defvar *bat-v-min* 3.30)
(defvar *bat-v-max* 4.20)

(defun clamp (x lo hi)
  (cond ((< x lo) lo)
        ((> x hi) hi)
        (t x)))

(defun bat-raw ()
  (analogread *bat-adc-pin*))

(defun bat-volts ()
  (* *bat-adc-mult*
     (* 3.3 (/ (bat-raw) 4095.0))))

(defun bat-percent ()
  (let* ((v (bat-volts))
         (p (* 100.0
               (/ (- v *bat-v-min*)
                  (- *bat-v-max* *bat-v-min*)))))
    (round (clamp p 0 100))))

(defvar *status-on* nil)

(defun status-bar ()
  (if *status-on*
      (format t "BAT: ~a%%~%" (bat-percent))
      nil))

(defun sys-toggle-status ()
  (setq *status-on* (not *status-on*))
  (format t "Status bar: ~a~%"
          (if *status-on* "ON" "OFF")))

(defun palm-pilot-art ()
  (format t "~%")
  (format t "                 Retro Palm Pilot~%")
  (format t "                     ( Palm )~%~%"))

(defun palm-phone ()
  (format t "                        ____~%")
  (format t "                       |    |~%")
  (format t "                       |____|~%")
  (format t "                       |::::|~%")
  (format t "                       |::::|~%")
  (format t "                       |____|~%~%"))

(defun boot-art ()
  (palm-pilot-art)
  (palm-phone))

(defun boot-big-text ()
  (format t "                WELCOME TO THE AGE~%")
  (format t "                OF THE RETRO PDA~%~%"))

(defun boot-version-line ()
  (format t "                 ~a v~a~%~%"
          *os-name* *os-version*))

(defvar *notes* '())
(setq *notes* '())

(defun notes-add (text)
  (push text *notes*)
  (format t "Saved.~%"))

(defun notes-show ()
  (format t "NOTES:~%")
  (let ((i 1))
    (dolist (n (reverse *notes*))
      (format t "~a: ~a~%" i n)
      (setq i (+ i 1)))))

(defun notes-pop ()
  (if *notes*
      (let ((x (pop *notes*)))
        (format t "Deleted: ~a~%" x))
      (format t "No notes.~%")))

(defvar *apps-user* '())
(setq *apps-user* '())

(defvar *apps-system* '())
(setq *apps-system* '())

(defun reg-app (name fn)
  (push (cons name fn) *apps-user*)
  name)

(defun reg-sys (name fn)
  (push (cons name fn) *apps-system*)
  name)

(defun ui-header (title)
  (cls)
  (status-bar)
  (format t "~a~%" title)
  (format t "------------------------------~%"))

(defun run-app (title fn)
  (ui-header title)
  (funcall fn)
  (format t "~%0 Home > ")
  (read)
  nil)

(defun menu-list (title alist)
  (format t "~%")
  (status-bar)
  (format t "~a~%" title)
  (let ((i 1))
    (dolist (a (reverse alist))
      (format t "~a: ~a~%" i (car a))
      (setq i (+ i 1)))))

(defun menu-run (alist n)
  (let ((item (nth (- n 1) (reverse alist))))
    (if item
        (run-app (car item) (cdr item))
        (format t "Invalid~%"))))

(defun apps-menu ()
  (loop
    (menu-list "APPS" *apps-user*)
    (format t "Select (0 back): ")
    (let ((c (read)))
      (if (= c 0) (return)
          (menu-run *apps-user* c)))))

(defun system-menu ()
  (loop
    (menu-list "SYSTEM" *apps-system*)
    (format t "Select (0 back): ")
    (let ((c (read)))
      (if (= c 0) (return)
          (menu-run *apps-system* c)))))

(defun sys-info ()
  (format t "~%SYSTEM INFO~%")
  (format t "OS: ~a v~a~%" *os-name* *os-version*)
  (format t "Boot#: ~a~%" *boot-count*)
  (format t "Notes: ~a~%" (length *notes*))
  (format t "Apps: ~a~%" (length *apps-user*))
  (format t "System: ~a~%" (length *apps-system*)))

(defun sys-gc ()
  (format t "GC...~%")
  (gc))

(defun sys-uptime ()
  (format t "Boot count: ~a~%" *boot-count*))

(defun sys-save ()
  (format t "Saving...~%")
  (save-image)
  (format t "Saved.~%"))

(defun sys-load ()
  (format t "Loading...~%")
  (load-image)
  (format t "Loaded.~%"))

(defun sys-reboot ()
  (boot))

(defun sys-about ()
  (format t "~a v~a~%~%"
          *os-name* *os-version*)
  (format t "0 = Home~%"))

(defun sys-clear ()
  (cls)
  (format t "Cleared.~%"))

(defun sys-battery ()
  (format t "BAT RAW: ~a~%" (bat-raw))
  (format t "BAT V:   ~a~%" (bat-volts))
  (format t "BAT %:   ~a%%~%" (bat-percent)))

(defun sys-apps ()
  (format t "~%APPS (~a)~%" (length *apps-user*))
  (dolist (a (reverse *apps-user*))
    (format t "- ~a~%" (car a)))
  (format t "~%SYSTEM (~a)~%" (length *apps-system*))
  (dolist (s (reverse *apps-system*))
    (format t "- ~a~%" (car s))))

(defun sys-save-reboot ()
  (format t "Saving...~%")
  (save-image)
  (format t "Rebooting...~%")
  (boot))

(defun home ()
  (cls)
  (main-menu))

(defun main-read ()
  (format t "~%")
  (status-bar)
  (format t "1 Apps  2 System  0 Quit > ")
  (read))

(defun main-menu ()
  (loop
    (let ((c (main-read)))
      (cond
        ((= c 0) (return))
        ((= c 1) (apps-menu))
        ((= c 2) (system-menu))
        (t (format t "Bad~%"))))))

(defun boot ()
  (setq *boot-count* (+ *boot-count* 1))
  (cls)
  (boot-art)
  (boot-big-text)
  (boot-version-line)
  (pause)
  (cls)
  (main-menu))

(reg-app "Notes" 'notes-show)

(reg-sys "System Info" 'sys-info)
(reg-sys "GC" 'sys-gc)
(reg-sys "Uptime" 'sys-uptime)
(reg-sys "About" 'sys-about)

(reg-sys "Save Image" 'sys-save)
(reg-sys "Load Image" 'sys-load)
(reg-sys "Save + Reboot" 'sys-save-reboot)
(reg-sys "Reboot OS" 'sys-reboot)

(reg-sys "Clear Screen" 'sys-clear)
(reg-sys "Battery Details" 'sys-battery)
(reg-sys "Apps List" 'sys-apps)
(reg-sys "Toggle Status Bar" 'sys-toggle-status)

(save-image)

(boot)

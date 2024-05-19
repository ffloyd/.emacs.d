;; WARNING!
;;
;; This file is a result of `org-babel-tangle` execution on `.emacs.d/README.org`.
;; Don't change it manually.

fundamental-mode ;; Available everywhere

(today (format-time-string "%Y-%m-%d"))

prog-mode

(fixme (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "FIXME ")
(todo (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "TODO ")
(bug (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "BUG ")
(hack (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "HACK ")

elixir-ts-mode

(desc "describe \"" (s name) "\" do" n>
      r> n>
      "end" >)

(test "test \"" (s name) "\" do" n>
      r> n>
      "end" >)

(def "def " (s name) "(" (s args) ") do" n>
     r> n>
     "end" >)

(defp "defp " (s name) "(" (s args) ") do" n>
      r> n>
      "end" >)

(defm "defmodule " (s name) " do" n>
      r> n>
      "end" >)

(defts "defmodule " (s name) " do" n>
       "use TypedStruct" n>
       n>
       "typedstruct " (s opts) "do" n>
       r> n>
       "end" n>
       "end" >)

heex-ts-mode

(div "<div>" r> "</div>")
(divc "<div class=\"" (s classes) "\">" n>
      r> n>
      "</div>" >)

(p "<p>" r> "</p>")
(strong "<strong>" r> "</strong>")
(h1 "<h1>" r> "</h1>")
(h2 "<h2>" r> "</h2>")
(h3 "<h3>" r> "</h3>")
(h4 "<h4>" r> "</h4>")
(h5 "<h5>" r> "</h5>")
(h6 "<h6>" r> "</h6>")

org-mode

(src "#+BEGIN_SRC " (s lang) n>
     r> n>
     "#+END_SRC")

(elisp "#+BEGIN_SRC emacs-lisp" n>
       r> n>
       "#+END_SRC")

(shell "#+BEGIN_SRC shell" n>
       r> n>
       "#+END_SRC")

(snip "#+BEGIN_SRC lisp-data :tangle templates.eld" n>
      r> n>
      "#+END_SRC")

# company-sameline
[![GPL 3](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE.txt)

[company-mode][cm] completion using previous lines.

A simple backend offering buffer lines above point as completion
candidates with point at the end of a line.


## Installation

Put `company-sameline.el` somewhere in `load-path`, then load it and
add `company-sameline` to `company-backends` within your emacs init
file:

```elisp
(require 'company-sameline)
(add-to-list 'company-backends 'company-sameline)
```


## Activation

Since this type of completion will probably be useful under rather
specific circumstances only, a buffer-local variable is used to
activate or deactivate it.

Set `company-sameline-active` to `t` to turn it on. I usually do this
in a [file variable][fvar].


[cm]: https://github.com/company-mode/company-mode
[fvar]: https://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html

#
# Project:  zsh-aliases-exa
# File:     /zsh-aliases-exa.plugin.zsh
# Created:  2019-04-12 19:07:28
# Author:   Darrin Tisdale
# -----
# Modified: 2019-05-14 23:18:24
# Editor:   Darrin Tisdale
#

# general use
alias ls='exa'                                                         # ls
alias l='exa -lbF --git'                                               # list, size, type, git
alias ll='exa -lbGF --git'                                             # long list
alias llm='exa -lbGF --git --sort=modified'                            # long list, modified date sort
alias lc='exa -lbhHigmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='exa -lbhHigmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# speciality views
alias lS='exa -1'			                                                  # one column, just names
alias lt='exa --tree --level=2'                                         # tree

#vi: ft=neomuttrc
source "gpg -dq $HOME/.sumsum.gpg |"
set folder      = imaps://imap.gmail.com:993
set imap_user   = $my_user
set imap_pass   = $my_pass
set smtp_url = "smtp://$imap_user@smtp.gmail.com:587"
set smtp_pass = $imap_pass
set from = $my_user
set hostname="gmail.com"
set signature="Manuel Morales"


set spoolfile   = +INBOX
mailboxes       = +INBOX


# Store message headers locally to speed things up.
# If hcache is a folder, Mutt will create sub cache folders for each account which may speeds things up even more.
set header_cache = "~/.cache/neomutt/"

# Store messages locally to speed things up, like searching message bodies.
# Can be the same folder as header_cache.
# This will cost important disk usage according to your e-mail amount.
set message_cachedir = "~/.cache/neomutt/"

# Specify where to save and/or look for postponed messages.
set postponed = +[Gmail]/Drafts

# Allow Mutt to open a new IMAP connection automatically.
unset imap_passive

# Keep the IMAP connection alive by polling intermittently (time in seconds).
set imap_keepalive = 300

# How often to check for new mail (time in seconds).
set mail_check = 120

unset record

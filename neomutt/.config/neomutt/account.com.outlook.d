#vi: ft=neomuttrc
source "gpg -dq $HOME/.cocoa.gpg |"
set ssl_starttls=yes
set ssl_force_tls=yes

set imap_user = $my_user
set imap_pass = $my_pass
set from= $imap_user
set use_from=yes
set realname='Manuel Morales'
set folder = imaps://outlook.office365.com:993
set spoolfile = =INBOX
set postponed="+[hotmail]/Drafts"
set mail_check = 100
set header_cache = "~/.cache/neomutt/account.com.outlook.d"
set message_cachedir = "~/.cache/neomutt/account.com.outlook.d/cache/bodies"
set certificate_file = "~/.cache/neomutt/account.com.outlook.d/certificates"
set smtp_url = "smtp://$imap_user@smtp.office365.com:587"
set smtp_pass = $imap_pass
set move = no
set imap_keepalive = 900
set record="+Sent"
# mailboxes = +INBOX
-- Options
options.create = true
options.certificates = true
options.starttls = true
options.close = true
options.timeout = 60

-- Functions

function pass(account)
    local command = "pass " .. account
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    result = string.gsub(result, "\n*$", '')

    return result
end

-- Gmail
gmailuser = pass('gmail/user')
gmailpass = pass('gmail/password')

gmailaccount = IMAP {
    server = 'imap.gmail.com',
    port = 993,
    username = gmailuser,
    password = gmailpass,
    ssl = 'auto'
}

gmailinbox = gmailaccount["INBOX"]

print(gmailinbox:check_status())

clientesbbva = gmailinbox:contain_from("clientes@bbva.mx")

clientesbbva:move_messages(gmailaccount["BBVA"])

-- Outlook
outlookuser = pass('outlook/user')
outlookpass = pass('outlook/password')

outlookaccount = IMAP {
    server = 'outlook.office365.com',
    port = 993,
    username = outlookuser,
    password = outlookpass,
    ssl = 'auto'
}

outlookinbox = outlookaccount["INBOX"]

print(outlookinbox:check_status())

zoom = outlookinbox:contain_from("no-reply@zoom.us")

zoom:delete_messages()

linkedin = outlookinbox:contain_from("updates-noreply@linkedin.com")

linkedin:delete_messages()

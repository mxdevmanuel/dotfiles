local inspect = require('inspect')

options.create = true
options.certificates = true
options.starttls = true
options.close = true
options.timeout = 60

function pass(account)
    local command = "pass " .. account
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    result = string.gsub(result, "\n*$", '')

    return result
end

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

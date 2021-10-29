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
local gmailuser = pass('gmail/user')
local gmailpass = pass('gmail/password')

local gmailaccount = IMAP {
    server = 'imap.gmail.com',
    port = 993,
    username = gmailuser,
    password = gmailpass,
    ssl = 'auto'
}

local gmailinbox = gmailaccount["INBOX"]

print(gmailinbox:check_status())

local clientesbbva = gmailinbox:contain_from("clientes@bbva.mx")

clientesbbva:move_messages(gmailaccount["BBVA"])

-- Outlook
local outlookuser = pass('outlook/user')
local outlookpass = pass('outlook/password')

local outlookaccount = IMAP {
    server = 'outlook.office365.com',
    port = 993,
    username = outlookuser,
    password = outlookpass,
    ssl = 'auto'
}

local outlookinbox = outlookaccount["INBOX"]

print(outlookinbox:check_status())

local zoom = outlookinbox:contain_from("no-reply@zoom.us")

zoom:delete_messages()

local linkedin = outlookinbox:contain_from("updates-noreply@linkedin.com") + outlookinbox:contain_from("messages-noreply@linkedin.com")

linkedin:delete_messages()

local truefire = outlookinbox:contain_from("info@truefire.com") * outlookinbox:is_older(1)

truefire:delete_messages()

-- Office365
local office365user = pass('office365/user')
local office365pass = pass('office365/password')

local office365account = IMAP {
    server = 'outlook.office365.com',
    port = 993,
    username = office365user,
    password = office365pass,
    ssl = 'auto'
}

local office365inbox = office365account["INBOX"]

print(office365inbox:check_status())

local ds18 = office365inbox:contain_subject("DS18") * office365inbox:is_older(0)

ds18:delete_messages()

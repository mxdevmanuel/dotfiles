local pass = require("utils").pass

local M = {}

function M.execute()
	local gmailuser = pass("gmail/user")
	local gmailpass = pass("gmail/password")

	local gmailaccount = IMAP({
		server = "imap.gmail.com",
		port = 993,
		username = gmailuser,
		password = gmailpass,
		ssl = "auto",
	})

	local gmailinbox = gmailaccount["INBOX"]

	print(gmailinbox:check_status())

	local clientesbbva = gmailinbox:contain_from("clientes@bbva.mx")

	clientesbbva:move_messages(gmailaccount["BBVA"])
end

return M

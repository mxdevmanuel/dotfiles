local pass = require("./utils.lua").pass
local M = {}
function M.execute()
	local office365user = pass("office365/user")
	local office365pass = pass("office365/password")

	local office365account = IMAP({
		server = "outlook.office365.com",
		port = 993,
		username = office365user,
		password = office365pass,
		ssl = "auto",
	})

	local office365inbox = office365account["INBOX"]

	print(office365inbox:check_status())

	local ds18 = office365inbox:contain_subject("DS18") * office365inbox:is_older(0)

	ds18:delete_messages()
end
return M

local pass = require("utils").pass

local M = {}

function M.execute()
	local outlookuser = pass("outlook/user")
	local outlookpass = pass("outlook/password")

	local outlookaccount = IMAP({
		server = "outlook.office365.com",
		port = 993,
		username = outlookuser,
		password = outlookpass,
		ssl = "auto",
	})

	local outlookinbox = outlookaccount["INBOX"]

	print(outlookinbox:check_status())

	-- Delete all linkedin updates older than a week
	local linkedin = (outlookinbox:is_older(7) * outlookinbox:contain_from("linkedin.com"))

	linkedin:delete_messages()

	-- Delete older this week in react
	local thisWeekInReact = (outlookinbox:is_older(7) * outlookinbox:contain_from("thisweekinreact.com"))

	thisWeekInReact:delete_messages()

	-- Delete KPRepublic
	local truefire = outlookinbox:contain_from("peak@kprepublic.com") * outlookinbox:is_older(7)

	-- Delete unconditionally
	outlookinbox:contain_from("info@truefire.com"):delete_messages()
	outlookinbox:contain_from("no-reply@zoom.us"):delete_messages()
end

return M

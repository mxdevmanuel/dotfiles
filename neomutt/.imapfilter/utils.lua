local M = {}

function M.pass(account)
	local command = "pass " .. account
	local handle = io.popen(command)
	local result = ""
	if handle ~= nil then
		result = handle:read("*a")
		handle:close()
	end

	result = string.gsub(result, "\n*$", "")

	return result
end

return M

local user = os.getenv("USER")
package.path = package.path .. ";/home/" .. user .. "/.imapfilter/?.lua"

-- Options
options.create = true
options.certificates = true
options.starttls = true
options.close = true
options.timeout = 60

-- Gmail
local gmail = require("gmail")
gmail.execute()

-- Outlook
local outlook = require("outlook")
outlook.execute()

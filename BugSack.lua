--
-- $Id$
--
-- Developers: Rowne, Ramble, industrial, Fritti, kergoth, Rabbit
-- Testers: Ramble, Sariash
--
-- Credits to AceGUI & LuaPad for the scrollbar knowledge.
--

local L = AceLibrary("AceLocale-2.2"):new("BugSack")
BugSack = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0")

function BugSack:ReturnOptionsTable()
	return {
		type = "group",
		handler = BugSack,
		args = {
			show = {
				type = "group",
				name = L["Show sack"],
				desc = L["Show errors in the sack."],
				order = 1,
				args = {
					curr = {
						type = "execute",
						name = L["Current error"],
						desc = L["Show the current error."],
						func = "ShowCurrent",
						order = 1,
					},
					session = {
						type = "execute",
						name = L["Current session"],
						desc = L["Show errors from the current session."],
						func = "ShowSession",
						order = 2,
					},
					previous = {
						type = "execute",
						name = L["Previous session"],
						desc = L["Show errors from the previous session."],
						func = "ShowPrevious",
						order = 3,
					},
					number = {
						type = "text",
						usage = "#",
						name = L["By session number"],
						desc = L["Show errors by session number."],
						get = false,
						set = "ShowByNumber",
						validate = function(arg)
							arg = tonumber(arg)
							if arg and arg > 0 and math.floor(arg) == arg then
								return true
							end

							return false
						end,
						order = 4,
					},
					all = {
						type = "execute",
						name = L["All errors"],
						desc = L["Show all errors."],
						func = "ShowAll",
						order = 5,
					},
				},
			},
			list = {
				type = "group",
				name = L["List errors"],
				desc = L["List errors to the chat frame."],
				order = 2,
				args = {
					curr = {
						type = "execute",
						name = L["Current error"],
						desc = L["List the current error."],
						func = "ListCurrent",
						order = 1,
					},
					session = {
						type = "execute",
						name = L["Current session"],
						desc = L["List errors from the current session."],
						func = "ListSession",
						order = 2,
					},
					previous = {
						type = "execute",
						name = L["Previous session"],
						desc = L["List errors from the previous session."],
						func = "ListPrevious",
						order = 3,
					},
					number = {
						type = "text",
						usage = "#",
						name = L["By session number"],
						desc = L["List errors by session number."],
						get = false,
						set = "ListByNumber",
						validate = function(arg)
							arg = tonumber(arg)
							if arg and arg > 0 and math.floor(arg) == arg then
								return true
							end

							return false
						end,
						order = 4,
					},
					all = {
						type = "execute",
						name = L["All errors"],
						desc = L["List all errors."],
						func = "ListAll",
						order = 5,
					},
				},
			},
			auto = {
				type = "toggle",
				name = L["Auto popup"],
				desc = L["Toggle auto BugSack frame popup."],
				get = "GetAuto",
				set = "ToggleAuto",
				order = 3,
			},
			chat = {
				type = "toggle",
				name = L["Chatframe output"],
				desc = L["Print a warning to the chat frame when an error occurs."],
				get = "GetChatFrame",
				set = "ToggleChatFrame",
				order = 4,
			},
			msg = {
				type = "toggle",
				name = L["Errors to chatframe"],
				desc = L["Print the full error message to the chat frame instead of just a warning."],
				get = "GetShowMsg",
				set = "ToggleShowMsg",
				order = 5,
			},
			mute = {
				type = "toggle",
				name = L["Mute"],
				desc = L["Toggle an audible warning everytime an error occurs."],
				get = "GetMute",
				set = "ToggleMute",
				order = 6,
			},
			save = {
				type = "toggle",
				name = L["Save errors"],
				desc = L["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."],
				get = BugGrabber.GetSave,
				set = BugGrabber.ToggleSave,
				order = 7,
			},
			limit = {
				type = "range",
				name = L["Limit"],
				desc = L["Set the limit on the nr of errors saved."],
				get = BugGrabber.GetLimit,
				set = BugGrabber.SetLimit,
				min = 10,
				max = MAX_BUGGRABBER_ERRORS or 1000,
				step = 10,
				order = 8,
			},
			bug = {
				type = "group",
				name = L["Generate bug"],
				desc = L["Generate a fake bug for testing."],
				order = 9,
				args = {
					script = {
						type = "execute",
						name = L["Script bug"],
						desc = L["Generate a script bug."],
						func = "ScriptBug",
						order = 1,
					},
					addon = {
						type = "execute",
						name = L["Addon bug"],
						desc = L["Generate an addon bug."],
						func = "AddonBug",
						order = 2,
					}
				}
			},
			reset = {
				type = "execute",
				name = L["Clear errors"],
				desc = L["Clear out the errors database."],
				func = "Reset",
				order = 10,
			},
			events = {
				type = "toggle",
				name = L["Filter addon mistakes"],
				desc = L["Filters common mistakes that trigger the blocked/forbidden event."],
				get = "GetFilter",
				set = "ToggleFilter",
				order = 11,
			},
		}
	}
end

function BugSack:OnInitialize()
	self:RegisterDB("BugSackDB")
	self:RegisterDefaults("profile", {
		mute = nil,
		auto = nil,
		showmsg = nil,
		chatframe = nil,
		filterAddonMistakes = true,
	})
	self:RegisterChatCommand({"/bugsack", "/bs"}, self:ReturnOptionsTable())

	-- Remove old compatibility stuff
	for _,i in pairs({ "profile", "char", "class", "realm" }) do
		for _,j in pairs({ "errors", "save", "sound", "session" }) do
			if self.db[i][j] then
				self.db[i][j] = nil
			end
		end
	end


	-- Swipe the load errors from BugGrabber if there were any
	if BugGrabber and BugGrabber.bugsackErrors then
		for _, err in pairs(BugGrabber.bugsackErrors) do self:OnError(err) end
		BugGrabber.bugsackErrors = nil
	end
end

function BugSack:OnEnable()
	-- Set up our error event handler
	self:RegisterBucketEvent("BugGrabber_BugGrabbed", 2, "OnError")

	if not self:GetFilter() then
		self:RegisterBucketEvent("BugGrabber_EventGrabbed", 2, "OnError")
	end
end

function BugSack:GetErrors(which)
	local db = BugGrabber.GetDB()
	local cs = BugGrabberDB.session
	local errs = {}

	if not which or (type(which) ~= "string" and type(which) ~= "number") then
		return errs
	end

	if which == "current" then
		local current = #db
		if current ~= 0 and db[current].session == cs then
			table.insert(errs, db[current])
		end
		return errs
	end

	local str = ""
	for _, err in pairs(db) do
		if (which == "all")
		  or (which == "session" and cs == tonumber(err.session))
		  or (which == "previous" and cs - 1 == tonumber(err.session))
		  or (which == err.session) then
			table.insert(errs, err)
		end
	end
	return errs
end

function BugSack:GetFilter()
	return self.db.profile.filterAddonMistakes
end

function BugSack:ToggleFilter()
	self.db.profile.filterAddonMistakes = not self.db.profile.filterAddonMistakes or nil
	if not filter and not self:IsBucketEventRegistered("BugGrabber_EventGrabbed") then
		self:RegisterBucketEvent("BugGrabber_EventGrabbed", 2, "OnError")
	elseif self:IsBucketEventRegistered("BugGrabber_EventGrabbed") then
		self:UnregisterBucketEvent("BugGrabber_EventGrabbed")
	end
end

function BugSack:GetAuto()
	return self.db.profile.auto
end

function BugSack:ToggleAuto()
	self.db.profile.auto = not self.db.profile.auto or nil
end

function BugSack:GetShowMsg()
	return self.db.profile.showmsg
end

function BugSack:ToggleShowMsg()
	self.db.profile.showmsg = not self.db.profile.showmsg or nil
end

function BugSack:GetChatFrame()
	return self.db.profile.chatframe
end

function BugSack:ToggleChatFrame()
	self.db.profile.chatframe = not self.db.profile.chatframe or nil
end

function BugSack:GetMute()
	return self.db.profile.mute
end

function BugSack:ToggleMute()
	self.db.profile.mute = not self.db.profile.mute
end

function BugSack:ShowCurrent()
	self:ShowFrame("current")
end

function BugSack:ShowSession()
	self:ShowFrame("session")
end

function BugSack:ShowPrevious()
    self:ShowFrame("previous")
end

function BugSack:ShowByNumber(n)
    self:ShowFrame(n)
end

function BugSack:ShowAll()
	self:ShowFrame("all")
end

function BugSack:ShowFrame(which, nr)
	self.which = which
	self.errs = self:GetErrors(which)
	self.max = #self.errs

	if nr then
		self.cur = math.min(self.max, math.abs(nr))
	else
		self.cur = math.min(self.max, 1)
	end
	self:UpdateFrameText()

	BugSackFrame:Show()
end

function BugSack:UpdateFrameText()
	local caption

	if self.cur == 0 then
		self.str = L["You have no errors, yay!"]
		caption = L["No errors found"]
	else
		self.str = self:FormatError(self.errs[self.cur])
		if ( GetLocale() == "koKR" ) then
			caption = string.format(L["Error %d of %d"], self.max, self.cur)
		else
			caption = string.format(L["Error %d of %d"], self.cur, self.max)
		end
	end

	if self.which == "current" then
		caption = caption .. L[" (viewing last error)"]
	elseif self.which == "session" then
		caption = caption .. L[" (viewing session errors)"]
	elseif self.which == "previous" then
		caption = caption .. L[" (viewing previous session errors)"]
	elseif self.which == "all" then
		caption = caption .. L[" (viewing all errors)"]
	else
		caption = caption .. string.format(L[" (viewing errors for session %d)"], self.which)
	end
	BugSackErrorText:SetText(caption)

	if self.str and self.str:len() > 4000 then
		self.str = self.str:sub(1, 3950) .. L[" (... more ...)"]
	end
	BugSackFrameScrollText:SetText(self.str)

	if self.cur >= self.max then
		BugSackNextButton:Disable()
		BugSackLastButton:Disable()
	else
		BugSackNextButton:Enable()
		BugSackLastButton:Enable()
	end

	if self.cur <= 1 then
		BugSackPrevButton:Disable()
		BugSackFirstButton:Disable()
	else
		BugSackPrevButton:Enable()
		BugSackFirstButton:Enable()
	end
end

function BugSack:OnFirstClick()
	self.cur = math.min(self.max, 1)
	self:UpdateFrameText()
end

function BugSack:OnPrevClick()
	self.cur = self.cur - 1
	self:UpdateFrameText()
end

function BugSack:OnLastClick()
	self.cur = self.max
	self:UpdateFrameText()
end

function BugSack:OnNextClick()
	self.cur = self.cur + 1
	self:UpdateFrameText()
end

function BugSack:ListCurrent()
    self:ListErrors("current")
end

function BugSack:ListSession()
    self:ListErrors("session")
end

function BugSack:ListPrevious()
    self:ListErrors("previous")
end

function BugSack:ListByNumber(n)
    self:ListErrors(n)
end

function BugSack:ListAll()
    self:ListErrors("all")
end

function BugSack:ListErrors(which)
	local errs = self:GetErrors(which)
	if #errs == 0 then
		self:Print(L["You have no errors, yay!"])
		return
	end

	self:Print(L["List of errors:"])
	for i,err in ipairs(errs) do
		self:Print("%d. %s", i, self:FormatError(err))
	end
end

function BugSack:FormatError(err)
	if type(err) ~= "table" then
		if type(err) == "string" then
			return string.format("%q is not a valid BugGrabber error.", err)
		else
			return string.format("Tried to format an error of type %q, should be a table.", type(err))
		end
	end
	local m
	if type(err.message) == "table" then
		m = table.concat(err.message, '')
	else
		m = err.message
	end
	return string.format("|cff999999[%s-%d-x%d]|r: %s", err.time or "Uknown", err.session or -1, err.counter or -1, self:ColorError(m or ""))
end

function BugSack:ColorError(err)
	local ret = err
	ret = ret:gsub("|([^chHr])", "||%1") -- pipe char
	ret = ret:gsub("|$", "||") -- pipe char
	ret = ret:gsub(":(%d+): ", ":|cff00ff00%1|r: ") -- Line numbers
	ret = ret:gsub("\n(.-):", "\n|cffeda55f%1|r:") -- Files
	ret = ret:gsub("([`'\"])(.-)([`'\"])", "|cff8888ff%1%2%3|r") -- Quotes
	ret = ret:gsub("^(.-):", "|cffeda55f%1|r:") -- First file after time and date
	return ret
end

function BugSack:ScriptBug()
	self:Print(L["An error has been generated."])
	RunScript(L["BugSack generated this fake error."])
end

function BugSack:AddonBug()
	self:BugGeneratedByBugSack()
	self:Print(L["An error has been generated."])
end

function BugSack:Reset()
	BugGrabber.loadErrors = nil
	BugGrabber.errors = {}
	BugGrabberDB.errors = {}
	self:Print(L["All errors were wiped."])

	if self:IsEventRegistered("BugGrabber_BugGrabbed") and BugSackFu and type(BugSackFu.IsActive) == "function" and BugSackFu:IsActive() then
		BugSackFu:Reset()
		BugSackFu:UpdateDisplay()
	end
end

-- The Error catching function.

function BugSack:OnError(err)
	if not self.db.profile.mute then
		PlaySoundFile("Interface\\AddOns\\BugSack\\error.wav")
	end

	if self.db.profile.auto then
		self:ShowCurrent()
	end

	local firstError = nil
	local num = 0
	for k, v in pairs(err) do
		num = num + 1
		if not firstError then firstError = k end
	end
	if self.db.profile.chatframe and self.db.profile.showmsg and num == 1 then
		self:Print(self:FormatError(firstError))
	elseif self.db.profile.chatframe then
		if num > 1 then
			self:Print(string.format(L["%d errors have been recorded."], num))
		else
			self:Print(L["An error has been recorded."])
		end
	end

	if self:IsEventRegistered("BugGrabber_BugGrabbed") and BugSackFu and type(BugSackFu.IsActive) == "function" and BugSackFu:IsActive() then
		BugSackFu:UpdateDisplay()
	end
end

-- Editbox handler

function BugSack:OnTextChanged()
	if this:GetText() ~= self.str then
		this:SetText(self.str)
	end
	local s = BugSackFrameScrollScrollBar
	this:GetParent():UpdateScrollChildRect()
	local _, m = s:GetMinMaxValues()
	if m > 0 and this.max ~= m then
		this.max = m
		s:SetValue(m)
	end
end

-- Keybindings

BINDING_HEADER_BUGSACK = "BugSack"
BINDING_NAME_BUGSACK_SHOW_CURRENT = L["Show Current Error"]
BINDING_NAME_BUGSACK_SHOW_SESSION = L["Show Session Errors"]

-- vim:set ts=4:

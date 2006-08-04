--
-- $Id: BugSack.lua 6442 2006-08-01 09:40:05Z fritti $
--
-- Developers: Rowne, Ramble, industrial, Fritti, kergoth
-- Testers: Ramble, Sariash
--
-- Credits to AceGUI & LuaPad for the scrollbar knowledge.
--

local L = AceLibrary("AceLocale-2.0"):new("BugSack")
BugSack = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0")

function BugSack:OnInitialize()
	self:RegisterDB("BugSackDB")
	self:RegisterDefaults("profile", {
		mute = nil,
		auto = nil,
		showmsg = nil
	})
	self.optionsTable = {
		type = "group",
		handler = BugSack,
		args = {
			show = {
				type = "group",
				name = L"Show sack",
				desc = L"Show errors in the sack.",
				args = {
					curr = {
						type = "execute",
						name = L"Current error",
						desc = L"Show the current error.",
						func = "ShowCurrent",
					},
					session = {
						type = "execute",
						name = L"Current session",
						desc = L"Show errors from the current session.",
						func = "ShowSession",
					},
					previous = {
						type = "execute",
						name = L"Previous session",
						desc = L"Show errors from the previous session.",
						func = "ShowPrevious",
					},
					number = {
						type = "text",
						usage = "#",
						name = L"By session number",
						desc = L"Show errors by session number.",
						get = false,
						set = "ShowByNumber",
						validate = function(arg)
							arg = tonumber(arg)
							if arg and arg > 0 and math.floor(arg) == arg then
								return true
							end

							return false
						end
					},
					all = {
						type = "execute",
						name = L"All errors",
						desc = L"Show all errors.",
						func = "ShowAll",
					},
				},
			},
			list = {
				type = "group",
				name = L"List errors",
				desc = L"List errors to the chat frame.",
				args = {
					curr = {
						type = "execute",
						name = L"Current error",
						desc = L"List the current error.",
						func = "ListCurrent",
					},
					session = {
						type = "execute",
						name = L"Current session",
						desc = L"List errors from the current session.",
						func = "ListSession",
					},
					previous = {
						type = "execute",
						name = L"Previous session",
						desc = L"List errors from the previous session.",
						func = "ListPrevious",
					},
					number = {
						type = "text",
						usage = "#",
						name = L"By session number",
						desc = L"List errors by session number.",
						get = false,
						set = "ListByNumber",
						validate = function(arg)
							arg = tonumber(arg)
							if arg and arg > 0 and math.floor(arg) == arg then
								return true
							end

							return false
						end
					},
					all = {
						type = "execute",
						name = L"All errors",
						desc = L"List all errors.",
						func = "ListAll",
					},
				},
			},
			auto = {
				type = "toggle",
				name = L"Auto popup",
				desc = L"Toggle auto BugSack frame popup.",
				get = "GetAuto",
				set = "ToggleAuto"
			},
			msg = {
				type = "toggle",
				name = L"Auto chat output",
				desc = L"Toggle auto printing of messages to the chat frame.",
				get = "GetShowMsg",
				set = "ToggleShowMsg"
			},
			mute = {
				type = "toggle",
				name = L"Mute",
				desc = L"Toggle an audible warning everytime an error occurs.",
				get = "GetMute",
				set = "ToggleMute"
			},
			bug = {
				type = "group",
				name = L"Generate bug",
				desc = L"Generate a fake bug for testing.",
				args = {
					script = {
						type = "execute",
						name = L"Script bug",
						desc = L"Generate a script bug.",
						func = "ScriptBug"
					},
					addon = {
						type = "execute",
						name = L"Addon bug",
						desc = L"Generate an addon bug.",
						func = "AddonBug"
					}
				}
			},
			reset = {
				type = "execute",
				name = L"Clear errors",
				desc = L"Clear out the errors database.",
				func = "Reset"
			}
		}
	}
	self:RegisterChatCommand({"/bugsack", "/bs"}, self.optionsTable)
end

function BugSack:OnEnable()
	self:RegisterEvent("BugGrabber_BugGrabbed", "OnError")

	-- If we have BugGrabber, swipe the load time errors from it
	if BugGrabber then
		for _, err in pairs(BugGrabber.loadErrors) do self:OnError(err) end
		BugGrabber.loadErrors = nil
	end
end

function BugSack:GetErrors(i)
	local cs = BugGrabberDB.session

	if not i or (type(i) ~= "string" and type(i) ~= "number") then
		return
	end

	if i == "current" then
		local current = table.getn(BugGrabberDB.errors)
		if current == 0 then
			return
		end
		return BugGrabber.FormatError(BugGrabberDB.errors[current])
	end

	local str = ""
	for _, err in pairs(BugGrabberDB.errors) do
		if (i == "all")
		  or (i == "session" and cs == tonumber(err.session))
		  or (i == "previous" and cs - 1 == tonumber(err.session))
		  or (i == err.session) then
			str = str .. "- " .. BugGrabber.FormatError(err) .. "\n"
		end
	end
	if str ~= "" then
		return str
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

function BugSack:ShowFrame(i)
	local err = self:GetErrors(i)
	if err then
		self.str = err
	else
		self.str = L"You have no errors, yay!"
	end

	local f = BugSackFrameScrollText
	f:SetText(self.str)
	if i and i == "current" then
		f:HighlightText()
	end
	BugSackFrame:Show()
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

function BugSack:ListErrors(i)
	local err = self:GetErrors(i)
	if err then
		self:Print(L"List of errors:")
		self:Print(err)
	else
		self:Print(L"You have no errors, yay!")
	end
end

function BugSack:ScriptBug()
	self:Print(L"An error has been generated.")
	RunScript(L"BugSack generated this fake error.")
end

function BugSack:AddonBug()
	self:BugGeneratedByBugSack()
	self:Print(L"An error has been generated.")
end

function BugSack:Reset()
	BugGrabberDB.errors = {}
	self:Print(L"All errors were wiped.")

	if BugSackFu then
		BugSackFu:UpdateText()
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

	if self.db.profile.showmsg then
		self:Print(BugGrabber.FormatError(err))
	else
		self:Print(L"An error has been recorded.")
	end

	if BugSackFu then
		BugSackFu:UpdateText()
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
BINDING_NAME_BUGSACK_SHOW_CURRENT = L"Show Current Error"
BINDING_NAME_BUGSACK_SHOW_SESSION = L"Show Session Errors"

-- vim:set ts=4:

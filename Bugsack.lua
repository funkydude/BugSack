--
-- $Id: BugSack.lua 6442 2006-08-01 09:40:05Z fritti $
--
-- Developers: Rowne, Ramble, industrial, Fritti, kergoth
-- Testers: Ramble, Sariash
--
-- Credits to AceGUI & LuaPad for the scrollbar knowledge.
--

local L = AceLibrary("AceLocale-2.0"):new("BugSack")
BugSack = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0")

function BugSack:OnInitialize()
	self:RegisterDB("BugSackDB")
	self:RegisterDefaults("profile", {
		save = false,
		sound = true,
		auto = false,
		backtrace = false,
		showmsg = false,
		errors = {}
	})
	self.optionsTable = {
		type = "group",
		handler = BugSack,
		args = {
			show = {
				type = "execute",
				name = L"Show all errors",
				desc = L"Show the BugSack frame with all errors.",
				func = "ShowFrame",
			},
			curr = {
				type = "execute",
				name = L"Show current error",
				desc = L"Show the BugSack frame with the current error.",
				func = "CurrFrame",
			},
			save = {
				type = "toggle",
				name = L"Save bugs",
				desc = L"Toggle whether to save bugs or not.",
				get = "GetSave",
				set = "ToggleSave"
			},
			backtrace = {
				type = "toggle",
				name = L"Backtrace",
				desc = L"Show a backtrace for each error.",
				get = "GetBacktrace",
				set = "ToggleBacktrace"
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
				name = L"Chat frame output",
				desc = L"Toggle printing of messages to the chat frame.",
				get = "GetShowmsg",
				set = "ToggleShowmsg"
			},
			sound = {
				type = "toggle",
				name = L"Audible warning",
				desc = L"Toggle an audible warning everytime an error occurs.",
				get = "GetSound",
				set = "ToggleSound"
			},
			list = {
				type = "group",
				name = L"List errors",
				desc = L"List errors from a specific session.",
				args = {
					all = {
						type = "execute",
						name = L"Current session",
						desc = L"List errors from the current session.",
						func = "ListAll",
					},
				},
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
	if self.db.profile.save then
		self:SetSave(true)
	end
	self:RegisterChatCommand({"/bugsack", "/bs"}, self.optionsTable)
end

function BugSack:OnEnable()
	self.db.profile.session = (self.db.profile.session or 0) + 1
	ScriptErrors_Message.SetText = function(_, err) self:Error(err) end
	ScriptErrors.Show = function() end

	-- If we have BugGrabber, swipe the load time errors from it
	if BugGrabber then
		for k, v in BugGrabber do self:Error(v) end
		BugGrabber = nil
	end

	-- Clear our current session error database
	self.errDB = {}
end

function BugSack:OnDisable()
	ScriptErrors_Message.SetText = nil
	ScriptErrors.Show = nil
end

function BugSack:GetDB()
	if self.db.profile.save then
		return self.db.profile.errors
	else
		return self.errDB
	end
end

-- The command handlers

function BugSack:GetSave()
	return self.db.profile.save
end

function BugSack:ToggleSave()
	self.db.profile.save = not self.db.profile.save
	self:SetSave(self.db.profile.save)
end

function BugSack:SetSave(arg)
	local l = self.optionsTable.args.list.args
	if arg then
		l.previous = {
			type = "execute",
			name = L"Previous session",
			desc = L"List errors from the previous session.",
			func = "ListPrevious",
		}
		l.number = {
			type = "text",
			usage = "#",
			name = L"By Session number",
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
		}
	else
		l.previous = nil
		l.number = nil
	end
end

function BugSack:GetBacktrace()
	return self.db.profile.backtrace
end

function BugSack:ToggleBacktrace()
	self.db.profile.backtrace = not self.db.profile.backtrace
end

function BugSack:GetAuto()
	return self.db.profile.auto
end

function BugSack:ToggleAuto()
	self.db.profile.auto = not self.db.profile.auto
end

function BugSack:GetShowmsg()
	return self.db.profile.showmsg
end

function BugSack:ToggleShowmsg()
	self.db.profile.showmsg = not self.db.profile.showmsg
end

function BugSack:GetSound()
	return self.db.profile.sound
end

function BugSack:ToggleSound()
	self.db.profile.sound = not self.db.profile.sound
end

function BugSack:ListAll()
    self:ListErrors("all")
end

function BugSack:ListPrevious()
    self:ListErrors("previous")
end

function BugSack:ListByNumber(n)
    self:ListErrors(n)
end

function BugSack:ListErrors(i)
	local cs = self.db.profile.session
	local db = self:GetDB()
	local f = false
	self:Print(L"List of errors:")
	for _, v in db do
		local _, _, ses = strfind(v, "-(.+)] ")
		if i == "all" or i == "" and cs == tonumber(ses)
		  or i == "previous" and cs - 1 == tonumber(ses)
		  or ses == i then
			v = "- "..v
			self:Print(v)
			f = true
		end
	end
	if not f then
		self:Print(L"You have no errors, yay!")
	end
end

function BugSack:CurrFrame(i)
	self:ShowFrame("curr")
end

function BugSack:ShowFrame(i)
	local cs = self.db.profile.session
	local db = self:GetDB()
	self.str = ""
	if i and strlen(i) > 0 then
		self.str = db[getn(db)]
	else
		for _, v in db do
			local _, _, ses = strfind(v, "-(.+)] ")
			if cs == tonumber(ses) then
				v = ({strfind(v, "(%a+.lua.*)")})[3] or v
				self.str = self.str..v.."\n"
			end
		end
	end
	self.str = strlen(self.str or "") > 0 and self.str or L"You have no errors, yay!"

	local f = BugSackFrameScrollText
	f:SetText(self.str)
	if i and strlen(i) > 0 then
		f:HighlightText()
	end
	BugSackFrame:Show()
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
	self.db.profile.errors = {}
	self.errDB = {}
	self:Print(L"All errors were wiped.")

	if BugSackFu then
		BugSackFu:UpdateText()
	end
end

-- The Error catching function.

function BugSack:Error(err)
	local cs = self.db.profile.session
	local db = self:GetDB()
	local oe

	-- Put some effort into normalizing the full paths to the lua files
	-- into just the last directory component and filename.
	if self.db.profile.backtrace then
		oe = ""
		err = err .. "\n" .. debugstack(4)
		for line in string.gfind(err, "(.-)\n") do
			local _, _, path, file, msg = string.find(line, "^.-([^\\]+\\)([^\\]-):(.*)$")
			-- "path\\to\\file.lua:linenum:message"
			if not msg then
				_, _, path, file, msg = string.find(line, "^[string \".-([^\\]+\\)([^\\]-):(.*)$")
				if path then
					-- "[string \"path\\to\\file.lua:<foo>\":linenum:message"
					path = "[string \""..path
				else
					-- "[string \"FOO\":linenum:message"
					_, _, path, file, msg = string.find(line, "^([string )(\"[^\"]+\"]):(.*)$")
				end
			end
			if msg then
				msg = string.gsub(msg, "<.-([^\\]+\\)([^\\]-):(.*)>", "<%1%2:%3>")
				oe = oe .. string.format("%s%s:%s\n", path, file, msg)
			end
		end
	else
		local _, _, path, file, msg = string.find(err, "^.-([^\\]+\\)([^\\]-):(.*)$")
		oe = string.format("%s%s:%s\n", path, file, msg)
	end

	oe = "[" .. date("%H:%M") .. "-" .. cs .. "] " .. oe .. "\n   ---"
	for _, v in db do
		local _, _, ses, ee = strfind(v, "-(.+)] (.-)\n")
		local _, _, _, oeline = strfind(oe, "-(.+)] (.-)\n")
		if cs == tonumber(ses) and ee == oeline then
			return
		end
	end
	tinsert(db, oe)
	if self.db.profile.sound then
		PlaySoundFile("Interface\\AddOns\\BugSack\\error.wav")
	end
	if not self.db.profile.save then
		self.errDB = db
	else
		self.db.profile.errors = db
	end
	if self.db.profile.auto then
		self:ShowFrame()
	else
		if self.db.profile.showmsg then
			self:Print(oe)
		else
            self:Print(L"An error has been recorded.")
		end
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

BINDING_HEADER_BUGSACK           = "BugSack"
BINDING_NAME_BUGSACK_SHOW_ALL    = L"Show All"
BINDING_NAME_BUGSACK_SHOW_LATEST = L"Show Latest"

-- vim:set ts=4:

--
-- $Id$
--
-- The BugSack and BugGrabber team is:
-- Current Developer: Rabbit
-- Past Developers: Rowne, Ramble, industrial, Fritti, kergoth
-- Testers: Ramble, Sariash
--
-- Credits to AceGUI & LuaPad for the scrollbar knowledge.
--
--[[

BugSack, a World of Warcraft addon that interfaces with the !BugGrabber addon
to present errors in a nice way.
Copyright (C) 2008 The BugSack Team.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

]]

local _G = getfenv(0)

local L = LibStub("AceLocale-3.0"):GetLocale("BugSack")
local media = LibStub("LibSharedMedia-3.0", true)
local cbh = LibStub("CallbackHandler-1.0")
local icon = LibStub("LibDBIcon-1.0", true)

BugSack = LibStub("AceAddon-3.0"):NewAddon("BugSack", "AceComm-3.0", "AceSerializer-3.0")

local BugSack = BugSack
local BugGrabber = _G.BugGrabber
local BugGrabberDB = _G.BugGrabberDB

local isEventsRegistered = nil

-- Frame state variables
local sackType = nil
local sackErrors = nil
local sackText = nil
local sackMax = nil
local sackCurrent = nil

local receivedFrom = nil
local receivedErrors = nil

BugSack.options = {
	type = "group",
	handler = BugSack,
	args = {
		show = {
			type = "group",
			name = L["Show sack"],
			desc = L["Show errors in the sack."],
			pass = true,
			func = "ShowFrame",
			get = false,
			set = "ShowFrame",
			order = 100,
			args = {
				current = {
					type = "execute",
					name = L["Current error"],
					desc = L["Show the current error."],
					passValue = "current",
					order = 1,
				},
				session = {
					type = "execute",
					name = L["Current session"],
					desc = L["Show errors from the current session."],
					passValue = "session",
					order = 2,
				},
				previous = {
					type = "execute",
					name = L["Previous session"],
					desc = L["Show errors from the previous session."],
					passValue = "previous",
					order = 3,
				},
				number = {
					type = "text",
					usage = "#",
					name = L["By session number"],
					desc = L["Show errors by session number."],
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
					passValue = "all",
					order = 5,
				},
				received = {
					type = "execute",
					name = L["Received errors"],
					desc = L["Show errors received from another player."],
					passValue = "received",
					order = 6,
					disabled = function() return not receivedErrors end,
				},
			},
		},
		list = {
			type = "group",
			name = L["List errors"],
			desc = L["List errors to the chat frame."],
			order = 101,
			pass = true,
			get = false,
			set = "ListErrors",
			func = "ListErrors",
			args = {
				current = {
					type = "execute",
					name = L["Current error"],
					desc = L["List the current error."],
					passValue = "current",
					order = 1,
				},
				session = {
					type = "execute",
					name = L["Current session"],
					desc = L["List errors from the current session."],
					passValue = "session",
					order = 2,
				},
				previous = {
					type = "execute",
					name = L["Previous session"],
					desc = L["List errors from the previous session."],
					passValue = "previous",
					order = 3,
				},
				number = {
					type = "text",
					usage = "#",
					name = L["By session number"],
					desc = L["List errors by session number."],
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
					passValue = "all",
					order = 5,
				},
				received = {
					type = "execute",
					name = L["Received errors"],
					desc = L["List errors received from another player."],
					passValue = "received",
					order = 6,
					disabled = function() return not receivedErrors end,
				},
			},
		},
		limit = {
			type = "range",
			name = L["Limit"],
			desc = L["Set the limit on the nr of errors saved."],
			get = "GetLimit",
			set = "SetLimit",
			handler = BugGrabber,
			min = 10,
			max = MAX_BUGGRABBER_ERRORS or 1000,
			step = 10,
			order = 102,
		},
		save = {
			type = "toggle",
			name = L["Save errors"],
			desc = L["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."],
			get = "GetSave",
			set = "ToggleSave",
			handler = BugGrabber,
			order = 103,
		},
		reset = {
			type = "execute",
			name = L["Clear errors"],
			desc = L["Clear out the errors database."],
			func = "Reset",
			order = 104,
		},
		spacer1 = {
			type = "header",
			name = " ",
			order = 105,
		},
		auto = {
			type = "toggle",
			name = L["Auto popup"],
			desc = L["Toggle auto BugSack frame popup."],
			get = function() return BugSack.db.profile.auto end,
			set = function(v) BugSack.db.profile.auto = v end,
			order = 200,
		},
		chat = {
			type = "toggle",
			name = L["Chatframe output"],
			desc = L["Print a warning to the chat frame when an error occurs."],
			get = function() return BugSack.db.profile.chatframe end,
			set = function(v) BugSack.db.profile.chatframe = v end,
			order = 201,
		},
--[[		msg = {
			type = "toggle",
			name = L["Errors to chatframe"],
			desc = L["Print the full error message to the chat frame instead of just a warning."],
			get = function() return BugSack.db.profile.showmsg end,
			set = function(v) BugSack.db.profile.showmsg = v end,
			order = 202,
		},]]
		mute = {
			type = "toggle",
			name = L["Mute"],
			desc = L["Toggle an audible warning everytime an error occurs."],
			get = function() return BugSack.db.profile.mute end,
			set = function(v) BugSack.db.profile.mute = v end,
			hidden = function() return media end,
			order = 203,
		},
		soundMedia = {
			type = "text",
			name = L["Sound"],
			desc = L["What sound to play when an error occurs (Ctrl-Click to preview.)"],
			get = function() return BugSack.db.profile.soundMedia end,
			set = function(v)
				if IsControlKeyDown() then
					PlaySoundFile(media:Fetch("sound", v))
				else
					BugSack.db.profile.soundMedia = v
				end
			end,
			hidden = function() return not media end,
			usage = "",
			order = 204,
		},
		spacer2 = {
			type = "header",
			name = " ",
			order = 250,
		},
		sendbugs = {
			type = "text",
			name = L["Send bugs"],
			desc = L["Sends your current session bugs to another BugSack user."],
			get = false,
			set = "SendBugsToUser",
			usage = L["<player name>"],
			validate = function(v) return type(v) == "string" and v:trim():len() > 0 end,
			order = 300,
		},
		bug = {
			type = "group",
			name = L["Generate bug"],
			desc = L["Generate a fake bug for testing."],
			order = 301,
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
		events = {
			type = "toggle",
			name = L["Filter addon mistakes"],
			desc = L["Filters common mistakes that trigger the blocked/forbidden event."],
			get = "GetFilter",
			set = "ToggleFilter",
			order = 302,
		},
		throttle = {
			type = "toggle",
			name = L["Throttle at excessive amount"],
			desc = L["Whether to throttle for a default of 60 seconds when BugGrabber catches more than 20 errors per second."],
			get = "IsThrottling",
			set = "UseThrottling",
			handler = BugGrabber,
			order = 303,
		},
		minimapSpacer = {
			type = "header",
			name = " ",
			order = 350,
			hidden = function() return not icon end,
		},
		minimap = {
			type = "toggle",
			name = L["Minimap icon"],
			desc = L["Toggle the minimap icon."],
			get = function() return not BugSack.db.profile.minimap.hide end,
			set = function(v)
				local hide = not v
				BugSack.db.profile.minimap.hide = hide
				if hide then
					icon:Hide("BugSack")
				else
					icon:Show("BugSack")
				end
			end,
			hidden = function() return not icon end,
			order = 400,
		},
	}
}

local defaults = {
	profile = {
		mute = nil,
		auto = nil,
		showmsg = nil,
		chatframe = nil,
		filterAddonMistakes = true,
		soundMedia = "BugSack: Fatality",
		minimap = {
			hide = false,
		},
	},
}

local bugSackFrame = nil
local function showErrorFrame()
	if not bugSackFrame then
		local f = CreateFrame("Frame", "BugSackFrame2", UIParent, "DialogBoxFrame")
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		})
		f:SetWidth(500)
		f:SetHeight(400)

		local topText = f:CreateFontString("BugSackErrorText2", "GameFontHighlight")
		topText:SetPoint("TOPLEFT", f, 5, -5)
		topText:SetFontObject(GameFontHighlight)
		topText:SetText("Test")

		local scroll = CreateFrame("ScrollFrame", "BugSackFrameScroll2", f, "UIPanelScrollFrameTemplate")
		scroll:SetPoint("TOP", f, -10, -16)
		scroll:SetWidth(455)
		scroll:SetHeight(330)

		local edit = CreateFrame("EditBox", "BugSackFrameScrollText2", scroll)
		edit:SetWidth(450)
		edit:SetHeight(314)
		edit:SetAutoFocus(false)
		edit:SetMultiLine(true)
		edit:SetFontObject(ChatFontNormal)
		edit:SetMaxLetters(99999)
		edit:EnableMouse(true)
		
		scroll:SetScrollChild(edit)

		local prev = CreateFrame("Button", "BugSackPrevButton2", f, "UIPanelButtonTemplate")
		prev:SetWidth(64)
		prev:SetHeight(24)
		prev:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 20)
		prev:SetScript("OnClick", function()
			sackCurrent = sackCurrent - 1
			BugSack:UpdateFrameText()
		end)
		prev:SetText("Previous")
		
		local next = CreateFrame("Button", "BugSackNextButton2", f, "UIPanelButtonTemplate")
		next:SetWidth(64)
		next:SetHeight(24)
		next:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 90, 20)
		next:SetScript("OnClick", function()
			sackCurrent = sackCurrent + 1
			BugSack:UpdateFrameText()
		end)
		next:SetText("Next")
		
		local last = CreateFrame("Button", "BugSackLastButton2", f, "UIPanelButtonTemplate")
		last:SetWidth(64)
		last:SetHeight(24)
		last:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 20)
		last:SetScript("OnClick", function()
			sackCurrent = sackMax
			BugSack:UpdateFrameText()
		end)
		last:SetText("Last")
		
		local first = CreateFrame("Button", "BugSackFirstButton2", f, "UIPanelButtonTemplate")
		first:SetWidth(64)
		first:SetHeight(24)
		first:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -90, 20)
		first:SetScript("OnClick", function()
			sackCurrent = math.min(sackMax, 1)
			BugSack:UpdateFrameText()
		end)
		first:SetText("First")

		bugSackFrame = f
	end
	
	bugSackFrame:Show()
end

local function print(t)
	DEFAULT_CHAT_FRAME:AddMessage("BugSack: " .. t)
end

function BugSack:OnInitialize()
	local revision = tonumber(string.sub("$Revision$", 12, -3)) or 1
	if not self.version then self.version = "2.x.x" end
	self.version = self.version .. "." .. revision
	self.revision = revision

	self.callbacks = cbh:New(self)

	_G.BUGSACK_REVISION = self.revision
	_G.BUGSACK_VERSION = self.version

	self.db = LibStub("AceDB-3.0"):New("BugSackDB", defaults, "Default")

	if media then
		media:Register("sound", "BugSack: Fatality", "Interface\\AddOns\\BugSack\\Media\\error.wav")
		self.options.args.soundMedia.validate = media:List("sound")
	end
end

function BugSack:OnEnable()
	-- Make sure we grab any errors fired before bugsack loaded.
	local session = self:GetErrors("session")
	if session and #session > 0 then
		local t = {}
		for i, v in ipairs(session) do
			t[v] = true
		end
		self:OnError(t)
		for k in pairs(t) do t[k] = nil end
		t = nil
	end

	self:RegisterComm("BugSack", "OnBugComm")

	-- Set up our error event handler
	BugGrabber.RegisterCallback(self, "BugGrabber_BugGrabbed", "OnError")
	BugGrabber.RegisterCallback(self, "BugGrabber_AddonActionEventsRegistered")

	if not self:GetFilter() then
		BugGrabber.RegisterCallback(self, "BugGrabber_EventGrabbed", "OnError")
		isEventsRegistered = true
		BugGrabber:RegisterAddonActionEvents()
	else
		BugGrabber:UnregisterAddonActionEvents()
	end
end

function BugSack:Taint(addon)
	if type(addon) ~= "string" then return end
	local printer = AceLibrary("AceConsole-2.0")
	local result = {}
	for k,v in pairs(_G) do
		local secure, tainter = issecurevariable(k)
		if not secure and tainter and tainter:find(addon) then
			table.insert(result, tostring(k))
		end
	end
	if #result > 0 then
		table.sort(result)
		printer:Print("Globals found for " .. addon .. ":")
		printer:Print(table.concat(result, ", "))
	else
		printer:Print("No taint found for " .. addon .. ".")
	end
end

local justUnregistered = nil
local function clearJustUnregistered() justUnregistered = nil end
function BugSack:BugGrabber_AddonActionEventsRegistered()
	if self:GetFilter() and not justUnregistered then
		BugGrabber:UnregisterAddonActionEvents()
		justUnregistered = true
		self:ScheduleEvent(clearJustUnregistered, 10)
	end
end

do
	local errors = {}
	function BugSack:GetErrors(which)
		if type(which) ~= "string" and type(which) ~= "number" then return end
		for i in ipairs(errors) do errors[i] = nil end

		local db = BugGrabber:GetDB()
		if type(which) == "number" then
			for i, e in ipairs(db) do
				if which == err.session then
					table.insert(errors, e)
				end
			end
		else
			local cs = BugGrabberDB.session
			if which == "received" then
				return receivedErrors
			elseif which == "current" then
				local current = #db
				if current ~= 0 and db[current].session == cs then
					table.insert(errors, db[current])
				end
			else
				for i, e in ipairs(db) do
					if (which == "all")
					or (which == "session" and cs == tonumber(e.session))
					or (which == "previous" and cs - 1 == tonumber(e.session)) then
						table.insert(errors, e)
					end
				end
			end
		end
		return errors
	end
end

function BugSack:GetFilter()
	return self.db.profile.filterAddonMistakes
end

function BugSack:ToggleFilter()
	self.db.profile.filterAddonMistakes = not self.db.profile.filterAddonMistakes
	if not self.db.profile.filterAddonMistakes and not isEventsRegistered then
		BugGrabber.RegisterCallback(self, "BugGrabber_EventGrabbed", "OnError")
		isEventsRegistered = true
		BugGrabber:RegisterAddonActionEvents()
	elseif self.db.profile.filterAddonMistakes and isEventsRegistered then
		BugGrabber.UnregisterCallback(self, "BugGrabber_EventGrabbed")
		isEventsRegistered = nil
		BugGrabber:UnregisterAddonActionEvents()
	end
end

function BugSack:ListErrors(which, nr)
	-- Have to work through some oddities in AceConsole et.al.
	if type(nr) == "string" then nr = tonumber(nr) end
	if (which == "ListErrors" or which == "number") then which = nr end

	local bugs = self:GetErrors(which)
	if not bugs or #bugs == 0 then
		print(L["You have no errors, yay!"])
		return
	end

	print(L["List of errors:"])
	for i, e in ipairs(bugs) do
		print(("%d. %s"):format(i, self:FormatError(e)))
	end
end

function BugSack:ShowFrame(which, nr)
	-- Have to work through some oddities in AceConsole et.al.
	if type(nr) == "string" then nr = tonumber(nr) end
	if (which == "ShowFrame" or which == "number") then which = nr end

	sackErrors = self:GetErrors(which)
	sackType = which
	sackMax = sackErrors and #sackErrors or 0

	if nr then
		sackCurrent = math.min(sackMax, math.abs(nr))
	else
		sackCurrent = math.min(sackMax, 1)
	end
	self:UpdateFrameText()
end

function BugSack:UpdateFrameText()
	showErrorFrame()

	local caption = nil

	if sackCurrent == 0 then
		sackText = L["You have no errors, yay!"]
		caption = L["No errors found"]
	else
		sackText = self:FormatError(sackErrors[sackCurrent])
		if GetLocale() == "koKR" then
			caption = L["Error %d of %d"]:format(sackMax, sackCurrent)
		else
			caption = L["Error %d of %d"]:format(sackCurrent, sackMax)
		end
	end

	if sackType == "current" then
		caption = caption .. L[" (viewing last error)"]
	elseif sackType == "session" then
		caption = caption .. L[" (viewing session errors)"]
	elseif sackType == "previous" then
		caption = caption .. L[" (viewing previous session errors)"]
	elseif sackType == "all" then
		caption = caption .. L[" (viewing all errors)"]
	elseif sackType == "received" then
		caption = caption .. L[" (viewing errors from %s)"]:format(receivedFrom)
	else
		caption = caption .. L[" (viewing errors for session %d)"]:format(sackType)
	end
	_G.BugSackErrorText2:SetText(caption)

	_G.BugSackFrameScrollText2:SetText(sackText)

	if sackCurrent >= sackMax then
		_G.BugSackNextButton2:Disable()
		_G.BugSackLastButton2:Disable()
	else
		_G.BugSackNextButton2:Enable()
		_G.BugSackLastButton2:Enable()
	end

	if sackCurrent <= 1 then
		_G.BugSackPrevButton2:Disable()
		_G.BugSackFirstButton2:Disable()
	else
		_G.BugSackPrevButton2:Enable()
		_G.BugSackFirstButton2:Enable()
	end
end

function BugSack:FormatError(err)
	local m = err.message
	if type(m) == "table" then
		m = table.concat(m, "")
	end
	return string.format("|cff999999[%s-%d-x%d]|r: %s", err.time or "Unknown", err.session or -1, err.counter or -1, self:ColorError(m or ""))
end

function BugSack:ColorError(err)
	local ret = err
	ret = ret:gsub("|([^chHr])", "||%1") -- pipe char
	ret = ret:gsub("|$", "||") -- pipe char
	ret = ret:gsub("\nLocals:\n", "\n|cFFFFFFFFLocals:|r\n")
	ret = ret:gsub("[Ii][Nn][Tt][Ee][Rr][Ff][Aa][Cc][Ee]\\[Aa][Dd][Dd][Oo][Nn][Ss]\\", "")
	ret = ret:gsub("%{\n +%}", "{}") -- locals: empty table spanning lines
	ret = ret:gsub("([ ]-)([%a_][%a_%d]+) = ", "%1|cffffff80%2|r = ") -- local
	ret = ret:gsub("= (%d+)\n", "= |cffff7fff%1|r\n") -- locals: number
	ret = ret:gsub("<function>", "|cffffea00<function>|r") -- locals: function
	ret = ret:gsub("<table>", "|cffffea00<table>|r") -- locals: table
	ret = ret:gsub("= nil\n", "= |cffff7f7fnil|r\n") -- locals: nil
	ret = ret:gsub("= true\n", "= |cffff9100true|r\n") -- locals: true
	ret = ret:gsub("= false\n", "= |cffff9100false|r\n") -- locals: false
	ret = ret:gsub("= \"([^\n]+)\"\n", "= |cff00ff00\"%1\"|r\n") -- locals: string
	ret = ret:gsub("defined %@(.-):(%d+)", "@ |cffeda55f%1|r:|cff00ff00%2|r:") -- Files/Line Numbers of locals
	ret = ret:gsub("\n(.-):(%d+):", "\n|cffeda55f%1|r:|cff00ff00%2|r:") -- Files/Line Numbers
	ret = ret:gsub("%-%d+%p+.-%\\", "|cffffff00%1|cffeda55f") -- Version numbers
	ret = ret:gsub("%(.-%)", "|cff999999%1|r") -- Parantheses
	ret = ret:gsub("([`'])(.-)([`'])", "|cff8888ff%1%2%3|r") -- Other quotes
	return ret
end

function BugSack:ScriptBug()
	RunScript(L["BugSack generated this fake error."])
end

function BugSack:AddonBug()
	self:BugGeneratedByBugSack()
end

function BugSack:Reset()
	BugGrabber:Reset()
	print(L["All errors were wiped."])

	if BugSackFu then
		BugSackFu:Reset()
		BugSackFu:Update()
	elseif BugSackLDB then
		BugSackLDB:Update()
	end
end

-- The Error catching function.
do
	local lastError = nil
	function BugSack:OnError()
		if not lastError or GetTime() > (lastError + 2) then
			if media then
				local sound = media:Fetch("sound", self.db.profile.soundMedia) or "Interface\\AddOns\\BugSack\\Media\\error.wav"
				PlaySoundFile(sound)
			elseif not self.db.profile.mute then
				PlaySoundFile("Interface\\AddOns\\BugSack\\Media\\error.wav")
			end
			if self.db.profile.auto then
				self:ShowFrame("current")
			end
			if self.db.profile.chatframe then
				print(L["An error has been recorded."])
			end
			lastError = GetTime()
		end
		if BugSackLDB then
			BugSackLDB:Update()
		end
	end
end

-- Sends the current session errors to another player using AceComm-3.0
function BugSack:SendBugsToUser(player)
	if type(player) ~= "string" or player:trim():len() < 2 then
		error("Player needs to be a valid string.")
	end

	local errors = self:GetErrors("session")
	if not errors or #errors == 0 then return end
	local sz = self:Serialize(errors)
	self:SendCommMessage("BugSack", sz, "WHISPER", player, "BULK")

	print(L["%d errors has been sent to %s. He must have BugSack to be able to read them."]:format(#errors, player))
end

function BugSack:OnBugComm(prefix, message, distribution, sender)
	if prefix ~= "BugSack" then return end

	local good, deSz = self:Deserialize(message)
	if not good then
		print("Failure to deserialize incoming data from " .. sender .. ".")
		return
	end
	
	receivedErrors = deSz
	receivedFrom = sender

	print(L["You've received %d errors from %s, you can show them with /bugsack show received."]:format(#deSz, sender))
end

-- vim:set ts=4:

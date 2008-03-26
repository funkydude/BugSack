--
-- $Id$
--
-- Developers: Rowne, Ramble, industrial, Fritti, kergoth, Rabbit
-- Testers: Ramble, Sariash
--
-- Credits to AceGUI & LuaPad for the scrollbar knowledge.
--

--[[

BugSack, a World of Warcraft addon that interfaces with the !BugGrabber addon
to present errors in a nice way.
Copyright (C) 2007 The BugSack Team.

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

local L = AceLibrary("AceLocale-2.2"):new("BugSack")
local media = AceLibrary:HasInstance("LibSharedMedia-2.0") and AceLibrary("LibSharedMedia-2.0") or nil

BugSack = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "AceComm-2.0")

local BugSack = BugSack
local BugGrabber = _G.BugGrabber
local BugGrabberDB = _G.BugGrabberDB

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
			get = BugGrabber.GetLimit,
			set = BugGrabber.SetLimit,
			min = 10,
			max = MAX_BUGGRABBER_ERRORS or 1000,
			step = 10,
			order = 102,
		},
		save = {
			type = "toggle",
			name = L["Save errors"],
			desc = L["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."],
			get = BugGrabber.GetSave,
			set = BugGrabber.ToggleSave,
			order = 103,
		},
		reset = {
			type = "execute",
			name = L["Clear errors"],
			desc = L["Clear out the errors database."],
			func = "Reset",
			order = 104,
			disabled = function() return #BugSack:GetErrors("all") == 0 end,
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
		msg = {
			type = "toggle",
			name = L["Errors to chatframe"],
			desc = L["Print the full error message to the chat frame instead of just a warning."],
			get = function() return BugSack.db.profile.showmsg end,
			set = function(v) BugSack.db.profile.showmsg = v end,
			order = 202,
		},
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
			desc = L["Sends your current session bugs to another user. Only works if both you and the recipient has an instance of AceComm-2.0 and BugSack loaded."],
			get = false,
			set = "SendBugsToUser",
			usage = L["<player name>"],
			validate = function(v) return type(v) == "string" and v:trim():len() > 0 end,
			disabled = function() return #BugSack:GetErrors("session") == 0 end,
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
			get = BugGrabber.IsThrottling,
			set = BugGrabber.UseThrottling,
			order = 303,
		}
	}
}

function BugSack:OnInitialize()
	local revision = tonumber(string.sub("$Revision$", 12, -3)) or 1
	if not self.version then self.version = "2.x.x" end
	self.version = self.version .. "." .. revision
	self.revision = revision

	_G.BUGSACK_REVISION = self.revision
	_G.BUGSACK_VERSION = self.version

	self:RegisterDB("BugSackDB")
	self:RegisterDefaults("profile", {
		mute = nil,
		auto = nil,
		showmsg = nil,
		chatframe = nil,
		filterAddonMistakes = true,
		soundMedia = "BugSack: Fatality",
	})
	self:RegisterChatCommand("/bugsack", "/bs", self.options, "BUGSACK")

	-- Swipe the load errors from BugGrabber if there were any
	if BugGrabber and BugGrabber.bugsackErrors then
		for _, err in pairs(BugGrabber.bugsackErrors) do self:OnError(err) end
		BugGrabber.bugsackErrors = nil
	end

	self:SetCommPrefix("BugSack")
	self:SetDefaultCommPriority("BULK")
	self:RegisterComm("BugSack", "WHISPER", "OnBugComm")

	if media then
		media:Register("sound", "BugSack: Fatality", "Interface\\AddOns\\BugSack\\error.wav")
		self.options.args.soundMedia.validate = media:List("sound")
	end
end

function BugSack:OnEnable()
	-- Set up our error event handler
	self:RegisterBucketEvent("BugGrabber_BugGrabbed", 2, "OnError")
	self:RegisterEvent("BugGrabber_AddonActionEventsRegistered")

	if not self:GetFilter() then
		self:RegisterBucketEvent("BugGrabber_EventGrabbed", 2, "OnError")
		BugGrabber.RegisterAddonActionEvents()
	else
		BugGrabber.UnregisterAddonActionEvents()
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
		BugGrabber.UnregisterAddonActionEvents()
		justUnregistered = true
		self:ScheduleEvent(clearJustUnregistered, 10)
	end
end

function BugSack:GetErrors(which)
	local errs = {}

	if type(which) ~= "string" and type(which) ~= "number" then
		return errs
	end

	local db = BugGrabber.GetDB()

	if type(which) == "number" then
		for _, err in pairs(db) do
			if which == err.session then
				table.insert(errs, err)
			end
		end
	else
		local cs = BugGrabberDB.session
		if which == "received" then
			return receivedErrors
		elseif which == "current" then
			local current = #db
			if current ~= 0 and db[current].session == cs then
				table.insert(errs, db[current])
			end
		else
			for _, err in pairs(db) do
				if (which == "all")
				or (which == "session" and cs == tonumber(err.session))
				or (which == "previous" and cs - 1 == tonumber(err.session)) then
					table.insert(errs, err)
				end
			end
		end
	end
	return errs
end

function BugSack:GetFilter()
	return self.db.profile.filterAddonMistakes
end

function BugSack:ToggleFilter()
	self.db.profile.filterAddonMistakes = not self.db.profile.filterAddonMistakes
	if not self.db.profile.filterAddonMistakes and not self:IsBucketEventRegistered("BugGrabber_EventGrabbed") then
		self:RegisterBucketEvent("BugGrabber_EventGrabbed", 2, "OnError")
		BugGrabber.RegisterAddonActionEvents()
	elseif self.db.profile.filterAddonMistakes and self:IsBucketEventRegistered("BugGrabber_EventGrabbed") then
		self:UnregisterBucketEvent("BugGrabber_EventGrabbed")
		BugGrabber.UnregisterAddonActionEvents()
	end
end

function BugSack:ListErrors(which, nr)
	-- Have to work through some oddities in AceConsole et.al.
	if type(nr) == "string" then nr = tonumber(nr) end
	if (which == "ListErrors" or which == "number") then which = nr end

	local errs = self:GetErrors(which)
	if #errs == 0 then
		self:Print(L["You have no errors, yay!"])
		return
	end

	self:Print(L["List of errors:"])
	local i, err
	for i, err in ipairs(errs) do
		self:Print("%d. %s", i, self:FormatError(err))
	end
end

function BugSack:ShowFrame(which, nr)
	-- Have to work through some oddities in AceConsole et.al.
	if type(nr) == "string" then nr = tonumber(nr) end
	if (which == "ShowFrame" or which == "number") then which = nr end

	sackType = which
	sackErrors = self:GetErrors(which)
	sackMax = #sackErrors

	if nr then
		sackCurrent = math.min(sackMax, math.abs(nr))
	else
		sackCurrent = math.min(sackMax, 1)
	end
	self:UpdateFrameText()

	_G.BugSackFrame:Show()
end

function BugSack:UpdateFrameText()
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
	_G.BugSackErrorText:SetText(caption)

	if sackText and sackText:len() > 4000 then
		sackText = sackText:sub(1, 3950) .. L[" (... more ...)"]
	end
	_G.BugSackFrameScrollText:SetText(sackText)

	if sackCurrent >= sackMax then
		_G.BugSackNextButton:Disable()
		_G.BugSackLastButton:Disable()
	else
		_G.BugSackNextButton:Enable()
		_G.BugSackLastButton:Enable()
	end

	if sackCurrent <= 1 then
		_G.BugSackPrevButton:Disable()
		_G.BugSackFirstButton:Disable()
	else
		_G.BugSackPrevButton:Enable()
		_G.BugSackFirstButton:Enable()
	end
end

function BugSack:OnFirstClick()
	sackCurrent = math.min(sackMax, 1)
	self:UpdateFrameText()
end

function BugSack:OnPrevClick()
	sackCurrent = sackCurrent - 1
	self:UpdateFrameText()
end

function BugSack:OnLastClick()
	sackCurrent = sackMax
	self:UpdateFrameText()
end

function BugSack:OnNextClick()
	sackCurrent = sackCurrent + 1
	self:UpdateFrameText()
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
	ret = ret:gsub("%-%d+%p+.-%\\", "|cffffff00%1|cffeda55f") -- Version numbers
	ret = ret:gsub("%(.-%)", "|cff999999%1|r") -- Parantheses
	ret = ret:gsub("([`'\"])(.-)([`'\"])", "|cff8888ff%1%2%3|r") -- Quotes
	ret = ret:gsub("^(.-):", "|cffeda55f%1|r:") -- First file after time and date
	return ret
end

function BugSack:ScriptBug()
	self:Print(L["An error has been generated."])
	RunScript(L["BugSack generated this fake error."])
end

function BugSack:AddonBug()
	self:Print(L["An error has been generated."])
	self:BugGeneratedByBugSack()
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
	if media then
		local sound = media:Fetch("sound", self.db.profile.soundMedia) or "Interface\\AddOns\\BugSack\\error.wav"
		PlaySoundFile(sound)
	elseif not self.db.profile.mute then
		PlaySoundFile("Interface\\AddOns\\BugSack\\error.wav")
	end

	if self.db.profile.auto then
		self:ShowFrame("current")
	end

	local firstError = nil
	local num = 0
	local k, v
	for k, v in pairs(err) do
		num = num + 1
		if not firstError then firstError = k end
	end
	if self.db.profile.chatframe and self.db.profile.showmsg and num == 1 then
		self:Print(self:FormatError(firstError))
	elseif self.db.profile.chatframe then
		if num > 1 then
			self:Print(L["%d errors have been recorded."]:format(num))
		else
			self:Print(L["An error has been recorded."])
		end
	end

	if self:IsEventRegistered("BugGrabber_BugGrabbed") and BugSackFu and type(BugSackFu.IsActive) == "function" and BugSackFu:IsActive() then
		_G.BugSackFu:UpdateDisplay()
	end
end

-- Sends the current session errors to another player using AceComm-2.0
function BugSack:SendBugsToUser(player)
	if type(player) ~= "string" or player:trim():len() < 2 then
		error("Player needs to be a valid string.")
	end

	local errors = self:GetErrors("session")
	if #errors == 0 then
		error("Can't send 0 errors.")
	end

	self:SendCommMessage("WHISPER", player, errors)

	self:Print(L["%d errors has been sent to %s. If he does not have both BugSack and AceComm-2.0, he will not be able to read them."]:format(#errors, player))
end

function BugSack:OnBugComm(prefix, sender, distribution, bugs)
	receivedErrors = bugs
	receivedFrom = sender

	self:Print(L["You've received %d errors from %s, you can show them with /bugsack show received."]:format(#bugs, sender))
end

-- Editbox handler

function BugSack:OnTextChanged()
	if this:GetText() ~= sackText then
		this:SetText(sackText)
	end
	local s = _G.BugSackFrameScrollScrollBar
	this:GetParent():UpdateScrollChildRect()
	local _, m = s:GetMinMaxValues()
	if m > 0 and this.max ~= m then
		this.max = m
		s:SetValue(m)
	end
end

-- vim:set ts=4:

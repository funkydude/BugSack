local addonName, addon = ...

-----------------------------------------------------------------------
-- Make sure we are prepared
--

local function print(...)
	_G.print("|cFF33FF99BugSack:|r", ...)
end
if not LibStub then
	print("BugSack requires LibStub.")
	return
end

local L = addon.L
local BugGrabber = BugGrabber
if not BugGrabber then
	local f = CreateFrame("Frame")
	local Timer = C_Timer.After
	f:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
		Timer(0, function() -- Timers aren't fully functional until 1 frame after loading is done, this ensures the message stays onscreen for 20 seconds as desired
			print(L.bugGrabberMissing)
			if RaidWarningUtil and RaidWarningUtil.AddMessage then
				RaidWarningUtil.AddMessage(L.bugGrabberMissing, { r = 1, g = 1, b = 1 }, 20)
			else
				RaidNotice_AddMessage(RaidBossEmoteFrame, L.bugGrabberMissing, { r = 1, g = 1, b = 1 }, 20)
			end
		end)
	end)
	f:RegisterEvent("LOADING_SCREEN_DISABLED")
	return
end

-- We seem fine, let the world access us.
_G[addonName] = addon
addon.healthCheck = true

-- Sound
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
LibSharedMedia:Register("sound", "BugSack: Fatality", "Interface\\AddOns\\BugSack\\Media\\error.ogg")

-----------------------------------------------------------------------
-- Utility
--

local onError
do
	local prevError = GetTime()-10
	local errorList = {}
	function onError(_, errorID)
		local t = GetTime()
		if t - prevError > 3 and (not errorList[errorID] or t - errorList[errorID] > 30) then
			errorList[errorID] = t
			prevError = t
			if not addon.db.mute then
				local sound = LibSharedMedia:Fetch("sound", addon.db.soundMedia)
				if addon.db.useMaster then
					PlaySoundFile(sound, "Master")
				else
					PlaySoundFile(sound)
				end
			end
			if addon.db.chatframe then
				print(L["There's a bug in your soup!"])
			end
		end
		-- If the frame is shown, we need to update it.
		if (addon.db.auto and not InCombatLockdown()) or (BugSackFrame and BugSackFrame:IsShown()) then
			addon:OpenSack()
		end
		addon:UpdateDisplay()
	end
end

-----------------------------------------------------------------------
-- API
--

function addon:UpdateDisplay()
	-- noop, hooked by displays
end

function addon:GetErrors(sessionId)
	-- XXX I've never liked this function, maybe a BugGrabber redesign is in order,
	-- XXX where we have one subtable in the DB per session ID.
	if sessionId then
		local errors = {}
		local db = BugGrabber:GetDB()
		for i, e in next, db do
			if sessionId == e.session then
				errors[#errors + 1] = e
			end
		end
		return errors
	else
		return BugGrabber:GetDB()
	end
end

do
	local function colorStack(ret)
		ret = ret:gsub("Interface/AddOns/", "")
		ret = ret:gsub("^%.%.%.[^/]+/AddOns/", "")
		ret = ret:gsub("^%.%.%.[^/]*dOns/", "")
		ret = ret:gsub("<([^>]+:)(%d+)>", "|cffffea00<%1|cff00ff00%2|r>|r") -- File paths wrapped in <> e.g. <Addon/Module.lua:188>
		ret = ret:gsub("%[([^%]]+)%]:(%d+):", "|cffffea00[%1]:|cff00ff00%2|r:|r") -- File paths wrapped in [] e.g. [Addon/Module.lua]:69:
		ret = ret:gsub("\"[^\"\n]-\"", "|cff8888ff%0|r") -- Quotes ""
		ret = ret:gsub("'[^'\n ]-'", "|cff8888ff%0|r") -- Quotes ''
		ret = ret:gsub("`[^`\n ]-`", "|cff8888ff%0|r") -- Quotes ``
		ret = ret:gsub("'%(for generator%)'", "|cff8888ff%0|r") -- Quote '(for generator)'
		return ret
	end
	addon.ColorStack = colorStack

	local function colorLocals(ret)
		ret = ret:gsub("|(%a)", "||%1"):gsub("|$", "||") -- Pipes
		ret = ret:gsub("> %@(.-):(%d+)", "> @|cffeda55f%1|r:|cff00ff00%2|r") -- Files/Line Numbers of locals
		ret = ret:gsub("(\n +)([^=\"\n]+)=", "%1|cffffff80%2|r=") -- Table keys
		ret = ret:gsub("=(%-?%d%d*%.?%d*)\n", "=|cffff7fff%1|r\n") -- locals: number (5 or -5 or -5.5)
		ret = ret:gsub("=nil\n", "=|cffff7f7fnil|r\n") -- locals: nil
		ret = ret:gsub("=true\n", "=|cffff9100true|r\n") -- locals: true
		ret = ret:gsub("=false\n", "=|cffff9100false|r\n") -- locals: false
		ret = ret:gsub("=<([^>]+)>", "=|cffffea00<%1>|r") -- Things wrapped in <>
		return ret
	end
	addon.ColorLocals = colorLocals

	local errorFormat = "%dx %s"
	local errorFormatLocals = "%dx %s\n\nLocals:\n%s"
	local EscapeDecimalNonPrintables = C_StringUtil and C_StringUtil.EscapeDecimalNonPrintables or function(err) return err end
	function addon:FormatError(err)
		if not err.locals then
			local message = EscapeDecimalNonPrintables(err.message)
			local stack = err.stack and EscapeDecimalNonPrintables(err.stack) or ""

			local s = colorStack(message .. "\n" .. stack)
			return errorFormat:format(err.counter or -1, s)
		else
			local message = EscapeDecimalNonPrintables(err.message)
			local stack = err.stack and EscapeDecimalNonPrintables(err.stack) or ""
			local locals = EscapeDecimalNonPrintables(err.locals)

			local s = colorStack(message .. "\n" .. stack)
			local l = colorLocals(locals)
			return errorFormatLocals:format(err.counter or -1, s, l)
		end
	end
end

function addon:Reset()
	BugGrabber:Reset()
	self:UpdateDisplay()
	print(L["All stored bugs have been exterminated painfully."])
end

-- Sends the current session errors to another player using AceComm-3.0
function addon:SendBugsToUser(player, session)
	if type(player) ~= "string" or player:trim():len() < 2 then
		error(L["Player needs to be a valid name."])
	end
	if not self.Serialize then
		return
	end

	local errors = self:GetErrors(session)
	if not errors or #errors == 0 then
		return
	end
	local sz = self:Serialize(errors)
	self:SendCommMessage("BugSack", sz, "WHISPER", player, "BULK")

	print(L["%d bugs have been sent to %s. He must have BugSack to be able to examine them."]:format(#errors, player))
end

function addon:OnBugComm(prefix, message, _, sender)
	if prefix ~= "BugSack" or not self.Deserialize then
		return
	end

	local good, deSz = self:Deserialize(message)
	if not good then
		print(L["Failure to deserialize incoming data from %s."]:format(sender))
		return
	end

	-- Store recieved errors in the current session database with a source set to the sender
	local s = BugGrabber:GetSessionId()
	for i, err in next, deSz do
		err.source = sender
		err.session = s
		BugGrabber:StoreError(err)
	end

	print(L["You've received %d bugs from %s."]:format(#deSz, sender))

	wipe(deSz)
	deSz = nil
end

--[[

do
	local commFormat = "1#%s#%s"
	local function transmit(command, target, argument)
		SendAddonMessage("BugGrabber", commFormat:format(command, argument), "WHISPER", target)
	end

	local retrievedErrors = {}
	function addon:GetErrorByPlayerAndID(player, id)
		if player == playerName then return self:GetErrorByID(id) end
		-- This error was linked by someone else, we need to retrieve it from them
		-- using the addon communication channel.
		if retrievedErrors[id] then return retrievedErrors[id] end
		transmit("FETCH", player, id)
		print(L.ERROR_INCOMING:format(id, player))
	end

	local fakeAddon, comm, serializer = nil, nil, nil
	local function commBugCatcher(prefix, message, distribution, sender)
		local good, deSz = fakeAddon:Deserialize(message)
		if not good then
			print("damnit")
			return
		end
		retrievedErrors[deSz.originalId] = deSz

	end
	local function hasTransmitFacilities()
		if fakeAddon then return true end
		if not serializer then serializer = LibStub("AceSerializer-3.0", true) end
		if not comm then comm = LibStub("AceComm-3.0", true) end
		if comm and serializer then
			fakeAddon = {}
			comm:Embed(fakeAddon)
			serializer:Embed(fakeAddon)
			fakeAddon:RegisterComm("BGBug", commBugCatcher)
			return true
		end
	end

	function frame:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
		if prefix ~= "BugGrabber" then return end
		local version, command, argument = strsplit("#", message)
		if tonumber(version) ~= 1 or not command then return end
		if command == "FETCH" then
			local errorObject = addon:GetErrorByID(argument)
			if errorObject then
				if hasTransmitFacilities() then
					errorObject.originalId = argument
					local sz = fakeAddon:Serialize(errorObject)
					fakeAddon:SendCommMessage("BGBug", sz, "WHISPER", sender, "BULK")
				else
					-- We can only transmit a gimped and sanitized message
					transmit("BUG", sender, errorObject.message:sub(1, 240):gsub("#", ""))
				end
			else
				transmit("FAIL", sender, argument)
			end
		elseif command == "FAIL" then
			print(L.ERROR_FAILED_FETCH:format(argument, sender))
		elseif command == "BUG" then
			print(L.CRIPPLED_ERROR:format(sender, argument))
		end
	end
end]]

-----------------------------------------------------------------------
-- Initialize
--

do
	SlashCmdList.BugSack = function()
		addon:OpenSack()
	end
	SLASH_BugSack1 = "/bugsack"

	local ac = LibStub("AceComm-3.0", true)
	if ac then
		ac:Embed(addon)
	end
	local as = LibStub("AceSerializer-3.0", true)
	if as then
		as:Embed(addon)
	end

	local popup = _G.StaticPopupDialogs
	if type(popup) ~= "table" then
		popup = {}
	end
	if type(popup.BugSackSendBugs) ~= "table" then
		popup.BugSackSendBugs = {
			text = L["Send all bugs from the currently viewed session (%d) in the sack to the player specified below."],
			button1 = L["Send"],
			button2 = CLOSE,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			hasEditBox = true,
			OnAccept = function(self, data)
				local recipient = self:GetEditBox():GetText()
				addon:SendBugsToUser(recipient, data)
			end,
			OnShow = function(self)
				self:GetButton1():Disable()
			end,
			EditBoxOnTextChanged = function(self)
				local t = self:GetText()
				local dialog = self:GetParent()
				if t:len() > 2 and not t:find("%s") then
					dialog:GetButton1():Enable()
				else
					dialog:GetButton1():Disable()
				end
			end,
			enterClicksFirstButton = true,
			--OnCancel = function() show() end, -- Need to wrap it so we don't pass |self| as an error argument to show().
			preferredIndex = 1,
		}
	end

	if type(BugSackDB) ~= "table" then
		BugSackDB = {}
	end
	local sv = BugSackDB
	if type(sv.mute) ~= "boolean" then
		sv.mute = false
	end
	if type(sv.auto) ~= "boolean" then
		sv.auto = false
	end
	if type(sv.chatframe) ~= "boolean" then
		sv.chatframe = false
	end
	if type(sv.soundMedia) ~= "string" then
		sv.soundMedia = "BugSack: Fatality"
	end
	if not LibSharedMedia:IsValid("sound", sv.soundMedia) then -- Don't immediately reset, wait for all addons to load their media
		local f = CreateFrame("Frame")
		f:SetScript("OnEvent", function(self, event)
			self:UnregisterEvent(event)
			self:SetScript("OnEvent", nil)
			if not LibSharedMedia:IsValid("sound", sv.soundMedia) then
				sv.soundMedia = "BugSack: Fatality"
			end
		end)
		f:RegisterEvent("PLAYER_LOGIN")
	end
	if type(sv.fontSize) ~= "string" or (
		sv.fontSize ~= "GameFontHighlightSmall" and
		sv.fontSize ~= "GameFontHighlight" and
		sv.fontSize ~= "GameFontHighlightMedium" and
		sv.fontSize ~= "GameFontHighlightLarge"
	) then
		sv.fontSize = "GameFontHighlight"
	end
	if type(sv.altwipe) ~= "boolean" then
		sv.altwipe = false
	end
	if type(sv.useMaster) ~= "boolean" then
		sv.useMaster = false
	end
	addon.db = sv

	-- Make sure we grab any errors fired before bugsack loaded.
	local session = addon:GetErrors(BugGrabber:GetSessionId())
	if #session > 0 then
		if not addon.db.mute then
			local sound = LibSharedMedia:Fetch("sound", addon.db.soundMedia)
			if addon.db.useMaster then
				PlaySoundFile(sound, "Master")
			else
				PlaySoundFile(sound)
			end
		end
		if addon.db.chatframe then
			print(L["There's a bug in your soup!"])
		end
		if addon.db.auto then
			addon:OpenSack()
		end
		addon:UpdateDisplay()
	end

	if addon.RegisterComm then
		addon:RegisterComm("BugSack", "OnBugComm")
	end

	-- Set up our error event handler
	EventRegistry:RegisterCallback("BugGrabber.BugGrabbed", onError, {})
	EventRegistry:TriggerEvent("BugGrabber.DisplayRegistered")
end

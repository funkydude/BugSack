local addonName, addon = ...

-----------------------------------------------------------------------
-- Make sure we are prepared
--

local function print(...) _G.print("|cff259054BugSack:|r", ...) end
if not LibStub then
	print("BugSack requires LibStub.")
	return
end

local L = nil
local AL = LibStub:GetLibrary("AceLocale-3.0", true)
if AL then
	if type(addon.LoadTranslations) == "function" then
		addon:LoadTranslations(AL)
		addon.LoadTranslations = nil
	end
	L = AL:GetLocale(addonName)
	AL = nil
else
	L = setmetatable({}, {__index = function(t,k) t[k] = k return k end })
end
addon.L = L

local BugGrabber = BugGrabber
if not BugGrabber then
	local msg = L["|cffff4411BugSack requires the |r|cff44ff44!BugGrabber|r|cffff4411 addon, which you can download from the same place you got BugSack. Happy bug hunting!|r"]
	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", function()
		RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1, g=0.3, b=0.1})
		print(msg)
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", nil)
		f = nil
	end)
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	return
end

-- We seem fine, let the world access us.
_G[addonName] = addon
addon.healthCheck = true

-----------------------------------------------------------------------
-- Utility
--

do
	-- bah this should be local but we need it in config.lua
	local media = nil
	function addon:EnsureLSM3()
		if media then return media end
		media = LibStub("LibSharedMedia-3.0", true)
		if media then
			media:Register("sound", "BugSack: Fatality", "Interface\\AddOns\\BugSack\\Media\\error.ogg")
		end
		return media
	end
end

local onError
do
	local lastError = nil
	function onError(event, errorObject)
		if not lastError or GetTime() > (lastError + 2) then
			local media = addon:EnsureLSM3()
			if media then
				local sound = media:Fetch("sound", addon.db.soundMedia) or "Interface\\AddOns\\BugSack\\Media\\error.ogg"
				PlaySoundFile(sound)
			elseif not addon.db.mute then
				PlaySoundFile("Interface\\AddOns\\BugSack\\Media\\error.ogg")
			end
			if addon.db.chatframe then
				print(L["There's a bug in your soup!"])
			end
			lastError = GetTime()
		end
		-- If the frame is shown, we need to update it.
		if addon.db.auto or BugSackFrame and BugSackFrame:IsShown() then
			addon:OpenSack(errorObject)
		end
		addon:UpdateDisplay()
	end
end

-----------------------------------------------------------------------
-- Event handling
--

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

function eventFrame:ADDON_LOADED(loadedAddon)
	if loadedAddon ~= addonName then return end
	self:UnregisterEvent("ADDON_LOADED")

	local ac = LibStub("AceComm-3.0", true)
	if ac then ac:Embed(addon) end
	local as = LibStub("AceSerializer-3.0", true)
	if as then as:Embed(addon) end

	local popup = _G.StaticPopupDialogs
	if type(popup) ~= "table" then popup = {} end
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
				local recipient = self.editBox:GetText()
				addon:SendBugsToUser(recipient, data)
			end,
			OnShow = function(self)
				self.button1:Disable()
			end,
			EditBoxOnTextChanged = function(self, data)
				local t = self:GetText()
				if t:len() > 2 and not t:find("%s") then
					self:GetParent().button1:Enable()
				else
					self:GetParent().button1:Disable()
				end
			end,
			enterClicksFirstButton = true,
			--OnCancel = function() show() end, -- Need to wrap it so we don't pass |self| as an error argument to show().
			preferredIndex = STATICPOPUP_NUMDIALOGS,
		}
	end

	if type(BugSackDB) ~= "table" then BugSackDB = {} end
	local sv = BugSackDB
	sv.profileKeys = nil
	sv.profiles = nil
	if type(sv.mute) ~= "boolean" then sv.mute = false end
	if type(sv.auto) ~= "boolean" then sv.auto = false end
	if type(sv.chatframe) ~= "boolean" then sv.chatframe = false end
	if type(sv.filterAddonMistakes) ~= "boolean" then sv.filterAddonMistakes = true end
	if type(sv.soundMedia) ~= "string" then sv.soundMedia = "BugSack: Fatality" end
	if type(sv.fontSize) ~= "string" then sv.fontSize = "GameFontHighlight" end
	addon.db = sv

	addon:EnsureLSM3()

	self.ADDON_LOADED = nil
end

function eventFrame:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")

	-- Make sure we grab any errors fired before bugsack loaded.
	local session = addon:GetErrors(BugGrabber:GetSessionId())
	if #session > 0 then onError() end

	if addon.RegisterComm then
		addon:RegisterComm("BugSack", "OnBugComm")
	end

	-- Set up our error event handler
	BugGrabber.RegisterCallback(addon, "BugGrabber_BugGrabbed", onError)
	BugGrabber.RegisterCallback(addon, "BugGrabber_EventGrabbed", onError)

	if not addon:GetFilter() then
		BugGrabber:RegisterAddonActionEvents()
	else
		BugGrabber:UnregisterAddonActionEvents()
	end
	
	SlashCmdList.BugSack = function() InterfaceOptionsFrame_OpenToCategory(addonName) end
	SLASH_BugSack1 = "/bugsack"

	self.PLAYER_LOGIN = nil
end

-----------------------------------------------------------------------
-- API
--

function addon:UpdateDisplay()
	-- noop, hooked by displays
end

do
	local errors = {}
	function addon:GetErrors(sessionId)
		-- XXX I've never liked this function, maybe a BugGrabber redesign is in order,
		-- XXX where we have one subtable in the DB per session ID.
		if sessionId then
			wipe(errors)
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
end

function addon:GetFilter()
	return self.db.filterAddonMistakes
end

function addon:ToggleFilter()
	self.db.filterAddonMistakes = not self.db.filterAddonMistakes
	if not self.db.filterAddonMistakes then
		BugGrabber:RegisterAddonActionEvents()
	else
		BugGrabber:UnregisterAddonActionEvents()
	end
end

do
	local errorFormat = [[|cff999999%dx|r %s]]
	function addon:FormatError(err)
		local m = err.message
		if type(m) == "table" then
			m = table.concat(m, "")
		end
		return errorFormat:format(err.counter or -1, self:ColorError(m))
	end
end

function addon:ColorError(err)
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
	ret = ret:gsub("= \"([^\n]+)\"\n", "= |cff8888ff\"%1\"|r\n") -- locals: string
	ret = ret:gsub("defined %@(.-):(%d+)", "@ |cffeda55f%1|r:|cff00ff00%2|r:") -- Files/Line Numbers of locals
	ret = ret:gsub("\n(.-):(%d+):", "\n|cffeda55f%1|r:|cff00ff00%2|r:") -- Files/Line Numbers
	ret = ret:gsub("%-%d+%p+.-%\\", "|cffffff00%1|cffeda55f") -- Version numbers
	ret = ret:gsub("%(.-%)", "|cff999999%1|r") -- Parantheses
	ret = ret:gsub("([`'])(.-)([`'])", "|cff8888ff%1%2%3|r") -- Other quotes
	return ret
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
	if not self.Serialize then return end

	local errors = self:GetErrors(session)
	if not errors or #errors == 0 then return end
	local sz = self:Serialize(errors)
	self:SendCommMessage("BugSack", sz, "WHISPER", player, "BULK")

	print(L["%d bugs have been sent to %s. He must have BugSack to be able to examine them."]:format(#errors, player))
end

function addon:OnBugComm(prefix, message, distribution, sender)
	if prefix ~= "BugSack" or not self.Deserialize then return end

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


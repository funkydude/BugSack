
local addonName, addon = ...

-----------------------------------------------------------------------
-- Make sure we are prepared
--

local function print(...) _G.print("|cff259054BugSack:|r", ...) end
if not LibStub then
	print("BugSack requires LibStub.")
	return
end

local L = addon.L
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
			if not addon.db.mute then
				local media = addon:EnsureLSM3()
				if media then
					local sound = media:Fetch("sound", addon.db.soundMedia) or "Interface\\AddOns\\BugSack\\Media\\error.ogg"
					PlaySoundFile(sound)
				else
					PlaySoundFile("Interface\\AddOns\\BugSack\\Media\\error.ogg")
				end
			end
			if addon.db.chatframe then
				print(L["There's a bug in your soup!"])
			end
			lastError = GetTime()
		end
		-- If the frame is shown, we need to update it.
		if (addon.db.auto and not InCombatLockdown()) or (BugSackFrame and BugSackFrame:IsShown()) then
			addon:OpenSack(errorObject)
		end
		addon:UpdateDisplay()
	end
end

-----------------------------------------------------------------------
-- Event handling
--

local eventFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
eventFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
addon.frame = eventFrame

function eventFrame:ADDON_LOADED(loadedAddon)
	if loadedAddon ~= addonName then return end
	self:UnregisterEvent("ADDON_LOADED")
	if type(BugSackDB) ~= "table" then BugSackDB = {} end
	local sv = BugSackDB
	sv.profileKeys = nil
	sv.profiles = nil
	if type(sv.mute) ~= "boolean" then sv.mute = false end
	if type(sv.auto) ~= "boolean" then sv.auto = false end
	if type(sv.chatframe) ~= "boolean" then sv.chatframe = false end
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

	-- Set up our error event handler
	BugGrabber.RegisterCallback(addon, "BugGrabber_BugGrabbed", onError)

	SlashCmdList.BugSack = function()
		InterfaceOptionsFrame_OpenToCategory(addonName)
		InterfaceOptionsFrame_OpenToCategory(addonName)
	end
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

do
	local function colorStack(ret)
		ret = tostring(ret) or "" -- Yes, it gets called with nonstring from somewhere /mikk
		ret = ret:gsub("[%.I][%.n][%.t][%.e][%.r]face\\", "")
		ret = ret:gsub("%.?%.?%.?\\?AddOns\\", "")
		ret = ret:gsub("|([^chHr])", "||%1"):gsub("|$", "||") -- Pipes
		ret = ret:gsub("<(.-)>", "|cffffea00<%1>|r") -- Things wrapped in <>
		ret = ret:gsub("%[(.-)%]", "|cffffea00[%1]|r") -- Things wrapped in []
		ret = ret:gsub("([\"`'])(.-)([\"`'])", "|cff8888ff%1%2%3|r") -- Quotes
		ret = ret:gsub(":(%d+)([%S\n])", ":|cff00ff00%1|r%2") -- Line numbers
		ret = ret:gsub("([^\\]+%.lua)", "|cffffffff%1|r") -- Lua files
		return ret
	end
	addon.ColorStack = colorStack

	local function colorLocals(ret)
		ret = tostring(ret) or "" -- Yes, it gets called with nonstring from somewhere /mikk
		ret = ret:gsub("[%.I][%.n][%.t][%.e][%.r]face\\", "")
		ret = ret:gsub("%.?%.?%.?\\?AddOns\\", "")
		ret = ret:gsub("|(%a)", "||%1"):gsub("|$", "||") -- Pipes
		ret = ret:gsub("> %@(.-):(%d+)", "> @|cffeda55f%1|r:|cff00ff00%2|r") -- Files/Line Numbers of locals
		ret = ret:gsub("(%s-)([%a_%(][%a_%d%*%)]+) = ", "%1|cffffff80%2|r = ") -- Table keys
		ret = ret:gsub("= (%-?[%d%p]+)\n", "= |cffff7fff%1|r\n") -- locals: number
		ret = ret:gsub("= nil\n", "= |cffff7f7fnil|r\n") -- locals: nil
		ret = ret:gsub("= true\n", "= |cffff9100true|r\n") -- locals: true
		ret = ret:gsub("= false\n", "= |cffff9100false|r\n") -- locals: false
		ret = ret:gsub("= <(.-)>", "= |cffffea00<%1>|r") -- Things wrapped in <>
		return ret
	end
	addon.ColorLocals = colorLocals

	local errorFormat = "%dx %s\n\nLocals:\n%s"
	function addon:FormatError(err)
		local s = colorStack(tostring(err.message) .. "\n" .. tostring(err.stack))
		local l = colorLocals(tostring(err.locals))
		return errorFormat:format(err.counter or -1, s, l)
	end
end

function addon:Reset()
	BugGrabber:Reset()
	self:UpdateDisplay()
	print(L["All stored bugs have been exterminated painfully."])
end


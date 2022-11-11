
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


-- Sound
local media = LibStub("LibSharedMedia-3.0")
media:Register("sound", "BugSack: Fatality", "Interface\\AddOns\\"..addonName.."\\Media\\error.ogg")

-----------------------------------------------------------------------
-- Utility
--

local onError
do
	local lastError = nil
	function onError()
		if not lastError or GetTime() > (lastError + 2) then
			if not addon.db.mute then
				local sound = media:Fetch("sound", addon.db.soundMedia)
				if addon.db.useMaster then
					PlaySoundFile(sound, "Master")
				else
					PlaySoundFile(sound)
				end
			end
			if addon.db.chatframe then
				print(L["There's a bug in your soup!"])
			end
			lastError = GetTime()
		end
		-- If the frame is shown, we need to update it.
		if (addon.db.auto and not InCombatLockdown()) or (BugSackFrame and BugSackFrame:IsShown()) then
			addon:OpenSack()
		end
		addon:UpdateDisplay()
	end
end

-----------------------------------------------------------------------
-- Event handling
--

do
	local eventFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
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
				EditBoxOnTextChanged = function(self)
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
		if type(sv.soundMedia) ~= "string" then sv.soundMedia = "BugSack: Fatality" end
		if type(sv.fontSize) ~= "string" then sv.fontSize = "GameFontHighlight" end
		if type(sv.altwipe) ~= "boolean" then sv.altwipe = false end
		if type(sv.useMaster) ~= "boolean" then sv.useMaster = false end
		addon.db = sv

		-- Make sure we grab any errors fired before bugsack loaded.
		local session = addon:GetErrors(BugGrabber:GetSessionId())
		if #session > 0 then onError() end

		if addon.RegisterComm then
			addon:RegisterComm("BugSack", "OnBugComm")
		end

		-- Set up our error event handler
		BugGrabber.RegisterCallback(addon, "BugGrabber_BugGrabbed", onError)

		SlashCmdList.BugSack = function(msg)
			msg = msg:lower()
			if msg == "show" then
				addon:OpenSack()
			else
				InterfaceOptionsFrame_OpenToCategory(addonName)
				InterfaceOptionsFrame_OpenToCategory(addonName)
			end
		end
		SLASH_BugSack1 = "/bugsack"

		self:SetScript("OnEvent", nil)
	end)
	eventFrame:RegisterEvent("ADDON_LOADED")
	addon.frame = eventFrame
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
	local function hsl2argb(h,s,l)
		local C = (1 - abs(2*l - 1)) * s
		local X = C * (1 - abs((h/60)%2 - 1))
		local m = l - C/2
		local R_,G_,B_
		if       0<=h and h<60  then R_,G_,B_=C,X,0
		elseif  60<=h and h<120 then R_,G_,B_=X,C,0
		elseif 120<=h and h<180 then R_,G_,B_=0,C,X
		elseif 180<=h and h<240 then R_,G_,B_=0,X,C
		elseif 240<=h and h<300 then R_,G_,B_=X,0,C
		elseif 300<=h and h<360 then R_,G_,B_=C,0,X end
		R,G,B = (R_+m)*255, (G_+m)*255,(B_+m)*255
		return ("|c%02x%02x%02x"):format(R,G,B)
	end
	

	local function colorStack_default(ret)
		ret = tostring(ret) or "" -- Yes, it gets called with nonstring from somewhere /mikk
		ret = ret:gsub("[%.I][%.n][%.t][%.e][%.r]face\\", "")
		ret = ret:gsub("%.?%.?%.?\\?AddOns\\", "")
		ret = ret:gsub("|([^chHr])", "||%1"):gsub("|$", "||") -- Pipes
		ret = ret:gsub("<(.-)>", "|cffffea00<%1>|r") -- Things wrapped in <>
		--ret = ret:gsub("=%[C%]", "|cffaa88ff\131C\132|r") -- C code: color but escape the []
		--ret = ret:gsub("\n@(.-\\)", "\n|cff00aa00%1|r") -- paths
		ret = ret:gsub("%[(.-)%]", "|cffffea00[%1]|r") -- Things wrapped in []
		ret = ret:gsub("([\"`'])(.-)([\"`'])", "|cff8888ff%1%2%3|r") -- Quotes
		ret = ret:gsub(":(%d+)([%S\n])", ":|cff00ff00%1|r%2") -- Line numbers
		ret = ret:gsub("([^\\]+%.lua)", "|cffffffff%1|r") -- Lua files
		--ret = ret:gsub("\131","["):gsub("\132","]") -- unescape []
		return ret
	end

	local function colorStack_compact(ret)
		ret = tostring(ret) or "" -- Yes, it gets called with nonstring from somewhere /mikk
		ret = "\n"..ret.."\n"  -- silly bandaid to match start-of-line with \n

		--[[
			[C code] :  in function `RunScript'
			[string "@Interface\SharedXML\UIDropDownMenu.lua"]:71: in function `UIDropDownMenu_Initialize'
			[string "@Interface\FrameXML\ChatFrame.lua"]:2174: in function `?'
			[string "@Interface\FrameXML\EasyMenu.lua"]:21: in function `EasyMenu'
			[string "EasyMenu("qqq")"]:1: in main chunk
			[string "*:OnEnterPressed"]:1: in function <[string "*:OnEnterPressed"]:1>
		--]]

		local index=0
		local out=""
		
		local addoncolors={addon='|cff88ff00',path='|cff77cc00',file='|cffffffff'}
		local blizzcolors={addon='|cff9966ff',path='|cff9966ff',file='|cffbbbbff'}
		local xmlcolors={obj="|cffff8888",handler='|cffffaaaa'}
		local linecolor="|cff00ff00"
		local vercolor="|cffffff00"

		local function color_what(what,path,linenum)
			what = what:gsub("<[iI]nterface\\[aA]dd[oO]ns\\","<")
			what = what:gsub("in function (`)(.-)(')", "in function '|cff8888ff%2|r'") -- straighten quotes around function name
			what = what:gsub("in function <(.-)>", function(s) -- function path and starting line
				local file,linestart = s:match("([^\\/]+):(%d+)$")
				if linestart then linestart=tonumber(linestart) end
				if file and linestart then return "in function <"..addoncolors.file..file.."|r:"..linecolor..linestart.."|r>" end
				return "in function <"..s..">"
			end) -- Quotes
			return what
		end
		
		while (index<#ret) do  repeat
			local st,en,line=strfind(ret,"(.-)%s*\n",index)
			if not en then  index=#ret  break  end  -- really break
			index = en + 1
			
			--line = line:gsub("\n%[string \"([^\n]+)\"%]:","%1:") -- remove the [string " "] wrapper

			repeat
				local what = line:match("^%[string \"=%[C%]\"%]:(.*)")  -- =[C]
				if what then  -- C code
					what = color_what(what)
					line = ("%s[C code]|r: %s"):format(blizzcolors.addon,what)
					break --out
				end

				local what = line:match("^%[string \"=%(tail call%)\"%]:(.*)")  -- =(tail call)
				if what then  -- tail call?
					line = ("%s[tail call]|r : %s"):format("|cffaaaaaa",what)
					break --out
				end

				local path,linenum,what = line:match("^%[string \"@([^\"]+%.[lx][um][al] ?%[?v?[%d%.]*%]?)\"%]:(%d+): (.*)")  -- [string "@Interface\AddOns\file.lua [1.2.3]"]:123: error
				if path then  -- interface code
					local is_addon = (path:lower():match("^interface\\addons"))
					what = color_what(what,path,linenum) -- needs path to properly trim the what
					if is_addon then
						local addon,folder,file,ver = path:match("^.-\\.-\\(.-)\\(.-)([^\\]+%.lua)( ?%[?[%d%.]*%]?)$")
						if addon then
							local colors=addoncolors
							if addon and addon:lower():match("^blizzard_") then colors=blizzcolors end
							line = ("%s%s|r%s\\%s|r%s%s|r%s%s|r:%s%d|r: %s"):format(colors.addon,addon, colors.path,folder, colors.file,file, vercolor,ver, linecolor,linenum, what)
							break --out
						end
					else
						local path,file = path:match("^.-\\(.-)([^\\]+%.lua)$")
						line = ("%s%s|r%s%s|r:%s%d|r: %s"):format(blizzcolors.path,path, blizzcolors.file,file, linecolor,linenum, what)
						break --out
					end
				end

				local obj,handler,linenum,what = line:match("^%[string \"(%*):(On%w+)\"%]:(%d+): (.*)")  -- *:OnEnterPressed
				if obj then
					line = ("(XML) %s%s|r:%s%s|r:%s%d|r: %s"):format(xmlcolors.obj,obj, xmlcolors.handler,handler, linecolor,linenum, what)
					break
				end

				local str,linenum,what = line:match("^%[string \"(.-)\"%]:(%d+): (.*)")  -- *:OnEnterPressed
				if str then
					line = ("(string) \"%s%s|r\":%s%d|r: %s"):format("|cffffffff",str, linecolor,linenum, what)
					break
				end
			until true
			out=out..(#out>0 and "\n" or "")..line
		until true end

		return out
	end

	local function colorStack(ret)
		--if addon.db.stack_raw then return ret end
		if addon.db.compactformat then return colorStack_compact(ret)
		else return colorStack_default(ret)
		end
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

	local errorFormat = "%dx %s\n\nStack:\n%s"
	local errorFormatLocals = "%dx %s\n\nStack:\n%s\n\nLocals:\n%s"
	function addon:FormatError(err)
		if not err.locals then
			local e = tostring(err.message)
			local s = colorStack((err.stack and tostring(err.stack) or "-none-"))
			local l = colorLocals(tostring(err.locals))
			return errorFormat:format(err.counter or -1, e, s, l)
		else
			local e = tostring(err.message)
			local s = colorStack((err.stack and tostring(err.stack) or "-none-"))
			local l = colorLocals(tostring(err.locals))
			return errorFormatLocals:format(err.counter or -1, e, s, l)
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
	if not self.Serialize then return end

	local errors = self:GetErrors(session)
	if not errors or #errors == 0 then return end
	local sz = self:Serialize(errors)
	self:SendCommMessage("BugSack", sz, "WHISPER", player, "BULK")

	print(L["%d bugs have been sent to %s. He must have BugSack to be able to examine them."]:format(#errors, player))
end

function addon:OnBugComm(prefix, message, _, sender)
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


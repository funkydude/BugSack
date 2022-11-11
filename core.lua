
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
		ret = ret:gsub("[%.I][%.n][%.t][%.e][%.r]face/", "")
		ret = ret:gsub("%.?%.?%.?/?AddOns/", "")
		ret = ret:gsub("|([^chHr])", "||%1"):gsub("|$", "||") -- Pipes
		ret = ret:gsub("<(.-)>", "|cffffea00<%1>|r") -- Things wrapped in <>
		--ret = ret:gsub("=%[C%]", "|cffaa88ff\131C\132|r") -- C code: color but escape the []
		--ret = ret:gsub("\n@(.-/)", "\n|cff00aa00%1|r") -- paths
		ret = ret:gsub("%[(.-)%]", "|cffffea00[%1]|r") -- Things wrapped in []
		ret = ret:gsub("([\"`'])(.-)([\"`'])", "|cff8888ff%1%2%3|r") -- Quotes
		ret = ret:gsub(":(%d+)([%S\n])", ":|cff00ff00%1|r%2") -- Line numbers
		ret = ret:gsub("([^/]+%.lua)", "|cffffffff%1|r") -- Lua files
		--ret = ret:gsub("\131","["):gsub("\132","]") -- unescape []
		return ret
	end

	local function _cr(color,str) return str and #str>0 and "|c"..color..str.."|r" or "" end  -- not a huge overhead, so do use this for wrapping colors, just to be 100% sure you don't miss a |r.
	local colors = {
		addon = {addon='ff88ff00',path='FF559200',file='FFC4FF81',file2='FF92C25B'}, -- MyAddon /Folder/ File.lua
		blizz = {addon='ff9966ff',path='FF563A8F',file='FFAB81FF',file2='FF9984C4',line='FFBAA7E0'}, -- Blizzard_CoreAddon /Folder/ File.lua
		ccode = 'FF864AFF', -- [C]
		tailcall = 'FF5C74FF', -- (tail call)
		string = 'ffffffff', -- "string"
		funcname = 'FFFFCF31',
		xml = {obj="ffff8888",handler='ffffaaaa'}, -- <XMLWidget:OnSomeEvent>
		line = "FFD0FF00", -- :123
		line2 = "FFBDD162", -- :123
		ver ="ffffff00", -- (1.0.0)
		val = {
			['nil'] = "FFCC00FF",
			['true'] = "FF1EFF00",
			['false'] = "FFFF0000",
			num = "ffff7fff",
			func = "ffffea00",
			tablekey = "ffffff80"
		}
	}
	local col = {}
	do
		local function wrapcolor(t,into)
			for k,v in pairs(t) do
				if type(v)=="string" then into[k]=function(str) return _cr(v,str) end
				elseif type(v)=="table" then into[k]={} wrapcolor(v,into[k]) end
			end
		end
		wrapcolor(colors,col)
	end

	local function color_path(path, addon,folder,file,isAddon,isBlizz)
		if path and not addon and not file then
			addon,folder,file,isAddon,isBlizz = ParseStack.parsePath(path)
		end
		if file then
			local col_type = isBlizz and col.blizz or col.addon
			return col_type.addon(addon or "") .. col_type.path((addon and "/" or "")..(folder and folder.."/" or "")) .. col_type.file(file)
		end
		--[[
		else -- framexml or something
			local folder,file = path:match("^.-/(.-)([^/]+%.[luaxm]+)$")
			if folder then
				return col.blizz.path(folder)..col.blizz.file(file)
			end
		end
		--]]
		return path
	end

	local function colorStack_compact(stack)
		stack = tostring(stack) or "" -- Yes, it gets called with nonstring from somewhere /mikk
		stack = stack:gsub("^[%s\n]*","") -- trim leading space/lines

		local parsed_stack = ParseStack and ParseStack.parseStack(stack)
		if not parsed_stack then return stack end

		local out=""
		
		for i,entry in ipairs(parsed_stack) do
			
			-- color source first
			local source,linenum,line

			if entry.source_type=="c" then
				source = col.ccode("[C code]")
				
			elseif entry.source_type=="tailcall" then
				source = col.tailcall("[tail call]")
				
			elseif entry.source_type=="lua" then
				source = color_path(entry.source, entry.source_addon,entry.source_folder,entry.source_file,entry.source_is_addon,entry.source_is_blizz)
				
			elseif entry.source_type=="xml" then
				if entry.source_file then
					--"(XML) "..col.xml.obj(entry.source_file)..":"..col.line(entry.source_linenumx).." ("..col.xml.handler(entry.source_handler)..")"
					source = col.addon.file(entry.source_file)..":"..col.line(entry.source_linenumx).." ("..col.xml.handler(entry.source_handler)..")"
				else
					source = col.blizz.file(entry.source:sub(2))
				end

			elseif entry.source_type=="xml_inline" then
				--source = "(XML) "..col.xml.obj(entry.source_file)..":"..col.line(entry.source_linenumx).." <"..col.xml.handler(entry.source_xmltag)..">"
				source = color_path(entry.source, entry.source_addon,entry.source_folder,entry.source_file,entry.source_is_addon,entry.source_is_blizz).." <"..col.xml.handler(entry.source_xmltag)..">"
								
			elseif entry.source then
				source = "\""..col.string(entry.source).."\""
				-- source is plain string, leave it alone for now
			end

			-- color linenum, if any
			if entry.linenum then linenum=(entry.source_is_blizz and col.blizz.line or col.line)(entry.linenum) end

			-- color function last
			--scope = scope:gsub("<[iI]nterface/[aA]dd[oO]ns/","<")
			if entry.function_name then
				line="in function '"..(entry.source_is_blizz and col.blizz.file or col.funcname)(entry.function_name).."'" -- straighten quotes around function name					
			
			elseif entry.function_file then
				line="in function <"..col.addon.file2(entry.function_file~=entry.source_file and entry.function_file or "")..":"..col.line2(entry.function_startline)..">"
			
			elseif entry.function_angle then
				line="in function <"..col.funcname(entry.function_angle)..">"
			
			elseif entry.function_same then
				line="inline"
			
			elseif entry.function_main then
				line="in main chunk"
			
			elseif entry.function_unknown then
				line="?"

			else
				line=entry.function_raw
			end

			out=out..(#out>0 and "\n" or "")
			if source then
				out = out .. source .. (linenum and (":"..linenum) or "") .. (line and ": "..line or "")
			else
				out = out .. entry.raw
			end

		end

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
		ret = ret:gsub("[%.I][%.n][%.t][%.e][%.r]face/", "")
		ret = ret:gsub("%.?%.?%.?/?AddOns/", "")
		ret = ret:gsub("|(%a)", "||%1"):gsub("|$", "||") -- Pipes
		ret = ret:gsub("> %@(.-):(%d+)", "> @|cffeda55f%1|r:|cff00ff00%2|r") -- Files/Line Numbers of locals
		ret = ret:gsub("(%s-)([%a_%(][%a_%d%*%)]+) = ", "%1"..col.val.tablekey("%2").." = ") -- Table keys
		ret = ret:gsub("= (%-?[%d%p]+)\n", "= "..col.val.num("%1").."\n") -- locals: number
		ret = ret:gsub("= nil\n", "= "..col.val['nil']("nil").."\n") -- locals: nil
		ret = ret:gsub("= true\n", "= "..col.val['true']("true").."\n") -- locals: true
		ret = ret:gsub("= false\n", "= "..col.val['false']("false").."\n") -- locals: false
		ret = ret:gsub("= <(.-)>", "= "..col.val.func("<%1>")) -- Things wrapped in <>
		return ret
	end
	addon.ColorLocals = colorLocals

	local function colorMessage(ret)
		ret = ret:gsub("^%[string \"(.-)\"%]:","%1:")
		local path,linenum,message = ret:match("^([^:]+/[^:]+):([%d]+): (.+)")
		if path then ret = color_path(path)..":"..col.line(linenum)..": "..message end
		return ret
	end

	local errorFormatMessage = _cr("ffffffff","%d").."x %s"
	local errorFormatStack = "\n\nStack:\n%s"
	local errorFormatLocals = "\n\nLocals:\n%s"
	
	function addon:FormatError(err)
		-- if there's an extra stack stored in the error (some addons do this for their bug handling), extract it and append to the stack.

		local stack = err.stack
		local message = err.message

		-- Zygor Guides
		local msg,pre_stack = message:match("(.*)\n%-%- STACKTRACE: %-%-\n(.*)")
		if msg then
			message = msg
			stack = pre_stack .. "---\n" .. (tostring(stack) or "")
		end

		local ret = errorFormatMessage:format(err.counter or -1, colorMessage(tostring(message)))
		ret = ret .. errorFormatStack:format(colorStack(stack))
		if err.locals then ret = ret .. errorFormatLocals:format(colorLocals(tostring(err.locals))) end
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


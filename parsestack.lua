ParseStack = {}

--[[
	[string "=[C]"]: in function `RunScript'
	[string "=(tail call)"]: in main chunk
	[string "@Interface\SharedXML\UIDropDownMenu.lua"]:71: in function `UIDropDownMenu_Initialize'
	[string "@Interface\FrameXML\ChatFrame.lua"]:2174: in function `?'
	[string "@Interface\FrameXML\EasyMenu.lua"]:21: in function `EasyMenu'
	[string "EasyMenu("qqq")"]:1: in main chunk
	[string "*:OnEnterPressed"]:1: in function <[string "*:OnEnterPressed"]:1>
	[string "*ChatFrame.xml:127_OnEnterPressed"]:1: in function <[string "*ChatFrame.xml:127_OnEnterPressed"]:1>
--]]

function ParseStack.parsePath(path)
	local is_addon = path:lower():match("^interface/addons/")
	local is_blizz
	path = path:gsub("^[Ii]nterface/","")
	path = path:gsub("^[Aa]dd[Oo]ns/","")

	local parts = {strsplit(":",path)}
	local fileparts = {strsplit("/",parts[1])}
	local addon,folder,file
	if #fileparts>0 then
		addon = is_addon and tremove(fileparts,1)
		is_blizz = is_addon and addon:find("Blizzard_",1,true) or (fileparts[1]=="FrameXML" or fileparts[1]=="SharedXML")
		if addon and is_blizz then tinsert(fileparts,1,addon) addon=nil end -- back into the path, Blizzard_ addons are not addons
		file = tremove(fileparts,#fileparts)
		if #fileparts>0 then folder=table.concat(fileparts,"/") end
	end
	return addon,folder,file,not not is_addon,not not is_blizz
end
local parsePath=ParseStack.parsePath

function ParseStack.parseStack(stack)
	if type(stack)=="string" then stack={strsplit("\n",stack)} end
	local parsedStack = {}
	for i,line in ipairs(stack) do
		local orig_line = line
		local p = {raw=line}
		local _
		p.source,_ = line:match("^%[string \"(.-)\"%]:(.*)")  -- [string "source"]: | 1: in function `blabla'
		if _ then line=_ end
		p.linenum,_ = line:match("^(%d+): (.*)") -- 1: in function
		if _ then line=_ else line=line:gsub("^ ","") end

		if not p.source then
			--
			
		elseif p.source=="=[C]" then
			p.source_type="c"

		elseif p.source=="=(tail call)" then
			p.source_type="tailcall"

		elseif p.source:sub(1,1)=="@" then -- source file
			p.source_type="lua"
			p.source_addon,p.source_folder,p.source_file,p.source_is_addon,p.source_is_blizz=parsePath(p.source:sub(2))

		elseif p.source:sub(1,1)=="*" then -- xml?
			p.source_type="xml"
			p.source_addon,p.source_folder,p.source_file,p.source_is_addon,p.source_is_blizz=parsePath(p.source:sub(2))
			p.source_file,p.source_linenumx,p.source_handler = p.source:match("^.([^:]+):(%d+)_(.*)")

		elseif p.source:find(".xml:<",1,true) then -- xml inline
			p.source_type="xml_inline"
			local path,tag = p.source:match("(.*):<(.-)>")
			p.source_addon,p.source_folder,p.source_file,p.source_is_addon,p.source_is_blizz=parsePath(path)
			p.source_xmltag = tag

		else
			p.source_type="string"
		end

		if line=="in main chunk" then
			p.function_main = line=="in main chunk"
		elseif line=="?" then
			p.function_unknown = true
		else
			p.function_name = line:match("^in function `(.-)'")
			p.function_angle = line:match("^in function <(.-)>")
			if p.function_angle then
				p.function_file,p.function_startline = p.function_angle:match("([^/]+):(%d+)$") -- just file name and line
				if p.function_file then p.function_angle=nil end
				if p.function_file=="[string \""..p.source.."\"]" then
					p.function_same=true
					p.function_file=nil
					p.function_name=nil
				end
			end
			if not p.function_name and not p.function_file and not p.function_same then
				p.function_raw = line
			end
		end

		tinsert(parsedStack,p)
	end
	return parsedStack
end

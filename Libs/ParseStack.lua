ParseStack = {}

function ParseStack.parsePath(path)
	local is_addon = not not (path:lower():match("^interface/addons"))
	path = path:gsub("^[Ii]nterface/","")
	path = path:gsub("^[Aa]dd[Oo]ns/","")

	local parts = {strsplit(":",path)} --path:match("^(.-)/(.-)([^/]+%.[luaxm]+)( ?%[?[%d%.]*%]?)$") -- removes Interface/Addons!
	local fileparts = {strsplit("/",parts[1])}
	local addon,folder,file
	if #fileparts>0 then
		addon=tremove(fileparts,1)
		file=tremove(fileparts,#fileparts)
		if #fileparts>0 then folder=table.concat(fileparts,"/") end
	end
	if addon and file then
		local is_blizz = not not addon:lower():match("^blizzard_")
		return addon,folder,file,is_addon,is_blizz
	end
end
local parsePath=ParseStack.parsePath

function ParseStack.parseStack(stack)
	if type(stack)=="string" then stack=strsplit("\n",stack) end
	local parsedStack = {}
	for i,line in ipairs(stack) do
		local orig_line = line
		local p = {}
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
			p.source=p.source:sub(2)
			p.source_addon,p.source_folder,p.source_file,p.source_is_addon,p.source_is_blizz=parsePath(p.source)
			p.source_type="lua"

		elseif p.source:sub(1,1)=="*" then -- xml?
			p.source=p.source:sub(2)
			p.source_type="xml"
			p.source_addon,p.source_folder,p.source_file,p.source_is_addon,p.source_is_blizz=parsePath(p.source)
			p.source_file,p.source_linenumx,p.source_handler = p.source:match("^([^:]+):(%d+)_(.*)")

		elseif p.source:find(".xml:<",1,true) then -- xml inline
			p.source_type="xml_inline"
			local path,tag = p.source:match("(.*):<(.-)>")
			p.source_addon,p.source_folder,p.source_file,p.source_is_addon,p.source_is_blizz=parsePath(path)
			p.source_xmltag = tag

		else
			p.source_type="string"
		end

		p.function_name = line:match("^in function `(.-)'")
		p.function_angle = line:match("^in function <(.-)>")
		if p.function_angle then
			p.function_file,p.function_startline = p.function_angle:match("([^/]+):(%d+)$") -- just file name and line
			if p.function_file then p.function_angle=nil end
		end

		tinsert(parsedStack,p)
	end
	return parsedStack
end

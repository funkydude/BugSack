local addonName, addon = ...

if not addon.Plugins then return end

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

local function colorPath(path, addon,folder,file,isAddon,isBlizz)
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

local function colorStack(stack)
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
			source = colorPath(entry.source, entry.source_addon,entry.source_folder,entry.source_file,entry.source_is_addon,entry.source_is_blizz)
			
		elseif entry.source_type=="xml" then
			if entry.source_file then
				--"(XML) "..col.xml.obj(entry.source_file)..":"..col.line(entry.source_linenumx).." ("..col.xml.handler(entry.source_handler)..")"
				source = col.addon.file(entry.source_file)..":"..col.line(entry.source_linenumx).." ("..col.xml.handler(entry.source_handler)..")"
			else
				source = col.blizz.file(entry.source:sub(2))
			end

		elseif entry.source_type=="xml_inline" then
			--source = "(XML) "..col.xml.obj(entry.source_file)..":"..col.line(entry.source_linenumx).." <"..col.xml.handler(entry.source_xmltag)..">"
			source = colorPath(entry.source, entry.source_addon,entry.source_folder,entry.source_file,entry.source_is_addon,entry.source_is_blizz).." <"..col.xml.handler(entry.source_xmltag)..">"
							
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

local function colorMessage(msg)
	-- strip [string "..."]:
	msg = msg:gsub("^%[string \"(.-)\"%]:","%1:")

	-- color path:line, if present
	local path,linenum,message = msg:match("^([^:]+/[^:]+):([%d]+): (.+)")
	if path then msg = colorPath(path)..":"..col.line(linenum)..": "..message end

	return msg
end

local errorFormatMessage = _cr("ffffffff","%d").."x %s"

local function formatMessage(counter,message)
	return errorFormatMessage:format(counter or -1, colorMessage(tostring(message)))
end

local function colorLocals(locals)
	locals = tostring(locals) or "" -- Yes, it gets called with nonstring from somewhere /mikk
	locals = locals:gsub("|(%a)", "||%1"):gsub("|$", "||") -- Pipes
	--locals = locals:gsub("> %@(.-):(%d+)", "> @|cffeda55f%1|r:|cff00ff00%2|r") -- Files/Line Numbers of locals
	locals = locals:gsub("(%s-)([%a_%(][%a_%d%*%)]+) = ", "%1"..col.val.tablekey("%2").." = ") -- Table keys
	locals = locals:gsub("= (%-?[%d%p]+)\n", "= "..col.val.num("%1").."\n") -- locals: number
	locals = locals:gsub("= nil\n", "= "..col.val['nil']("nil").."\n") -- locals: nil
	locals = locals:gsub("= true\n", "= "..col.val['true']("true").."\n") -- locals: true
	locals = locals:gsub("= false\n", "= "..col.val['false']("false").."\n") -- locals: false
	locals = locals:gsub("= <(.-)>", "= "..col.val.func("<%1>")) -- Things wrapped in <>
	locals = locals:gsub("defined @(.-):(%d+)",function(path,line) return "defined @"..colorPath(path)..":"..col.line(line) end)
	--locals = locals:gsub("@[%.I][%.n][%.t][%.e][%.r]face/", "")
	--locals = locals:gsub("%.?%.?%.?/?AddOns/", "")
	return locals
end

local function preformatError(message,stack,locals)
	local msg,pre_stack = message:match("(.*)\n%-%- STACKTRACE: %-%-\n(.*)")
	if msg then
		message = msg
		stack = pre_stack .. "---\n" .. (tostring(stack) or "")
	end
	return message,stack,locals
end

addon.Plugins:RegisterFormatter({
	name="compact",
	label="Compact",
	description="Stack lines compacted and with color coding of source: internal or addon code.",
	formatStack=colorStack,
	formatMessage=formatMessage,
	formatLocals=colorLocals,
	preformatError=preformatError,
})

addon.Plugins:RegisterFormatter({
	name="raw",
	label="Raw",
	description="Do not apply any formatting.",
	--formatStack=function(...) return ... end,
	--formatMessage=function(count,msg) return count.."x "..msg,
	--formatLocals=identity,
})
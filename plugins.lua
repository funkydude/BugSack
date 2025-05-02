local addonName, addon = ...

addon.Plugins = {}
addon.Plugins.formatters = {}

function addon.Plugins:RegisterFormatter(package)
	if package.name then
		package.formatStack = package.formatStack or function(stack) return stack end
		package.formatMessage = package.formatMessage or function(count,message) return ("%dx %s"):format(count or -1,message) end
		package.formatLocals = package.formatLocals or function(locals) return locals end
		package.preformatError = package.preformatError or function(...) return ... end
		addon.Plugins.formatters[package.name]=package
	end
end

function addon.Plugins:GetFormatter(name)
	return addon.Plugins.formatters[name or addon.db.pluginFormatter] or addon.Plugins.formatters["default"]
end

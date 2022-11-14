local addonName, addon = ...

addon.Plugins = {}
addon.Plugins.formatters = {}

function addon.Plugins:RegisterFormatter(package)
	if package.name then
		package.formatStack = package.formatStack or function(stack) return stack end
		package.formatMessage = package.formatMessage or function(stack) return stack end
		package.formatLocals = package.formatLocals or function(stack) return stack end
		addon.Plugins.formatters[package.name]=package
	end
end

function addon.Plugins:GetFormatter(name)
	return addon.Plugins.formatters[name or addon.db.pluginFormatter] or addon.Plugins.formatters["default"]
end
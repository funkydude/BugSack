local addonName, addon = ...

addon.Plugins = {}
addon.Plugins.formatters = {}

function addon.Plugins:RegisterFormatter(package)
	if package.name and package.formatter then
		package.formatStack = package.formatStack or function(stack) return stack end
		package.formatPath = package.formatPath or function(stack) return stack end
		addon.Plugins.formatters[package.name]=package
	end
end

function addon.Plugins:GetFormatter(name)
	return addon.Plugins[name or BugSackDB.pluginStack] or addon.Plugins["default"]
end
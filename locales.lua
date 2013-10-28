local addonName, addon = ...
function addon:LoadTranslations(AL)
	local debug = nil
--@debug@
	debug = true
--@end-debug@
	local L = AL:NewLocale(addonName, "enUS", true, debug)
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	local locale = GetLocale()
	L = AL:NewLocale(addonName, locale)
	if locale == "deDE" then
--@localization(locale="deDE", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "esES" then
--@localization(locale="esES", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "esMX" then
--@localization(locale="esMX", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "frFR" then
--@localization(locale="frFR", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "koKR" then
--@localization(locale="koKR", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "ruRU" then
--@localization(locale="ruRU", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "zhCN" then
--@localization(locale="zhCN", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "zhTW" then
--@localization(locale="zhTW", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "ptBR" then
--@localization(locale="ptBR", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	elseif locale == "itIT" then
--@localization(locale="itIT", format="lua_additive_table", same-key-is-true=true, handle-unlocalized="ignore")@
	end
end

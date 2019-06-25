
local addonName, addon = ...

local L = {}
L["All bugs"] = "All bugs"
L["All stored bugs have been exterminated painfully."] = "All stored bugs have been exterminated painfully."
L["autoDesc"] = "Makes the BugSack open automatically when an error is encountered, but not while you are in combat."
L["Auto popup"] = "Auto popup"
L["|cffeda55fClick|r to open BugSack with the last bug. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = "|cffeda55fClick|r to open BugSack with the last bug. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."
L["|cffff4411BugSack requires the |r|cff44ff44!BugGrabber|r|cffff4411 addon, which you can download from the same place you got BugSack. Happy bug hunting!|r"] = "|cffff4411BugSack requires the |r|cff44ff44!BugGrabber|r|cffff4411 addon, which you can download from the same place you got BugSack. Happy bug hunting!|r"
L["chatFrameDesc"] = "Prints a reminder to the chat frame when an error is encountered. Doesn't print the whole error, just a reminder!"
L["Chatframe output"] = "Chatframe output"
L["Current session"] = "Current session"
L["Copy this string"] = "Copy this string"
L["%d bugs have been sent to %s. He must have BugSack to be able to examine them."] = "%d bugs have been sent to %s. He must have BugSack to be able to examine them."
L["Export"] = "Export"
L["Failure to deserialize incoming data from %s."] = "Failure to deserialize incoming data from %s."
L["Filter addon mistakes"] = "Filter addon mistakes"
L["filterDesc"] = "Whether BugSack should treat ADDON_ACTION_BLOCKED and ADDON_ACTION_FORBIDDEN events as bugs or not. If that doesn't make sense, just ignore this option."
L["Font size"] = "Font size"
L["Large"] = "Large"
L["Limit"] = "Limit"
L["Local (%s)"] = "Local (%s)"
L["Medium"] = "Medium"
L["minimapDesc"] = "Shows the BugSack icon around your minimap."
L["Minimap icon"] = "Minimap icon"
L["Mute"] = "Mute"
L["muteDesc"] = "Prevents BugSack from playing the any sound when a bug is detected, no matter what you select in the dropdown below."
L["Next >"] = "Next >"
L["Player needs to be a valid name."] = "Player needs to be a valid name."
L["< Previous"] = "< Previous"
L["Previous session"] = "Previous session"
L["saveDesc"] = "Saves the bugs in the database. If this is off, bugs will not persist in the sack from session to session."
L["Save errors"] = "Save errors"
L["Send"] = "Send"
L["Send all bugs from the currently viewed session (%d) in the sack to the player specified below."] = "Send all bugs from the currently viewed session (%d) in the sack to the player specified below."
L["Send bugs"] = "Send bugs"
L["Sent by %s (%s)"] = "Sent by %s (%s)"
L["Small"] = "Small"
L["Sound"] = "Sound"
L["There's a bug in your soup!"] = "There's a bug in your soup!"
L["Throttle at excessive amount"] = "Throttle at excessive amount"
L["throttleDesc"] = "Sometimes addons can generate hundreds of bugs per second, which can lock up the game. Enabling this option will throttle bug grabbing, preventing lockup when this happens."
L["Today"] = "Today"
L["Toggle the minimap icon."] = "Toggle the minimap icon."
L["wipeDesc"] = "Exterminates all stored bugs from the database."
L["Wipe saved bugs"] = "Wipe saved bugs"
L["X-Large"] = "X-Large"
L["You have no bugs, yay!"] = "You have no bugs, yay!"
L["You've received %d bugs from %s."] = "You've received %d bugs from %s."
L["%d per %d"] = "%d per %d"

local locale = GetLocale()
if locale == "deDE" then
--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esES" then
--@localization(locale="esES", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esMX" then
--@localization(locale="esMX", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "frFR" then
--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "koKR" then
--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ruRU" then
--@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhCN" then
--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhTW" then
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ptBR" then
--@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "itIT" then
--@localization(locale="itIT", format="lua_additive_table", handle-unlocalized="ignore")@
end

addon.L = L


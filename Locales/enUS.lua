local L = LibStub("AceLocale-3.0"):NewLocale("BugSack", "enUS", true)
if not L then return end

-- Common
L["You have no bugs, yay!"] = true

-- BugSack window
L["Next >"] = true
L["< Previous"] = true
L["Send bugs"] = true
L["Today"] = true
L["Sent by %s (%s)"] = true
L["Local (%s)"] = true
L["All bugs"] = true
L["Current session"] = true
L["Previous session"] = true

L["Send"] = true
L["Send all bugs from the currently viewed session (%d) in the sack to the player specified below."] = true

-- Options
L["Auto popup"] = true
L.autoDesc = "Makes the BugSack open automatically when an error is encountered."
L["Chatframe output"] = true
L.chatFrameDesc = "Prints a reminder to the chat frame when an error is encountered. Doesn't print the whole error, just a reminder!"
L["Sound"] = true
L["Mute"] = true
L.muteDesc = "Prevents BugSack from playing the 'Worms'-style sound when a bug is detected."
L["Filter addon mistakes"] = true
L.filterDesc = "Whether BugSack should treat ADDON_ACTION_BLOCKED and ADDON_ACTION_FORBIDDEN events as bugs or not. If that doesn't make sense, just ignore this option."
L["Throttle at excessive amount"] = true
L.throttleDesc = "Sometimes addons can generate hundreds of bugs per second, which can lock up the game. Enabling this option will throttle bug grabbing, preventing lockup when this happens."
L["Save errors"] = true
L.saveDesc = "Saves the bugs in the database. If this is off, bugs will not persist in the sack from session to session."
L["Limit"] = true
L["Wipe saved bugs"] = true
L.wipeDesc = "Exterminates all stored bugs from the database."
L["Minimap icon"] = true
L.minimapDesc = "Shows the BugSack icon around your minimap."
L["Font size"] = true
L["Small"] = true
L["Medium"] = true
L["Large"] = true
L["X-Large"] = true

-- Chat messages
L["You've received %d bugs from %s."] = true
L["%d bugs have been sent to %s. He must have BugSack to be able to examine them."] = true
L["All stored bugs have been exterminated painfully."] = true
L["There's a bug in your soup!"] = true
L["Failure to deserialize incoming data from %s."] = true
L["Player needs to be a valid name."] = true
L["|cffff4411BugSack requires the |r|cff44ff44!BugGrabber|r|cffff4411 addon, which you can download from the same place you got BugSack. Happy bug hunting!|r"] = true

-- LDB
L["|cffeda55fClick|r to open BugSack with the last bug. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = true
L["Minimap icon"] = true
L["Toggle the minimap icon."] = true


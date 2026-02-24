local addonName, addon = ...

local L = {}

-- General
L["General.AllBugs"] = "All bugs"
L["General.BugsExterminated"] = "All stored bugs have been exterminated painfully."
L["General.CurrentSession"] = "Current session"
L["General.Filter"] = "Filter"
L["General.Local"] = "Local (%s)"
L["General.Next"] = "Next >"
L["General.Previous"] = "< Previous"
L["General.PreviousSession"] = "Previous session"
L["General.Send"] = "Send"
L["General.SendBugs"] = "Send bugs"
L["General.SentBy"] = "Sent by %s (%s)"
L["General.Today"] = "Today"
L["General.NoBugs"] = "You have no bugs, yay!"
L["General.BugInSoup"] = "There's a bug in your soup!"
L["General.QuickTipsTitle"] = "Quick tips"
L["General.QuickTipsDesc"] = "Double-click to filter bug reports. After you are done with the search results, return to the full sack by selecting a tab at the bottom. Left-click and drag to move the window. Right-click to close the sack and open the interface options for BugSack."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack requires the %s addon, which you can download from the same place you got BugSack. Happy bug hunting!"
L["ErrorMessage.DeserializeFail"] = "Failure to deserialize incoming data from %s."
L["ErrorMessage.InvalidPlayer"] = "Player needs to be a valid name."
L["ErrorMessage.BugsSent"] = "%d bugs have been sent to %s. They must have BugSack to be able to examine them."
L["ErrorMessage.SendPrompt"] = "Send all bugs from the currently viewed session (%d) in the sack to the player specified below."
L["ErrorMessage.BugsReceived"] = "You've received %d bugs from %s."

-- Options
L["Options.RestoreDefaults"] = "Restore Defaults"
L["Options.RestoreDefaultsDesc"] = "Restores all BugSack settings to their default values."
L["Options.EnablePopup"] = "Enable Popup"
L["Options.EnablePopupDesc"] = "Makes the BugSack open automatically when an error is encountered, but not while you are in combat."
L["Options.EnablePrintMessages"] = "Enable Print Messages"
L["Options.EnablePrintMessagesDesc"] = "Prints a reminder to the chat frame when an error is encountered. Doesn't print the whole error, just a reminder!"
L["Options.EnableSoundEffects"] = "Enable Sound Effects"
L["Options.EnableSoundEffectsDesc"] = "Allows BugSack to play a sound when a bug is detected."
L["Options.Sound"] = "Sound"
L["Options.SoundPreview"] = "Preview Sound"
L["Options.UseMaster"] = "Use 'Master' sound channel"
L["Options.UseMasterDesc"] = "Play the chosen error sound over the 'Master' sound channel instead of the default one."
L["Options.EraseBugs"] = "Erase Bugs"
L["Options.EraseBugsDesc"] = "Exterminates all stored bugs from the database."
L["Options.EnableMinimapButton"] = "Enable Minimap Button"
L["Options.EnableMinimapButtonDesc"] = "Shows the BugSack icon around your minimap."
L["Options.AddonCompartment"] = "Addon compartment icon"
L["Options.AddonCompartmentDesc"] = "Creates a menu entry in the 'Addon Compartment' for BugSack."
L["Options.BugWindowFontSize"] = "Bug Window Font Size"
L["Options.FontSize"] = "Font Size"

-- Font sizes
L["FontSize.Small"] = "Small"
L["FontSize.Medium"] = "Medium"
L["FontSize.Large"] = "Large"
L["FontSize.XLarge"] = "X-Large"

-- Minimap
L["Minimap.Click"] = "Click"
L["Minimap.ClickAction"] = "Open"
L["Minimap.RightClick"] = "Right-Click"
L["Minimap.RightClickAction"] = "Options"
L["Minimap.MiddleClick"] = "Middle-Click"
L["Minimap.MiddleClickAction"] = "Toggle Sound"
L["Minimap.ShiftClick"] = "Shift + Click"
L["Minimap.ShiftClickAction"] = "Reload Interface"
L["Minimap.ShiftMiddleClick"] = "Shift + Middle-Click"
L["Minimap.ShiftMiddleClickAction"] = "Clear Bugs"
L["Minimap.AltClick"] = "Alt-Click"
L["Minimap.AltClickAction"] = "Wipe Bugs"

addon.L = L
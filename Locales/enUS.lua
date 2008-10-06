local L = LibStub("AceLocale-3.0"):NewLocale("BugSack", "enUS", true)

-- Command descriptions
L["Show sack"] = true
L["Show errors in the sack."] = true
L["Current error"] = true
L["Show the current error."] = true
L["Current session"] = true
L["Show errors from the current session."] = true
L["Previous session"] = true
L["Show errors from the previous session."] = true
L["By session number"] = true
L["Show errors by session number."] = true
L["All errors"] = true
L["Show all errors."] = true
L["Received errors"] = true
L["Show errors received from another player."] = true
L["Send bugs"] = true
L["Sends your current session bugs to another BugSack user."] = true
L["<player name>"] = true
L["Menu"] = true
L["Menu options."] = true

L["List errors"] = true
L["List errors to the chat frame."] = true
L["List the current error."] = true
L["List errors from the current session."] = true
L["List errors from the previous session."] = true
L["List errors by session number."] = true
L["List all errors."] = true
L["List errors received from another player."] = true

L["Auto popup"] = true
L["Toggle auto BugSack frame popup."] = true
L["Chatframe output"] = true
L["Print a warning to the chat frame when an error occurs."] = true
L["Errors to chatframe"] = true
L["Print the full error message to the chat frame instead of just a warning."] = true
L["Mute"] = true
L["Toggle an audible warning everytime an error occurs."] = true
L["Sound"] = true
L["What sound to play when an error occurs (Ctrl-Click to preview.)"] = true
L["Save errors"] = true
L["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = true
L["Limit"] = true
L["Set the limit on the nr of errors saved."] = true
L["Filter addon mistakes"] = true
L["Filters common mistakes that trigger the blocked/forbidden event."] = true
L["Throttle at excessive amount"] = true
L["Whether to throttle for a default of 60 seconds when BugGrabber catches more than 20 errors per second."] = true

L["Generate bug"] = true
L["Generate a fake bug for testing."] = true
L["Script bug"] = true
L["Generate a script bug."] = true
L["Addon bug"] = true
L["Generate an addon bug."] = true

L["Clear errors"] = true
L["Clear out the errors database."] = true

L["%d sec."] = true
L["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."] = true

-- Chat messages
L["You have no errors, yay!"] = true
L["List of errors:"] = true
L["An error has been generated."] = true
L["BugSack generated this fake error."] = true
L["All errors were wiped."] = true
L["An error has been recorded."] = true
L["%d errors have been recorded."] = true
L["You've received %d errors from %s, you can show them with /bugsack show received."] = true
L["%d errors has been sent to %s. He must have BugSack to be able to read them."] = true

-- Frame messages,
L[" (... more ...)"] = true
L["No errors found"] = true
L["Error %d of %d"] = true
L[" (viewing last error)"] = true
L[" (viewing session errors)"] = true
L[" (viewing previous session errors)"] = true
L[" (viewing all errors)"] = true
L[" (viewing errors for session %d)"] = true
L[" (viewing errors from %s)"] = true

-- FuBar plugin
L["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = true


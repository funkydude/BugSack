local L = AceLibrary("AceLocale-2.2"):new("BugSack")

L:RegisterTranslations("enUS", function() return {
	-- Bindings
	["Show Current Error"] = true,
	["Show Session Errors"] = true,

	-- Command descriptions
	["Show sack"] = true,
	["Show errors in the sack."] = true,
	["Current error"] = true,
	["Show the current error."] = true,
	["Current session"] = true,
	["Show errors from the current session."] = true,
	["Previous session"] = true,
	["Show errors from the previous session."] = true,
	["By session number"] = true,
	["Show errors by session number."] = true,
	["All errors"] = true,
	["Show all errors."] = true,

	["List errors"] = true,
	["List errors to the chat frame."] = true,
	["List the current error."] = true,
	["List errors from the current session."] = true,
	["List errors from the previous session."] = true,
	["List errors by session number."] = true,
	["List all errors."] = true,

	["Auto popup"] = true,
	["Toggle auto BugSack frame popup."] = true,
	["Chatframe output"] = true,
	["Print a warning to the chat frame when an error occurs."] = true,
	["Errors to chatframe"] = true,
	["Print the full error message to the chat frame instead of just a warning."] = true,
	["Mute"] = true,
	["Toggle an audible warning everytime an error occurs."] = true,
	["Save errors"] = true,
	["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = true,
	["Limit"] = true,
	["Set the limit on the nr of errors saved."] = true,

	["Generate bug"] = true,
	["Generate a fake bug for testing."] = true,
	["Script bug"] = true,
	["Generate a script bug."] = true,
	["Addon bug"] = true,
	["Generate an addon bug."] = true,

	["Clear errors"] = true,
	["Clear out the errors database."] = true,

	-- Chat messages
	["You have no errors, yay!"] = true,
	["List of errors:"] = true,
	["An error has been generated."] = true,
	["BugSack generated this fake error."] = true,
	["All errors were wiped."] = true,
	["An error has been recorded."] = true,
	["%d errors have been recorded."] = true,

	-- Frame messages,
	[" (... more ...)"] = true,
	["No errors found"] = true,
	["Error %d of %d"] = true,
	[" (viewing last error)"] = true,
	[" (viewing session errors)"] = true,
	[" (viewing previous session errors)"] = true,
	[" (viewing all errors)"] = true,
	[" (viewing errors for session %d)"] = true,

	-- FuBar plugin
	["Click to open the BugSack frame with the last error."] = true,
} end)


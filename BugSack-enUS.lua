local L = AceLibrary("AceLocale-2.0"):new("BugSack")

L:RegisterTranslations("enUS", function()
	return {
		-- Bindings
		["Show All"] = true,
		["Show Latest"] = true,

		-- Command descriptions
		["Show all errors"] = true,
		["Show the BugSack frame with all errors."] = true,
		["Show current error"] = true,
		["Show the BugSack frame with the current error."] = true,
		["Save bugs"] = true,
		["Toggle whether to save bugs or not."] = true,
		["Backtrace"] = true,
		["Show a backtrace for each error."] = true,
		["Auto popup"] = true,
		["Toggle auto BugSack frame popup."] = true,
		["Chat frame output"] = true,
		["Toggle printing of messages to the chat frame."] = true,
		["Audible warning"] = true,
		["Toggle an audible warning everytime an error occurs."] = true,
		["List errors"] = true,
		["List errors from a specific session."] = true,
		["Previous session"] = true,
		["List errors from the previous session."] = true,
		["By Session number"] = true,
		["List errors by session number."] = true,
		["Current session"] = true,
		["List errors from the current session."] = true,
		["Generate bug"] = true,
		["Generate a fake bug for testing."] = true,
		["Script bug"] = true,
		["Generate a script bug."] = true,
		["Addon bug"] = true,
		["Generate an addon bug."] = true,
		["Clear errors"] = true,
		["Clear out the errors database."] = true,

		-- Chat messages
		["List of errors:"] = true,
		["BugSack generated this fake error."] = true,
		["An error has been generated."] = true,
		["All errors were wiped."] = true,
		["An error has been recorded."] = true,
		["You have no errors, yay!"] = true,

		-- FuBar plugin
		["Click to open the BugSack frame with the current error."] = true,
	}
end)

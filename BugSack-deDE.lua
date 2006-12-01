-- deDE translation by Gamefaq

local L = AceLibrary("AceLocale-2.2"):new("BugSack")

L:RegisterTranslations("deDE", function()
	return {
		-- Bindings
		["Show Current Error"] = "Zeige den gegenw\195\164rtigen Error",
		["Show Session Errors"] = "Zeige alle Errors von dieser Sitzung",

		-- Command descriptions
		["Show sack"] = "Zeige Sack",
		["Show errors in the sack."] = "Zeigt Fehler die sich im Sack befinden.",
		["Current error"] = "Gegenw\195\164rtiger Fehler",
		["Show the current error."] = "Zeigt den gegenw\195\164rtigen Fehler.",
		["Current session"] = "Gegenw\195\164rtige Sitzung",
		["Show errors from the current session."] = "Zeigt alle Fehler die es in dieser Sitzung gab.",
		["Previous session"] = "Vorherige Sitzung",
		["Show errors from the previous session."] = "Zeigt alle Fehler aus der vorherigen Sitzung.",
		["By session number"] = "Nach Sitzungsnummer",
		["Show errors by session number."] = "Zeigt die Fehler aus der entsprechenden Sitzungsnummer.",
		["All errors"] = "Alle Fehler",
		["Show all errors."] = "Zeigt alle gespeicherten Fehler.",

		["List errors"] = "Liste Fehler",
		["List errors to the chat frame."] = "Listet die Fehler im Chatfenster.",
		["List the current error."] = "Liste den gegenw\195\164rtigen Fehler.",
		["List errors from the current session."] = "Listet die Fehler aus dieser Sitzung.",
		["List errors from the previous session."] = "Listet die Fehler auf der vorherigen Sitzung.",
		["List errors by session number."] = "Listet die Fehler aus der entsprechenden Sitzungnummer.",
		["List all errors."] = "Listet alle gespeicherten Fehler auf.",

		["Auto popup"] = "Auto aufspringen",
		["Toggle auto BugSack frame popup."] = "Schaltet das automatische einblenden des Fehler Fensters ein/aus.",
		["Chatframe output"] = "Chatfenster Ausgabe",
		["Print a warning to the chat frame when an error occurs."] = "Schreibe eine Wahrnung ins Chatfenster wenn ein Fehler auftritt.",
		["Errors to chatframe"] = "Fehler im Chatfenster",
		["Print the full error message to the chat frame instead of just a warning."] = "Schreibe die gesamte Fehler Nachricht in das Chatfenster anstelle nur einer Warnung.",
		["Mute"] = "Stumm",
		["Toggle an audible warning everytime an error occurs."] = "Schaltet den Audiosound bei Fehlern ein/aus.",
		["Save errors"] = "Fehler speichern",
		["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = "Schaltet das Speichern von Fehlern in der SavedVariables\\!BugGrabber.lua Datei ein/aus.",
		["Limit"] = "Begrenzung",
		["Set the limit on the nr of errors saved."] = "Setze eine Begrenzung wieviele Fehler maximal gespeichert werden.",
		--["Filter addon mistakes"] = true,
		--["Filters common mistakes that trigger the blocked/forbidden event."] = true,

		["Generate bug"] = "Generiere Fehler",
		["Generate a fake bug for testing."] = "Generiert einen falschen Fehler zum Testen des Addons.",
		["Script bug"] = "Script Fehler",
		["Generate a script bug."] = "Generiert einen Script Fehler.",
		["Addon bug"] = "Addon Fehler",
		["Generate an addon bug."] = "Generiert einen Addon Fehler.",

		["Clear errors"] = "L\195\182sche Fehler",
		["Clear out the errors database."] = "L\195\182scht alle Fehler aus der Datenbank.",

		-- Chat messages
		["You have no errors, yay!"] = "Du hast keine Fehler, Jeehaa!",
		["List of errors:"] = "Liste der Fehler:",
		["An error has been generated."] = "Ein Fehler wurde generiert.",
		["BugSack generated this fake error."] = "BugSack hat diesen Fehler generiert.",
		["All errors were wiped."] = "Alle Fehler wurden gel\195\182scht.",
		["An error has been recorded."] = "Ein Fehler wurde aufgezeichnet",
		--["%d errors have been recorded."] = true,

		-- Frame messages,
		[" (... more ...)"] = " (... mehr ...)",
		["No errors found"] = "Keine Fehler gefunden",
		["Error %d of %d"] = "Fehler %d von %d",
		[" (viewing last error)"] = " (zeige letzten Fehler)",
		[" (viewing session errors)"] = " (zeige Sitzungsfehler)",
		[" (viewing previous session errors)"] = " (zeige vorherige Sitzungsfehler)",
		[" (viewing all errors)"] = " (zeige alle aufgezeichneten Fehler)",
		[" (viewing errors for session %d)"] = " (zeige Fehler aus Sitzung %d)",

		-- FuBar plugin
		["Click to open the BugSack frame with the last error."] = "Klicken zum \195\182ffnen des BugSack Fensters mit dem letzten Fehler.",
	}
end)

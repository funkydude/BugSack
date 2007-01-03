-- deDE translation by Gamefaq

local L = AceLibrary("AceLocale-2.2"):new("BugSack")

L:RegisterTranslations("deDE", function()
	return {
	-- Bindings
	["Show Current Error"] = "Zeige den gegenwärtigen Error",
	["Show Session Errors"] = "Zeige alle Errors von dieser Sitzung",

	-- Command descriptions
	["Show sack"] = "Zeige Sack",
	["Show errors in the sack."] = "Zeigt Fehler die sich im Sack befinden.",
	["Current error"] = "Gegenwärtiger Fehler",
	["Show the current error."] = "Zeigt den gegenwärtigen Fehler.",
	["Current session"] = "Gegenwärtige Sitzung",
	["Show errors from the current session."] = "Zeigt alle Fehler die es in dieser Sitzung gab.",
	["Previous session"] = "Vorherige Sitzung",
	["Show errors from the previous session."] = "Zeigt alle Fehler aus der vorherigen Sitzung.",
	["By session number"] = "Nach Sitzungsnummer",
	["Show errors by session number."] = "Zeigt die Fehler aus der entsprechenden Sitzungsnummer.",
	["All errors"] = "Alle Fehler",
	["Show all errors."] = "Zeigt alle gespeicherten Fehler.",

	["List errors"] = "Liste Fehler",
	["List errors to the chat frame."] = "Listet die Fehler im Chatfenster.",
	["List the current error."] = "Liste den gegenwärtigen Fehler.",
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
	["Filter addon mistakes"] = "Filtere falsche Addon Fehler",
	["Filters common mistakes that trigger the blocked/forbidden event."] = "Filtert die bekannsten falschen Fehler welche die 'blocked/forbidden' Meldungen betrifft.",

	["Generate bug"] = "Generiere Fehler",
	["Generate a fake bug for testing."] = "Generiert einen falschen Fehler zum Testen des Addons.",
	["Script bug"] = "Script Fehler",
	["Generate a script bug."] = "Generiert einen Script Fehler.",
	["Addon bug"] = "Addon Fehler",
	["Generate an addon bug."] = "Generiert einen Addon Fehler.",

	["Clear errors"] = "Lösche Fehler",
	["Clear out the errors database."] = "Löscht alle Fehler aus der Datenbank.",

	-- Chat messages
	["You have no errors, yay!"] = "Du hast keine Fehler, Jeehaa!",
	["List of errors:"] = "Liste der Fehler:",
	["An error has been generated."] = "Ein Fehler wurde generiert.",
	["BugSack generated this fake error."] = "BugSack hat diesen Fehler generiert.",
	["All errors were wiped."] = "Alle Fehler wurden gelöscht.",
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
	["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = "|cffeda55fKlicken|r zum öffnen des BugSack Fensters mit dem letzten Fehler. |cffeda55fShift-Klicken|r um das Ui neu zu laden |cffeda55fAlt-Klicken|r um Fehler zu löschen"
	}
end)

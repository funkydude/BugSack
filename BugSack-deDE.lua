-- deDE translation by Gamefaq

local L = AceLibrary("AceLocale-2.2"):new("BugSack")

L:RegisterTranslations("deDE", function()
	return {
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
	["Received errors"] = "Empfangene Fehler",
	["Show errors received from another player."] = "Zeige empfangene Fehler von anderen Spielern.",
	["Send bugs"] = "Sende Fehler",
	["Sends your current session bugs to another user. Only works if both you and the recipient has an instance of AceComm-2.0 and BugSack loaded."] = "Sende deine gegenwärtigen Fehler zu einem anderen Spieler. Dies funktioniert nur wenn ihr beide die Datenbank AceComm-2.0 und BugSack geladen/aktiviert habt.",
	["<player name>"] = "<spieler name>",
	["Menu"] = "Menü",
	["Menu options."] = "Menü Optionen",

	["List errors"] = "Liste Fehler",
	["List errors to the chat frame."] = "Listet die Fehler im Chatfenster.",
	["List the current error."] = "Liste den gegenwärtigen Fehler.",
	["List errors from the current session."] = "Listet die Fehler aus dieser Sitzung.",
	["List errors from the previous session."] = "Listet die Fehler auf der vorherigen Sitzung.",
	["List errors by session number."] = "Listet die Fehler aus der entsprechenden Sitzungnummer.",
	["List all errors."] = "Listet alle gespeicherten Fehler auf.",
	["List errors received from another player."] = "Listet die empfangenen Fehler von anderen Spielern auf.",

	["Auto popup"] = "Auto aufspringen",
	["Toggle auto BugSack frame popup."] = "Schaltet das automatische einblenden des Fehler Fensters ein/aus.",
	["Chatframe output"] = "Chatfenster Ausgabe",
	["Print a warning to the chat frame when an error occurs."] = "Schreibe eine Wahrnung ins Chatfenster wenn ein Fehler auftritt.",
	["Errors to chatframe"] = "Fehler im Chatfenster",
	["Print the full error message to the chat frame instead of just a warning."] = "Schreibe die gesamte Fehler Nachricht in das Chatfenster anstelle nur einer Warnung.",
	["Sound"] = "Sound",
	["What sound to play when an error occurs (Ctrl-Click to preview.)"] = "Welchen Sound abspielen wenn ein Fehler auftritt (Strg+Klick zum Probehören).",
	["Mute"] = "Stumm",
	["Toggle an audible warning everytime an error occurs."] = "Schaltet den Audiosound bei Fehlern ein/aus.",
	["Save errors"] = "Fehler speichern",
	["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = "Schaltet das Speichern von Fehlern in der SavedVariables\\!BugGrabber.lua Datei ein/aus.",
	["Limit"] = "Begrenzung",
	["Set the limit on the nr of errors saved."] = "Setze eine Begrenzung wieviele Fehler maximal gespeichert werden.",
	["Filter addon mistakes"] = "Filtere falsche Addon Fehler",
	["Filters common mistakes that trigger the blocked/forbidden event."] = "Filtert die bekannsten falschen Fehler welche die 'blocked/forbidden' Meldungen betrifft.",
	["Throttle at excessive amount"] = "Bei Übermaß temporär drosseln",
	["Whether to throttle for a default of 60 seconds when BugGrabber catches more than 20 errors per second."] = "Die Fehleraufzeichnung für vorgegebene 60 Sekunden stoppen, wennn BugGrabber mehr als 20 Fehler pro Sekunde aufzeichnet.",

	["Generate bug"] = "Generiere Fehler",
	["Generate a fake bug for testing."] = "Generiert einen falschen Fehler zum Testen des Addons.",
	["Script bug"] = "Script Fehler",
	["Generate a script bug."] = "Generiert einen Script Fehler.",
	["Addon bug"] = "Addon Fehler",
	["Generate an addon bug."] = "Generiert einen Addon Fehler.",

	["Clear errors"] = "Lösche Fehler",
	["Clear out the errors database."] = "Löscht alle Fehler aus der Datenbank.",

	["%d sec."] = "%d sec.",
	["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."] = "|cffeda55fBugGrabber|r ist pausiert  wegen einer Überzahl an Fehlern die Generiert werden. Der normale Betrieb wird in |cffff0000%d|r sekunden wieder aufgenommen. |cffeda55fDoppel-Klicken|r um Betrieb jetzt wieder aufzunehmen.",


	-- Chat messages
	["You have no errors, yay!"] = "Du hast keine Fehler, Jeehaa!",
	["List of errors:"] = "Liste der Fehler:",
	["An error has been generated."] = "Ein Fehler wurde generiert.",
	["BugSack generated this fake error."] = "BugSack hat diesen Fehler generiert.",
	["All errors were wiped."] = "Alle Fehler wurden gelöscht.",
	["An error has been recorded."] = "Ein Fehler wurde aufgezeichnet.",
	["%d errors have been recorded."] = "%d Fehler wurden aufgezeichnet.",
	["You've received %d errors from %s, you can show them with /bugsack show received."] = "Du hast %d Fehler von %s empfangen, du kannst sie dir anzeigen lassen mit dem chat Befehl /bugsack show received.",
	["%d errors has been sent to %s. If he does not have both BugSack and AceComm-2.0, he will not be able to read them."] = "%d Fehler wurden gesendet zu %s.  Sollte er BugSack und AceComm-2.0 nicht haben, so wird er nicht  in der Lage sein die Fehler zu lesen.",

	-- Frame messages,
	[" (... more ...)"] = " (... mehr ...)",
	["No errors found"] = "Keine Fehler gefunden",
	["Error %d of %d"] = "Fehler %d von %d",
	[" (viewing last error)"] = " (zeige letzten Fehler)",
	[" (viewing session errors)"] = " (zeige Sitzungsfehler)",
	[" (viewing previous session errors)"] = " (zeige vorherige Sitzungsfehler)",
	[" (viewing all errors)"] = " (zeige alle aufgezeichneten Fehler)",
	[" (viewing errors for session %d)"] = " (zeige Fehler aus Sitzung %d)",
	[" (viewing errors from %s)"] = " (zeige Fehler von %s)",

	-- FuBar plugin
	["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = "|cffeda55fKlicken|r zum öffnen des BugSack Fensters mit dem letzten Fehler. |cffeda55fShift-Klicken|r um das Ui neu zu laden. |cffeda55fAlt-Klicken|r um die Fehler zu löschen."
	}
end)

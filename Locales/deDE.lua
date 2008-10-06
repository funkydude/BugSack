-- deDE translation by Gamefaq

local L = LibStub("AceLocale-3.0"):NewLocale("BugSack", "deDE")
if not L then return end

-- Command descriptions
L["Show sack"] = "Zeige Sack"
L["Show errors in the sack."] = "Zeigt Fehler die sich im Sack befinden."
L["Current error"] = "Gegenwärtiger Fehler"
L["Show the current error."] = "Zeigt den gegenwärtigen Fehler."
L["Current session"] = "Gegenwärtige Sitzung"
L["Show errors from the current session."] = "Zeigt alle Fehler die es in dieser Sitzung gab."
L["Previous session"] = "Vorherige Sitzung"
L["Show errors from the previous session."] = "Zeigt alle Fehler aus der vorherigen Sitzung."
L["By session number"] = "Nach Sitzungsnummer"
L["Show errors by session number."] = "Zeigt die Fehler aus der entsprechenden Sitzungsnummer."
L["All errors"] = "Alle Fehler"
L["Show all errors."] = "Zeigt alle gespeicherten Fehler."
L["Received errors"] = "Empfangene Fehler"
L["Show errors received from another player."] = "Zeige empfangene Fehler von anderen Spielern."
L["Send bugs"] = "Sende Fehler"
L["Sends your current session bugs to another BugSack user."] = "Sende Deine gegenwärtigen Fehler zu einem anderen Spieler. Dies funktioniert nur wenn beide die Datenbank AceComm-2.0 und BugSack geladen/aktiviert habt."
L["<player name>"] = "<spieler name>"
L["Menu"] = "Menü"
L["Menu options."] = "Menü Optionen"

L["List errors"] = "Liste Fehler"
L["List errors to the chat frame."] = "Listet die Fehler im Chatfenster."
L["List the current error."] = "Liste den gegenwärtigen Fehler."
L["List errors from the current session."] = "Listet die Fehler aus dieser Sitzung."
L["List errors from the previous session."] = "Listet die Fehler auf der vorherigen Sitzung."
L["List errors by session number."] = "Listet die Fehler aus der entsprechenden Sitzungnummer."
L["List all errors."] = "Listet alle gespeicherten Fehler auf."
L["List errors received from another player."] = "Listet die empfangenen Fehler von anderen Spielern auf."

L["Auto popup"] = "Autom. aufspringen"
L["Toggle auto BugSack frame popup."] = "Schaltet das automatische Einblenden des Fehlerfensters ein/aus."
L["Chatframe output"] = "Chatfenster Ausgabe"
L["Print a warning to the chat frame when an error occurs."] = "Schreibe eine Warnung ins Chatfenster wenn ein Fehler auftritt."
L["Errors to chatframe"] = "Fehler im Chatfenster"
L["Print the full error message to the chat frame instead of just a warning."] = "Schreibe die gesamte Fehlernachricht in das Chatfenster anstelle nur einer Warnung."
L["Mute"] = "Stumm"
L["Toggle an audible warning everytime an error occurs."] = "Schaltet den Audiosound bei Fehlern ein/aus."
L["Sound"] = "Sound"
L["What sound to play when an error occurs (Ctrl-Click to preview.)"] = "Sound, der abgespielt wird wenn ein Fehler auftritt (Strg+Klick zum Probehören)."
L["Save errors"] = "Fehler speichern"
L["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = "Schaltet das Speichern von Fehlern in der SavedVariables\\!BugGrabber.lua Datei ein/aus."
L["Limit"] = "Begrenzung"
L["Set the limit on the nr of errors saved."] = "Setze eine Begrenzung wieviele Fehler maximal gespeichert werden."
L["Filter addon mistakes"] = "Filtere falsche Addon Fehler"
L["Filters common mistakes that trigger the blocked/forbidden event."] = "Filtert die bekanntesten falschen Fehler, welche die 'blocked/forbidden' Meldungen betrifft."
L["Throttle at excessive amount"] = "Bei Übermaß temporär drosseln"
L["Whether to throttle for a default of 60 seconds when BugGrabber catches more than 20 errors per second."] = "Die Fehleraufzeichnung für vorgegebene 60 Sekunden stoppen, wennn BugGrabber mehr als 20 Fehler pro Sekunde aufzeichnet."

L["Generate bug"] = "Generiere Fehler"
L["Generate a fake bug for testing."] = "Generiert einen fingierten Fehler zum Testen des Addons."
L["Script bug"] = "Script Fehler"
L["Generate a script bug."] = "Generiert einen Script Fehler."
L["Addon bug"] = "Addon Fehler"
L["Generate an addon bug."] = "Generiert einen Addon Fehler."

L["Clear errors"] = "Lösche Fehler"
L["Clear out the errors database."] = "Löscht alle Fehler aus der Datenbank."

L["%d sec."] = "%d sec."
L["|cffeda55fBugGrabber|r is paused due to an excessive amount of errors being generated. It will resume normal operations in |cffff0000%d|r seconds. |cffeda55fDouble-Click|r to resume now."] = "|cffeda55fBugGrabber|r pausiert wegen einer Überzahl an generierten Fehlern. Der normale Betrieb wird in |cffff0000%d|r sekunden wieder aufgenommen. |cffeda55fDoppel-Klicken|r um Betrieb jetzt wieder aufzunehmen."

-- Chat messages
L["You have no errors, yay!"] = "Du hast keine Fehler, Jeehaa!"
L["List of errors:"] = "Liste der Fehler:"
L["An error has been generated."] = "Ein Fehler wurde generiert."
L["BugSack generated this fake error."] = "BugSack hat diesen fingierten Fehler generiert."
L["All errors were wiped."] = "Alle Fehler wurden gelöscht."
L["An error has been recorded."] = "Ein Fehler wurde aufgezeichnet."
L["%d errors have been recorded."] = "%d Fehler wurden aufgezeichnet."
L["You've received %d errors from %s, you can show them with /bugsack show received."] = "Du hast %d Fehler von %s empfangen, Du kannst sie dir mit dem chat Befehl /bugsack show received anzeigen lassen."
L["%d errors has been sent to %s. He must have BugSack to be able to read them."] = "%d Fehler wurden gesendet zu %s. Sollte er BugSack und AceComm-2.0 nicht haben, so wird er nicht in der Lage sein die Fehler zu lesen."

-- Frame messages,
L[" (... more ...)"] = " (... mehr ...)"
L["No errors found"] = "Keine Fehler gefunden"
L["Error %d of %d"] = "Fehler %d von %d"
L[" (viewing last error)"] = " (zeige letzten Fehler)"
L[" (viewing session errors)"] = " (zeige Sitzungsfehler)"
L[" (viewing previous session errors)"] = " (zeige vorherige Sitzungsfehler)"
L[" (viewing all errors)"] = " (zeige alle aufgezeichneten Fehler)"
L[" (viewing errors for session %d)"] = " (zeige Fehler aus Sitzung %d)"
L[" (viewing errors from %s)"] = " (zeige Fehler von %s)"

-- FuBar plugin
L["|cffeda55fClick|r to open BugSack with the last error. |cffeda55fShift-Click|r to reload the user interface. |cffeda55fAlt-Click|r to clear the sack."] = "|cffeda55fKlicken|r zum Öffnen des BugSack Fensters mit dem letzten Fehler. |cffeda55fShift-Klicken|r um das UI neu zu laden. |cffeda55fAlt-Klicken|r um die Fehler zu löschen."


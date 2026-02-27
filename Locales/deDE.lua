local addonName, addon = ...
if GetLocale() ~= "deDE" then return end

local L = {}

-- General
L["General.AllBugs"] = "Alle Fehler"
L["General.BugsExterminated"] = "Alle gespeicherten Fehler wurden auf schmerzvollste Art gelöscht."
L["General.CurrentSession"] = "Derzeitige Sitzung"
L["General.Filter"] = "Filter"
L["General.Local"] = "Lokal (%s)"
L["General.Next"] = "Nächster >"
L["General.Previous"] = "< Vorheriger"
L["General.PreviousSession"] = "Vorherige Sitzung"
L["General.Send"] = "Senden"
L["General.SendBugs"] = "Sende Fehler"
L["General.SentBy"] = "Gesendet von %s (%s)"
L["General.Today"] = "Heute"
L["General.NoBugs"] = "Du hast keine Fehler, jeehaa!"
L["General.BugInSoup"] = "Du hast einen Fehler entdeckt!"
L["General.QuickTipsTitle"] = "Kurztipps"
L["General.QuickTipsDesc"] = "Doppelklicken, um Fehlerberichte zu filtern. Nachdem Sie mit den Suchergebnissen fertig sind, kehren Sie zum vollständigen Sack zurück, indem Sie unten eine Registerkarte auswählen. Klicken Sie mit der linken Maustaste und ziehen Sie, um das Fenster zu verschieben. Klicken Sie mit der rechten Maustaste, um den Sack zu schließen und die Optionen für BugSack zu öffnen."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack benötigt das %s Addon, das von der Seite heruntergeladen werden kann, wo du auch BugSack bekommen hast. Happy bug hunting!"
L["ErrorMessage.DeserializeFail"] = "Fehler beim Deserialisieren eingehender Daten von %s."
L["ErrorMessage.InvalidPlayer"] = "Spieler muss ein gültiger Name sein."
L["ErrorMessage.BugsSent"] = "%d Fehler wurden an %s gesendet. Sie müssen BugSack haben, um in der Lage zu sein, die Fehler zu lesen."
L["ErrorMessage.SendPrompt"] = "Sendet alle Fehler der momentanen Sitzung (%d) im Sack an den unten stehenden Spieler."
L["ErrorMessage.BugsReceived"] = "Du hast %d Fehler von %s empfangen."

-- Options
L["Options.RestoreDefaults"] = "Standardeinstellungen"
L["Options.RestoreDefaultsDesc"] = "Setzt alle BugSack-Einstellungen auf ihre Standardwerte zurück."
L["Options.EnablePopup"] = "Automatisches Aufpoppen"
L["Options.EnablePopupDesc"] = "Öffnet BugSack automatisch, sobald ein Fehler auftritt, außer man befindet sich im Kampf."
L["Options.EnablePrintMessages"] = "Chatfensterausgabe"
L["Options.EnablePrintMessagesDesc"] = "Gibt eine Erinnerung im Chatfenster aus, dass ein Fehler aufgetreten ist. Zeigt nicht den kompletten Fehler an!"
L["Options.EnableSoundEffects"] = "Soundeffekte aktivieren"
L["Options.EnableSoundEffectsDesc"] = "Ermöglicht BugSack, einen Ton abzuspielen, wenn ein Fehler erkannt wird."
L["Options.Sound"] = "Sound"
L["Options.SoundPreview"] = "Sound-Vorschau"
L["Options.UseMaster"] = "'Master' Soundkanal nutzen"
L["Options.UseMasterDesc"] = "Spielt den ausgewählten Fehlerton über den 'Master'-Kanal anstelle des Standardkanals ab."
L["Options.EraseBugs"] = "Gespeich. Fehler löschen"
L["Options.EraseBugsDesc"] = "Löscht alle gespeicherten Fehler aus der Datenbank."
L["Options.EnableMinimapButton"] = "Minikartensymbol aktivieren"
L["Options.EnableMinimapButtonDesc"] = "Zeigt oder versteckt das BugSack-Symbol an deiner Minikarte."
L["Options.AddonCompartment"] = "Addon-Fach-Symbol"
L["Options.AddonCompartmentDesc"] = "Erstellt einen Menüeintrag im 'Addon-Fach' für BugSack."
L["Options.BugWindowFontSize"] = "Fehlerfenster Schriftgröße"
L["Options.FontSize"] = "Schriftgröße"

-- Font sizes
L["FontSize.Small"] = "Klein"
L["FontSize.Medium"] = "Mittel"
L["FontSize.Large"] = "Groß"
L["FontSize.XLarge"] = "Sehr groß"

-- Minimap
L["Minimap.Click"] = "Klicken"
L["Minimap.ClickAction"] = "Öffnen"
L["Minimap.RightClick"] = "Rechtsklick"
L["Minimap.RightClickAction"] = "Optionen"
L["Minimap.MiddleClick"] = "Mittelklick"
L["Minimap.MiddleClickAction"] = "Ton umschalten"
L["Minimap.ShiftClick"] = "Shift + Klick"
L["Minimap.ShiftClickAction"] = "Interface neu laden"
L["Minimap.ShiftMiddleClick"] = "Shift + Mittelklick"
L["Minimap.ShiftMiddleClickAction"] = "Fehler leeren"

addon.L = L
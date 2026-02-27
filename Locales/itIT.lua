local addonName, addon = ...
if GetLocale() ~= "itIT" then return end

local L = {}

-- General
L["General.AllBugs"] = "Tutti i bug"
L["General.BugsExterminated"] = "Tutti i bug registrati sono stati eliminati con dolore."
L["General.CurrentSession"] = "Sessione corrente"
L["General.Filter"] = "Filtro"
L["General.Local"] = "Locale (%s)"
L["General.Next"] = "Successivo >"
L["General.Previous"] = "< Precedente"
L["General.PreviousSession"] = "Sessione precedente"
L["General.Send"] = "Invia"
L["General.SendBugs"] = "Invia bugs"
L["General.SentBy"] = "Inviato da %s (%s)"
L["General.Today"] = "Oggi"
L["General.NoBugs"] = "Nessun bug rilevato!"
L["General.BugInSoup"] = "Un bug è stato rilevato!"
L["General.QuickTipsTitle"] = "Suggerimenti rapidi"
L["General.QuickTipsDesc"] = "Doppio-clic per filtrare gli elenchi dei bugs. Un volta terminato con la ricerca, ritorna all'indice principale selezionando una delle schede in basso. Clic-Sinistro e trascina per muovere la finestra. Clic-Destro per chiudere il sacchetto e aprire le opzioni interfaccia per BugSack."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack richiede l'addon %s, che puoi scaricare dallo stesso posto da cui hai scaricato BugSack. Buona caccia ai bugs!"
L["ErrorMessage.DeserializeFail"] = "Impossibile deserializzare i dati in arrivo da %s."
L["ErrorMessage.InvalidPlayer"] = "Il giocatore deve avere un nome valido."
L["ErrorMessage.BugsSent"] = "%d bugs sono stati inviati a %s. Devono avere BugSack installato per poterli esaminare."
L["ErrorMessage.SendPrompt"] = "Invia tutti i bug nel sacchetto della sessione attualmente visualizzata (%d) al giocatore specificato."
L["ErrorMessage.BugsReceived"] = "Hai ricevuto %d bugs da %s."

-- Options
L["Options.RestoreDefaults"] = "Ripristina impostazioni"
L["Options.RestoreDefaultsDesc"] = "Ripristina tutte le impostazioni di BugSack ai valori predefiniti."
L["Options.EnablePopup"] = "Auto popup"
L["Options.EnablePopupDesc"] = "Apre automaticamente BugSack quando viene rilevato un errore, ma non quando sei in combattimento."
L["Options.EnablePrintMessages"] = "Output della chat"
L["Options.EnablePrintMessagesDesc"] = "Manda un'avviso in chat quando un errore viene rilevato. Non scrive l'errore completo, solo un'avviso!"
L["Options.EnableSoundEffects"] = "Abilita effetti sonori"
L["Options.EnableSoundEffectsDesc"] = "Consente a BugSack di riprodurre un suono quando viene rilevato un bug."
L["Options.Sound"] = "Suono"
L["Options.SoundPreview"] = "Anteprima suono"
L["Options.UseMaster"] = "Usa canale audio 'Master'"
L["Options.UseMasterDesc"] = "Riproduci il suono di errore scelto sul canale 'Master' invece che su quello predefinito."
L["Options.EraseBugs"] = "Elimina bug salvati"
L["Options.EraseBugsDesc"] = "Elimina tutti i bug registarti dal database."
L["Options.EnableMinimapButton"] = "Icona minimappa"
L["Options.EnableMinimapButtonDesc"] = "Mostra l'icona di BugSack intorno alla minimappa."
L["Options.AddonCompartment"] = "Icona compartimento Addon"
L["Options.AddonCompartmentDesc"] = "Crea una voce menù nella 'Lista Compartimento Addon' per BugSack."
L["Options.BugWindowFontSize"] = "Dimensione carattere finestra"
L["Options.FontSize"] = "Dimensione carattere"

-- Font sizes
L["FontSize.Small"] = "Piccolo"
L["FontSize.Medium"] = "Medio"
L["FontSize.Large"] = "Largo"
L["FontSize.XLarge"] = "Molto largo"

-- Minimap
L["Minimap.Click"] = "Clic"
L["Minimap.ClickAction"] = "Apri"
L["Minimap.RightClick"] = "Clic-Destro"
L["Minimap.RightClickAction"] = "Opzioni"
L["Minimap.MiddleClick"] = "Clic-Centrale"
L["Minimap.MiddleClickAction"] = "Attiva/Disattiva suono"
L["Minimap.ShiftClick"] = "Maiusc + Clic"
L["Minimap.ShiftClickAction"] = "Ricarica interfaccia"
L["Minimap.ShiftMiddleClick"] = "Maiusc + Clic-Centrale"
L["Minimap.ShiftMiddleClickAction"] = "Svuota bugs"

addon.L = L
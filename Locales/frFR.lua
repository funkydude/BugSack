local addonName, addon = ...
if GetLocale() ~= "frFR" then return end

local L = {}

-- General
L["General.AllBugs"] = "Tous les bugs"
L["General.BugsExterminated"] = "Tous les bugs enregistrés ont été exterminés douloureusement."
L["General.CurrentSession"] = "Session actuelle"
L["General.Filter"] = "Filtre"
L["General.Local"] = "Locale (%s)"
L["General.Next"] = "Suivant >"
L["General.Previous"] = "< Précédent"
L["General.PreviousSession"] = "Session précédente"
L["General.Send"] = "Envoyer"
L["General.SendBugs"] = "Envoyer les bugs"
L["General.SentBy"] = "Envoyé par %s (%s)"
L["General.Today"] = "Aujourd'hui"
L["General.NoBugs"] = "Aucun bug détecté, hourra !"
L["General.BugInSoup"] = "Il y a un bug dans ta soupe !"
L["General.QuickTipsTitle"] = "Astuces rapides"
L["General.QuickTipsDesc"] = "Double clic pour filtrer les rapports de bugs. Pour revenir à la liste complète, sélectionnez un onglet en bas. Clic gauche pour déplacer la fenêtre. Clic droit pour fermer le sac et ouvrir les options de BugSack."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack nécessite l'AddOn %s, que vous pouvez télécharger au même endroit que BugSack. Bonne chasse aux bugs !"
L["ErrorMessage.DeserializeFail"] = "Échec de désérialisation des données reçues de %s."
L["ErrorMessage.InvalidPlayer"] = "Le nom du joueur doit être valide."
L["ErrorMessage.BugsSent"] = "%d bugs ont été envoyés à %s. Ils doivent avoir BugSack installé pour pouvoir les examiner."
L["ErrorMessage.SendPrompt"] = "Envoyer tous les bugs de la session actuelle (%d) au joueur spécifié ci-dessous."
L["ErrorMessage.BugsReceived"] = "Vous avez reçu %d bugs de %s."

-- Options
L["Options.RestoreDefaults"] = "Paramètres par défaut"
L["Options.RestoreDefaultsDesc"] = "Restaure tous les paramètres de BugSack à leurs valeurs par défaut."
L["Options.EnablePopup"] = "Popup automatique"
L["Options.EnablePopupDesc"] = "Ouvre automatiquement BugSack lorsqu'une erreur est détectée, sauf en combat."
L["Options.EnablePrintMessages"] = "Sortie vers la fenêtre de discussion"
L["Options.EnablePrintMessagesDesc"] = "Affiche un rappel dans la fenêtre de discussion lorsqu'une erreur est détectée. N'affiche pas toute l'erreur, juste un rappel !"
L["Options.EnableSoundEffects"] = "Activer les effets sonores"
L["Options.EnableSoundEffectsDesc"] = "Autorise BugSack à jouer un son lorsqu'un bug est détecté."
L["Options.Sound"] = "Son"
L["Options.SoundPreview"] = "Prévisualiser le son"
L["Options.UseMaster"] = "Utiliser le canal audio 'Master'"
L["Options.UseMasterDesc"] = "Joue le son d'erreur sélectionné via le canal audio 'Master' au lieu du canal par défaut."
L["Options.EraseBugs"] = "Effacer les bugs enregistrés"
L["Options.EraseBugsDesc"] = "Supprime tous les bugs enregistrés dans la base de données."
L["Options.EnableMinimapButton"] = "Activer l'icône mini-carte"
L["Options.EnableMinimapButtonDesc"] = "Affiche l'icône de BugSack autour de la mini-carte."
L["Options.AddonCompartment"] = "Icône du compartiment d'AddOn"
L["Options.AddonCompartmentDesc"] = "Ajoute une entrée pour BugSack dans le compartiment d'AddOn."
L["Options.BugWindowFontSize"] = "Taille de police de la fenêtre"
L["Options.FontSize"] = "Taille de police"

-- Font sizes
L["FontSize.Small"] = "Petite"
L["FontSize.Medium"] = "Moyenne"
L["FontSize.Large"] = "Grande"
L["FontSize.XLarge"] = "Très grande"

-- Minimap
L["Minimap.Click"] = "Clic"
L["Minimap.ClickAction"] = "Ouvrir"
L["Minimap.RightClick"] = "Clic-droit"
L["Minimap.RightClickAction"] = "Options"
L["Minimap.MiddleClick"] = "Clic-molette"
L["Minimap.MiddleClickAction"] = "Activer/désactiver le son"
L["Minimap.ShiftClick"] = "Maj + Clic"
L["Minimap.ShiftClickAction"] = "Recharger l'interface"
L["Minimap.ShiftMiddleClick"] = "Maj + Clic-molette"
L["Minimap.ShiftMiddleClickAction"] = "Effacer les bugs"

addon.L = L
local addonName, addon = ...
if GetLocale() ~= "esES" then return end

local L = {}

-- General
L["General.AllBugs"] = "Todos errores"
L["General.BugsExterminated"] = "Todos los errores almacenados se han limpiado."
L["General.CurrentSession"] = "Sesión actual"
L["General.Filter"] = "Filtro"
L["General.Local"] = "Local (%s)"
L["General.Next"] = "Siguiente >"
L["General.Previous"] = "< Previo"
L["General.PreviousSession"] = "Sesión anterior"
L["General.Send"] = "Enviar"
L["General.SendBugs"] = "Enviar errores"
L["General.SentBy"] = "Enviado por %s (%s)"
L["General.Today"] = "Hoy"
L["General.NoBugs"] = "No tienes ningún errores! ¡Hurra!"
L["General.BugInSoup"] = "Ha ocurrido un error!"
L["General.QuickTipsTitle"] = "Consejos rápidos"
L["General.QuickTipsDesc"] = "Haz doble clic para filtrar informes de errores. Cuando termines, vuelve al saco completo seleccionando una pestaña en la parte inferior. Haz clic izquierdo y arrastra para mover la ventana. Haz clic derecho para cerrar el saco y abrir las opciones."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack requirere el accesorio %s, que puedes descargar desde el mismo lugar que has descargado BugSack."
L["ErrorMessage.DeserializeFail"] = "No se puede deserializar el dato recibido de %s."
L["ErrorMessage.InvalidPlayer"] = "Nombre no válido."
L["ErrorMessage.BugsSent"] = "Enviado %d errores a %s. Ellos deben tener BugSack para verlos."
L["ErrorMessage.SendPrompt"] = "Enviar todos los errores de la sesión seleccionada (%d) al jugador se especifican abajo."
L["ErrorMessage.BugsReceived"] = "Has recibido %d errores por %s."

-- Options
L["Options.RestoreDefaults"] = "Restaurar por defecto"
L["Options.RestoreDefaultsDesc"] = "Restaura todos los ajustes de BugSack a sus valores predeterminados."
L["Options.EnablePopup"] = "Auto aparecen"
L["Options.EnablePopupDesc"] = "Aparecer la BugSack automáticamente cuando se produce un error, pero no cuando estás en combate."
L["Options.EnablePrintMessages"] = "Salida en chat"
L["Options.EnablePrintMessagesDesc"] = "Mostrar un aviso en la ventana de chat cuando se produce un error. No imprime todo el error!"
L["Options.EnableSoundEffects"] = "Activar efectos de sonido"
L["Options.EnableSoundEffectsDesc"] = "Permite a BugSack reproducir un sonido cuando se detecta un error."
L["Options.Sound"] = "Sonido"
L["Options.SoundPreview"] = "Vista previa de sonido"
L["Options.UseMaster"] = "Usar canal de sonido 'Master'"
L["Options.UseMasterDesc"] = "Reproducir el sonido de error elegido en el canal 'Master' en lugar del predeterminado."
L["Options.EraseBugs"] = "Limpiar errores almacenados"
L["Options.EraseBugsDesc"] = "Borrar todos los errores almacenados de la base de datos."
L["Options.EnableMinimapButton"] = "Icono en minimapa"
L["Options.EnableMinimapButtonDesc"] = "Mostrar el icono de BugSack en la minimapa."
L["Options.AddonCompartment"] = "Icono en el compartimiento"
L["Options.AddonCompartmentDesc"] = "Crea una entrada en el compartimiento de Addons."
L["Options.BugWindowFontSize"] = "Tamaño de fuente de errores"
L["Options.FontSize"] = "Tamaño de fuente"

-- Font sizes
L["FontSize.Small"] = "Pequeño"
L["FontSize.Medium"] = "Medio"
L["FontSize.Large"] = "Grande"
L["FontSize.XLarge"] = "Extra grande"

-- Minimap
L["Minimap.Click"] = "Clic"
L["Minimap.ClickAction"] = "Abrir"
L["Minimap.RightClick"] = "Clic-Derecho"
L["Minimap.RightClickAction"] = "Opciones"
L["Minimap.MiddleClick"] = "Clic-Central"
L["Minimap.MiddleClickAction"] = "Alternar sonido"
L["Minimap.ShiftClick"] = "Mayús + Clic"
L["Minimap.ShiftClickAction"] = "Recargar interfaz"
L["Minimap.ShiftMiddleClick"] = "Mayús + Clic-Central"
L["Minimap.ShiftMiddleClickAction"] = "Limpiar errores"
L["Minimap.AltClick"] = "Alt-Clic"
L["Minimap.AltClickAction"] = "Borrar errores"

addon.L = L
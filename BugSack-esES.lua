local L = AceLibrary("AceLocale-2.2"):new("BugSack")

L:RegisterTranslations("esES", function() return {
	-- Bindings
	["Show Current Error"] = "Mostrar el Error Actual",
	["Show Session Errors"] = "Mostrar los Errores de Sesi\195\179n",

	-- Command descriptions
	["Show sack"] = "Mostrar el saco",
	["Show errors in the sack."] = "Muestra los errores en el saco.",
	["Current error"] = "Error actual",
	["Show the current error."] = "Muestra el error actual.",
	["Current session"] = "Sesi\195\179n actual",
	["Show errors from the current session."] = "Muestra los errores de la sesi\195\179n actual",
	["Previous session"] = "Sesi\195\179n previa",
	["Show errors from the previous session."] = "Muestra los errores de la sesi\195\179n previa.",
	["By session number"] = "Por n\195\186mero de sesi\195\179n",
	["Show errors by session number."] = "Muestra los errores por el n\195\186mero de sesi\195\179n.",
	["All errors"] = "Todos los errores",
	["Show all errors."] = "Mostrar todos los errores",

	["List errors"] = "Mostrar lista de errores",
	["List errors to the chat frame."] = "Muestra la lista de errores en la ventana de chat.",
	["List the current error."] = "Mostrar lista de errores actuales",
	["List errors from the current session."] = "Mostrar lista de errores de la sesi\195\179n actual",
	["List errors from the previous session."] = "Mostrar errores de la sesi\195\179n previa",
	["List errors by session number."] = "Mostrar lista de errores por n\195\186mero de sesi\195\179n",
	["List all errors."] = "Mostrar lista con todos los errores",

	["Auto popup"] = "Ventana emergente autom\194\191tica",
	["Toggle auto BugSack frame popup."] = "Alterna la activaci\195\179n de la ventana emergente de BugSack.",
	["Chatframe output"] = "Mostrar en la ventana de chat",
	["Print a warning to the chat frame when an error occurs."] = "Muestra un aviso en la ventana de chat cuando ocurre un error.",
	["Errors to chatframe"] = "Errores en la ventana de chat",
	["Print the full error message to the chat frame instead of just a warning."] = "Mostrar el mensaje de error completo en la ventana de chat en vez de solo un aviso",
	["Mute"] = "Enmudecer",
	["Toggle an audible warning everytime an error occurs."] = "Commuta un aviso auditivo cada vez que ocurre un error.",
	["Save errors"] = "Guardar errores",
	["Toggle whether to save errors to your SavedVariables\\!BugGrabber.lua file."] = "Determina si se graban los errores en tu archivo SavedVariables\\!BugGrabber.lua",
	["Limit"] = "L\195\173mite",
	["Set the limit on the nr of errors saved."] = "Establece el l\195\173mite de los n\195\186mero de errores guardados.",
	["Filter addon mistakes"] = "Filtrar errores del accesorio",
	["Filters common mistakes that trigger the blocked/forbidden event."] = "Filtra errores comunes que hacen saltar el evento de bloqueado/prohibido.",

	["Generate bug"] = "Generar bug",
	["Generate a fake bug for testing."] = "Genera un bug falso para hacer pruebas.",
	["Script bug"] = "Bug de script",
	["Generate a script bug."] = "Genera un bug de script",
	["Addon bug"] = "Bug de accesorio",
	["Generate an addon bug."] = "Genera un bug de accesorio.",

	["Clear errors"] = "Limpiar errores",
	["Clear out the errors database."] = "Limipa los errores de la base de datos.",

	-- Chat messages
	["You have no errors, yay!"] = "\194\161No tienes errores, chachi!",
	["List of errors:"] = "Lista de errores:",
	["An error has been generated."] = "Se ha generado un error.",
	["BugSack generated this fake error."] = "BugSack ha generado este falso error.",
	["All errors were wiped."] = "Todos los errores fueron limpiados.",
	["An error has been recorded."] = "Se ha guardado un error.",
	["%d errors have been recorded."] = "%d errores han sido guardados.",

	-- Frame messages,
	[" (... more ...)"] = " (... m\194\191s ...)",
	["No errors found"] = "No se han encontrado errores",
	["Error %d of %d"] = "Error %d de %d",
	[" (viewing last error)"] = " (viendo el \195\186ltimo error)",
	[" (viewing session errors)"] = " (viendo los errores de la sesi\195\179n)",
	[" (viewing previous session errors)"] = " (viendo los errores de sesiones previas)",
	[" (viewing all errors)"] = " (viendo todos los errores)",
	[" (viewing errors for session %d)"] = " (viendo errores para la sesi\195\179n %d)",

	-- FuBar plugin
	["Click to open the BugSack frame with the last error."] = "Pulsa para abrir la ventana de BugSack con el \195\186ltimo error.",
} end)


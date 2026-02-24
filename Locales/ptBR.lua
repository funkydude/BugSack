local addonName, addon = ...
if GetLocale() ~= "ptBR" then return end

local L = {}

-- General
L["General.AllBugs"] = "Todas as falhas"
L["General.BugsExterminated"] = "Todas as falhas armazenadas foram exterminadas dolorosamente."
L["General.CurrentSession"] = "Sessão atual"
L["General.Filter"] = "Filtro"
L["General.Local"] = "Local (%s)"
L["General.Next"] = "Próximo >"
L["General.Previous"] = "< Anterior"
L["General.PreviousSession"] = "Sessão anterior"
L["General.Send"] = "Enviar"
L["General.SendBugs"] = "Enviar falhas"
L["General.SentBy"] = "Enviado por %s (%s)"
L["General.Today"] = "Hoje"
L["General.NoBugs"] = "Você não possui falhas, êêê!"
L["General.BugInSoup"] = "Tem um inseto (falha) em sua sopa!"
L["General.QuickTipsTitle"] = "Dicas rápidas"
L["General.QuickTipsDesc"] = "Dê um clique duplo para filtrar os relatórios de falhas. Após concluir a pesquisa, retorne ao saco completo selecionando uma aba na parte inferior. Clique com o botão esquerdo e arraste para mover a janela. Clique com o botão direito para fechar o saco e abrir as opções."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack requer o addon %s, que você pode baixar do mesmo lugar que você baixou o BugSack. Feliz caça aos insetos (falhas)!"
L["ErrorMessage.DeserializeFail"] = "Falha ao desserializar dados que chegam de %s."
L["ErrorMessage.InvalidPlayer"] = "O jogador precisa ter um nome válido."
L["ErrorMessage.BugsSent"] = "%d falhas foram enviadas para %s. Eles devem ter o BugSack para poder examiná-las."
L["ErrorMessage.SendPrompt"] = "Enviar todas as falhas da atual sessão visualizada (%d) no saco para o jogador especificado abaixo."
L["ErrorMessage.BugsReceived"] = "Você recebeu %d falhas de %s."

-- Options
L["Options.RestoreDefaults"] = "Restaurar padrões"
L["Options.RestoreDefaultsDesc"] = "Restaura todas as configurações do BugSack para seus valores padrão."
L["Options.EnablePopup"] = "Janela automática"
L["Options.EnablePopupDesc"] = "Faz o BugSack abrir automaticamente quando um erro for encontrado, mas não enquanto você estiver em combate."
L["Options.EnablePrintMessages"] = "Saída do quadro de chat"
L["Options.EnablePrintMessagesDesc"] = "Imprime um lembrete no quadro de chat quando um erro for encontrado. Não imprime o erro completo, só um lembrete!"
L["Options.EnableSoundEffects"] = "Ativar efeitos sonoros"
L["Options.EnableSoundEffectsDesc"] = "Permite ao BugSack tocar um som quando uma falha for detectada."
L["Options.Sound"] = "Som"
L["Options.SoundPreview"] = "Pré-visualizar som"
L["Options.UseMaster"] = "Usar canal de som 'Master'"
L["Options.UseMasterDesc"] = "Tocar o som de erro escolhido no canal 'Master' em vez do padrão."
L["Options.EraseBugs"] = "Descartar falhas salvas"
L["Options.EraseBugsDesc"] = "Extermina todas as falhas salvas no banco de dados."
L["Options.EnableMinimapButton"] = "Ícone do minimapa"
L["Options.EnableMinimapButtonDesc"] = "Mostra o ícone do BugSack ao redor do seu minimapa."
L["Options.AddonCompartment"] = "Ícone do compartimento de Addons"
L["Options.AddonCompartmentDesc"] = "Cria uma entrada no compartimento de Addons para o BugSack."
L["Options.BugWindowFontSize"] = "Tamanho da fonte da janela"
L["Options.FontSize"] = "Tamanho da fonte"

-- Font sizes
L["FontSize.Small"] = "Pequeno"
L["FontSize.Medium"] = "Médio"
L["FontSize.Large"] = "Grande"
L["FontSize.XLarge"] = "X-Grande"

-- Minimap
L["Minimap.Click"] = "Clique"
L["Minimap.ClickAction"] = "Abrir"
L["Minimap.RightClick"] = "Clique-direito"
L["Minimap.RightClickAction"] = "Opções"
L["Minimap.MiddleClick"] = "Clique-do-meio"
L["Minimap.MiddleClickAction"] = "Alternar som"
L["Minimap.ShiftClick"] = "Shift + Clique"
L["Minimap.ShiftClickAction"] = "Recarregar interface"
L["Minimap.ShiftMiddleClick"] = "Shift + Clique-do-meio"
L["Minimap.ShiftMiddleClickAction"] = "Limpar falhas"
L["Minimap.AltClick"] = "Alt-Clique"
L["Minimap.AltClickAction"] = "Limpar falhas"

addon.L = L
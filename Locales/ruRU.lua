local addonName, addon = ...
if GetLocale() ~= "ruRU" then return end

local L = {}

-- General
L["General.AllBugs"] = "Все баги"
L["General.BugsExterminated"] = "Все сохраненные баги были тщательно уничтожены."
L["General.CurrentSession"] = "Текущая сессия"
L["General.Filter"] = "Фильтр"
L["General.Local"] = "Локально (%s)"
L["General.Next"] = "Следующие >"
L["General.Previous"] = "< Предыдущие"
L["General.PreviousSession"] = "Предыдущая сессия"
L["General.Send"] = "Отправить"
L["General.SendBugs"] = "Отправить баги"
L["General.SentBy"] = "Отправлено от %s (%s)"
L["General.Today"] = "Сегодня"
L["General.NoBugs"] = "Ух ты, нет багов!"
L["General.BugInSoup"] = "У тебя муха в супе!"
L["General.QuickTipsTitle"] = "Быстрые советы"
L["General.QuickTipsDesc"] = "Двойной щелчок - отфильтровать баги. После того, как Вы закончите с результатами поиска, вернитесь к полному списку, выбрав вкладку внизу. ЛКМ + перемещение - переместить окно. ПКМ - закрыть мешок и открыть настройки BugSack."

-- Error Messages
L["ErrorMessage.RequireGrabber"] = "BugSack'у необходим аддон %s, который можно скачать там же, где Вы взяли BugSack. Удачной охоты на баги!"
L["ErrorMessage.DeserializeFail"] = "Не смог разобрать входящие данные от %s."
L["ErrorMessage.InvalidPlayer"] = "Необходимо правильное имя игрока."
L["ErrorMessage.BugsSent"] = "%d багов было отослано получателю %s. Получатель должен иметь установленный BugSack для просмотра."
L["ErrorMessage.SendPrompt"] = "Отправить все баги из текущей просматриваемой сессии (%d) игроку, указанному ниже."
L["ErrorMessage.BugsReceived"] = "Вы получили %d багов от %s."

-- Options
L["Options.RestoreDefaults"] = "Восстановить по умолчанию"
L["Options.RestoreDefaultsDesc"] = "Восстанавливает все настройки BugSack по умолчанию."
L["Options.EnablePopup"] = "Автоматическое всплывающее окно"
L["Options.EnablePopupDesc"] = "Автоматически открывает окошко BugSack при возникновении ошибки, но только если Вы не в бою."
L["Options.EnablePrintMessages"] = "Вывод в окно чата"
L["Options.EnablePrintMessagesDesc"] = "Выводит в чат напоминание, что произошла ошибка. Не ошибку, а напоминание!"
L["Options.EnableSoundEffects"] = "Включить звуковые эффекты"
L["Options.EnableSoundEffectsDesc"] = "Разрешает BugSack воспроизводить звук при обнаружении бага."
L["Options.Sound"] = "Звук"
L["Options.SoundPreview"] = "Прослушать звук"
L["Options.UseMaster"] = "Использовать канал звука 'Master'"
L["Options.UseMasterDesc"] = "Воспроизводить выбранный звук ошибки в канале звука 'Master'."
L["Options.EraseBugs"] = "Удалить сохраненные баги"
L["Options.EraseBugsDesc"] = "Удаляет все сохраненные баги из базы."
L["Options.EnableMinimapButton"] = "Иконка на миникарте"
L["Options.EnableMinimapButtonDesc"] = "Показывать иконку BugSack на миникарте."
L["Options.AddonCompartment"] = "Иконка в отделении для аддонов"
L["Options.AddonCompartmentDesc"] = "Показывать иконку BugSack в 'Отделении для аддонов'."
L["Options.BugWindowFontSize"] = "Размер шрифта окна ошибок"
L["Options.FontSize"] = "Размер шрифта"

-- Font sizes
L["FontSize.Small"] = "Маленький"
L["FontSize.Medium"] = "Средний"
L["FontSize.Large"] = "Большой"
L["FontSize.XLarge"] = "Очень большой"

-- Minimap
L["Minimap.Click"] = "ЛКМ"
L["Minimap.ClickAction"] = "Открыть"
L["Minimap.RightClick"] = "ПКМ"
L["Minimap.RightClickAction"] = "Настройки"
L["Minimap.MiddleClick"] = "СКМ"
L["Minimap.MiddleClickAction"] = "Вкл/выкл звук"
L["Minimap.ShiftClick"] = "Shift + ЛКМ"
L["Minimap.ShiftClickAction"] = "Перезагрузить интерфейс"
L["Minimap.ShiftMiddleClick"] = "Shift + СКМ"
L["Minimap.ShiftMiddleClickAction"] = "Очистить ошибки"

addon.L = L
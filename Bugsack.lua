-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Chapter I: Localized Constants.                       --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

if not ace:LoadTranslation("BugSack") then

--<< ================================================= >>--
-- Page I: Keybindings.                                  --
--<< ================================================= >>--

BINDING_HEADER_BUGSACK           = "BugSack"
BINDING_NAME_BUGSACK_SHOW_ALL    = "Show All"
BINDING_NAME_BUGSACK_SHOW_LATEST = "Show Latest"

--<< ================================================= >>--
-- Page II: Chat Options.                                --
--<< ================================================= >>--

BugSack.Const         = {

   ChatCmd            = {"/bugsack", "/bs"},

   ChatOpt            = {
      {
         option       = "show",
         desc         = "show the BugSack display frame.",
         method       = "ShowFrame",
         args         = {
            {
               option = "curr",
               desc   = "highlight the current error."
            }
         }         
      },
      {
         option       = "save",
         desc         = "toggle whether to save bugs or not.",
         method       = "Save"
      },
      {
         option       = "auto",
         desc         = "toggle auto-popping of the frame.",
         method       = "AutoShow"
      },
      {
         option       = "msg",
         desc         = "toggle printing of messages to chat frame",
         method       = "PrintMsg"
      },
      {
         option       = "sound",
         desc         = "enable/disable audible warning.",
         method       = "Sound"
      },
      {
         option       = "list",
         desc         = "list the current-session errors.",
         method       = "ListErrors",
         args         = {
            {
               option = "all",
               desc   = "list all the errors."
            },
            {
               option = "previous",
               desc   = "list previous errors."
            },
            {
               option = "#",
               desc   = "list from session #."
            }
         }
      },
      {
         option       = "bug",
         desc         = "generate a fake bug (testing).",
         method       = "Bug",
         input        = TRUE,
         args         = {
            {
               option = "script",
               desc   = "generate a script bug.",
               method = "ScriptBug"
            },
            {
               option = "addon",
               desc   = "generate an Addon bug.",
               method = "AddonBug"
            }
         }
      },
      {
         option       = "reset",
         desc         = "clear out the errors database.",
         method       = "Reset"
      }
   },

--<< ================================================= >>--
-- Page III: AddOn Information.                          --
--<< ================================================= >>--

   Team    = "The BugSack Team",
   Name    = "BugSack",
   Version = "a/R.4F.8",
   Desc    = "Toss those bugs inna sack.",

--<< ================================================= >>--
-- Page IV: Chat Option Variables.                       --
--<< ================================================= >>--

   Chat           = {
      SaveErrors  = "Permanent saving is [%s].",
      ToggleSound = "Audible warnings are [%s].",
      ToggleAuto  = "Automatic frame-popping is [%s].",
      ToggleMsg   = "Printing of error message is [%s].",
      ListTitle   = "List of Errors",
      GenError    = "BugSack generated this fake error.",
      Generated   = "An error has been generated.",
      Cleared     = "All errors were wiped."
   },

--<< ================================================= >>--
-- Page V: Miscellaneous Function Variables.             --
--<< ================================================= >>--

   Misc           = {
      ErrorNotice = "An error has been recorded.",
      NoErrors    = "You have no errors, yay!"
   }
}

--<< ================================================= >>--
-- Page VI: Register Shared Constants.                   --
--<< ================================================= >>--

ace:RegisterGlobals({
   version  = 1.0,
   ACEG_ON  = "On",
   ACEG_OFF = "Off"
})

--<< ================================================= >>--
-- Page Omega: Closure.                                  --
--<< ================================================= >>--

end

-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Chapter II: Addon Object and Functions.               --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

--<< ================================================= >>--
-- Page I: Initialize the AddOn Object.                  --
--<< ================================================= >>--

local const      = BugSack.Const

BugSack.Obj      = AceAddonClass:new({
   name          = const.Name,
   version       = const.Version,
   description   = const.Desc,
   author        = const.Team,
   aceCompatible = "102",
   category      = ACE_CATEGORY_INTERFACE,
   db            = AceDbClass:new("BugSackDB"),
   defaults      = { save = 1, sound = 1, errors = {} },
   cmd           = AceChatCmdClass:new(const.ChatCmd, const.ChatOpt),

--<< ================================================= >>--
-- Page II(a): The Enable Function.                      --
-- Page II(b): Hook/Replace the Error Functions.         --
--<< ================================================= >>--

   Initialize = function(self)
      if self.disabled then 
         self:Disable()
    if BugSack.tmperrDB[1] then
            ScriptErrors_Message:SetText(BugSack.tmperrDB[1])
            ScriptErrors:Show()
            BugSack.tmperrDB = {}
         end
      end
   end, 

   Enable = function(self)
      self:Set("session", (self:Get("session") or 0) + 1)
      ScriptErrors_Message.SetText = function(_, err) self:Error(err) end
      ScriptErrors.Show            = function() end
      for k, v in BugSack.tmperrDB do self:Error(v) end
      BugSack.tmperrDB = {}
   end,
   
   Disable = function(self)
      ScriptErrors_Message.SetText = nil
      ScriptErrors.Show            = nil
   end,

--<< ================================================= >>--
-- Page III: The Chat Options.                           --
--<< ================================================= >>--

   ListErrors = function(self, i)
      local tmpDB, cs = {}, self:Get("session")
      local db = self:Get("save") and self:Get("errors") or BugSack.tmperrDB or {}
      local title = format(ACE_CMD_RESULT, const.Name, const.Chat.ListTitle)
      ace:print(title) for _, v in db do
         local _, _, ses = strfind(v, "-(.+)] ")
         if i == "all" or i == "" and cs == tonumber(ses)
         or i == "previous" and cs - 1 == tonumber(ses)
         or ses == i then v = "- "..v ace:print(v) end
      end
   end,
   
   ShowFrame = function(self, i)
      local cs = self:Get("session")
      local db = self:Get("save") and self:Get("errors") or self.errDB or {}
      local f  = BugSackFrameScrollText
      self.str = ""
      if strlen(i) > 0 then self.str = db[getn(db)] else
         for _, v in db do
            local _, _, ses = strfind(v, "-(.+)] ")
            if cs == tonumber(ses) then
               v = ({strfind(v, "(%a+.lua.*)")})[3] or v
               self.str = self.str..v.."\n"
            end
         end
      end
      self.str = strlen(self.str or "") > 0 and self.str or const.Misc.NoErrors
      f:SetText(self.str) BugSackFrame:Show()
      if strlen(i) > 0 then f:HighlightText() end
   end,
   
   Save = function(self)
      self:Tog("save", const.Chat.SaveErrors)
   end,
   
   Sound = function(self)
      self:Tog("sound", const.Chat.ToggleSound)
   end,
   
   AutoShow = function(self)
      self:Tog("auto", const.Chat.ToggleAuto)
   end,

   PrintMsg = function(self)
      self:Tog("msg", const.Chat.ToggleMsg)
   end,

   ScriptBug = function(self)
      RunScript(const.Chat.GenError)
      self:Msg(const.Chat.Generated)
   end,
   
   AddonBug = function(self)
      self:Msg(const.Chat.Generated)
      self:BugGeneratedByBugSack()
   end,

   Reset = function(self)
      self.db:reset(self.profilePath, self.defaults)
      self:Msg(const.Chat.Cleared) self:Enable()
   end,

--<< ================================================= >>--
-- Page IV: The Error Sacking Function.                  --
--<< ================================================= >>--

   Error = function(self, err)
      local db = self:Get("save") and self:Get("errors") or self.errDB or {}
      local cs = self:Get("session")
      err      = gsub(err or "", "[Ii]nterface\\", "")
      err      = gsub(err or "", "[Aa]dd[Oo]ns\\", "")
      local oe = err
      err      = "["..date("%H:%M").."-"..cs.."] "..err.."\n   ---"
      for _, v in db do
         local _, _, ses, ee = strfind(v, "-(.+)] (.+)\n")
         if cs == tonumber(ses) and ee == oe then
            return
         end
      end tinsert(db, err)
      if self:Get("sound") then
         PlaySoundFile("Interface\\AddOns\\BugSack\\error.wav")
      end
      if not self:Get("save") then self.errDB = db
      else self:Set("errors", db) end
      if self:Get("auto") then self:ShowFrame(TRUE) else
         if self:Get("msg") then
            self.cmd:error("\n"..err)
	 else
            self:Msg(const.Misc.ErrorNotice, "")
         end
      end
   end,

--<< ================================================= >>--
-- Page V: The EditBox Handler.                          --
--<< ================================================= >>--

   OnTextChanged = function(self)
      if this:GetText() ~= self.str then
         this:SetText(self.str)
      end
      local s = BugSackFrameScrollScrollBar
      this:GetParent():UpdateScrollChildRect()
      local _, m = s:GetMinMaxValues()
      if m > 0 and this.max ~= m then
         this.max = m s:SetValue(m)
      end
   end

})

--<< ================================================= >>--
-- Page Omega: Register the AddOn Object.                --
--<< ================================================= >>--

BugSack.Obj:RegisterForLoad()

-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Chapter III: Register Shared Util Functions.          --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

ace:RegisterFunctions(BugSack.Obj, {
   version = 1.0,

--<< ================================================= >>--
-- Page I: The Addon Closures.                           --
--<< ================================================= >>--

   Msg = function(self, ...)
      self.cmd:msg(unpack(arg))
   end,
   Get = function(self, var)
      if type(self) == "string" then
         ace:print("! ERROR: "..self)
      end
      return self.db:get(self.profilePath, var)
   end,
   Set = function(self, var, val)
      self.db:set(self.profilePath, var, val)
   end,
   Tog = function(self, v, c)
      self.cmd:result(format(c, self.db:toggle(
      self.profilePath, v) and ACEG_ON or ACEG_OFF))
   end

--<< ================================================= >>--
-- Page Omega: Closure.                                  --
--<< ================================================= >>--

})

-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Fin.                                                  --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

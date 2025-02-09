-- Author: westor
-- Contact: westor7 @ Discord
--
-- Copyright (c) 2025 westor

BetterHusbandryUI = {}

-- Create a meta table to get basic Class-like behavior
local BetterHusbandryUI_mt = Class(BetterHusbandryUI)

---Creates the settings UI object
---@return SettingsUI @The new object
function BetterHusbandryUI.new(settings)
	local self = setmetatable({}, BetterHusbandryUI_mt)

	self.controls = {}
	self.settings = settings

	return self
end

---Register the UI into the base game UI
function BetterHusbandryUI:registerSettings()
	-- Get a reference to the base game general settings page
	local settingsPage = g_gui.screenControllers[InGameMenu].pageSettings
	
	-- Define the UI controls. For each control, a <prefix>_<name>_short and _long key must exist in the i18n values
	local controlProperties = {
		{ name = "eggsMultiplier", min = 0, max = 100, step = 0.5, autoBind = true, nillable = false }, 
		{ name = "woolMultiplier", min = 0, max = 100, step = 0.5, autoBind = true, nillable = false },
		{ name = "milkMultiplier", min = 0, max = 100, step = 0.5, autoBind = true, nillable = false },
		{ name = "manureMultiplier", min = 0, max = 100, step = 0.5, autoBind = true, nillable = false },
		{ name = "slurryMultiplier", min = 0, max = 100, step = 0.5, autoBind = true, nillable = false }
	}

	UIHelper.createControlsDynamically(settingsPage, "bh_setting_title", self, controlProperties, "bh_")
	UIHelper.setupAutoBindControls(self, self.settings, BetterHusbandryUI.onSettingsChange)

	-- Apply initial values
	self:updateUiElements()

	-- Update any additional settings whenever the frame gets opened
	InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, function()
		self:updateUiElements(true) -- We can skip autobind controls here since they are already registered to onFrameOpen
	end)
	
	-- Trigger to update the values when settings frame is closed
	InGameMenuSettingsFrame.onFrameClose = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameClose, function()
		self:onFrameClose();
	end);

end

function BetterHusbandryUI:onSettingsChange()
	self:updateUiElements()
end

---Updates the UI elements to reflect the current settings
---@param skipAutoBindControls boolean|nil @True if controls with the autoBind properties shall not be newly populated
function BetterHusbandryUI:updateUiElements(skipAutoBindControls)
	if not skipAutoBindControls then
		-- Note: This method is created dynamically by UIHelper.setupAutoBindControls
		self.populateAutoBindControls()
	end

	local isAdmin = g_currentMission:getIsServer() or g_currentMission.isMasterUser

	for _, control in ipairs(self.controls) do
		control:setDisabled(not isAdmin)
	end
	
	-- Update the focus manager
	local settingsPage = g_gui.screenControllers[InGameMenu].pageSettings
	settingsPage.generalSettingsLayout:invalidateLayout()
end

function BetterHusbandryUI:onFrameClose()
	if BetterHusbandry.settings.eggsMultiplier == BetterHusbandry.settings.eggsOldMultiplier
		and BetterHusbandry.settings.woolMultiplier == BetterHusbandry.settings.woolOldMultiplier
		and BetterHusbandry.settings.milkMultiplier == BetterHusbandry.settings.milkOldMultiplier
		and BetterHusbandry.settings.manureMultiplier == BetterHusbandry.settings.manureOldMultiplier
		and BetterHusbandry.settings.slurryMultiplier == BetterHusbandry.settings.slurryOldMultiplier then
		
		return
	end

	BetterHusbandry.settings.eggsOldMultiplier = BetterHusbandry.settings.eggsMultiplier
	BetterHusbandry.settings.woolOldMultiplier = BetterHusbandry.settings.woolMultiplier
	BetterHusbandry.settings.milkOldMultiplier = BetterHusbandry.settings.milkMultiplier
	BetterHusbandry.settings.manureOldMultiplier = BetterHusbandry.settings.manureMultiplier
	BetterHusbandry.settings.slurryOldMultiplier = BetterHusbandry.settings.slurryMultiplier
	
	BetterHusbandry.saveSettings()

	g_currentMission:showBlinkingWarning(g_i18n:getText("bh_blink_warn"), 15000)
end
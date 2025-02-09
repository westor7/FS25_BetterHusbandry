-- Author: westor
-- Contact: westor7 @ Discord
--
-- Copyright (c) 2025 westor

BetterHusbandry = {}
BetterHusbandry.settings = {}
BetterHusbandry.name = g_currentModName or "FS25_BetterHusbandry"
BetterHusbandry.version = "1.0.0.0"
BetterHusbandry.init = false
BetterHusbandry.initUI = false

function BetterHusbandry.prerequisitesPresent(specializations)
	return true
end

function BetterHusbandry:loadMap()
	if g_dedicatedServer or g_currentMission.missionDynamicInfo.isMultiplayer or not g_server or not g_currentMission:getIsServer() then
		Logging.error("[%s]: Error, Cannot use this mod because this mod is working only for singleplayer!", BetterHusbandry.name)

		return
	end

	BetterHusbandry.init = true

	InGameMenu.onMenuOpened = Utils.appendedFunction(InGameMenu.onMenuOpened, BetterHusbandry.initUi)

	FSBaseMission.saveSavegame = Utils.appendedFunction(FSBaseMission.saveSavegame, BetterHusbandry.saveSettings)
end

function BetterHusbandry:defSettings()
	BetterHusbandry.settings.eggsMultiplier = 2
	BetterHusbandry.settings.eggsOldMultiplier = 2
	
	BetterHusbandry.settings.woolMultiplier = 2
	BetterHusbandry.settings.woolOldMultiplier = 2
	
	BetterHusbandry.settings.milkMultiplier = 2
	BetterHusbandry.settings.milkOldMultiplier = 2
	
	BetterHusbandry.settings.manureMultiplier = 2
	BetterHusbandry.settings.manureOldMultiplier = 2
	
	BetterHusbandry.settings.slurryMultiplier = 2
	BetterHusbandry.settings.slurryOldMultiplier = 2
end

function BetterHusbandry:saveSettings()
	Logging.info("[%s]: Trying to save settings..", BetterHusbandry.name)

	local xmlPath = getUserProfileAppPath() .. "modSettings" .. "/" .. "BetterHusbandry.xml"
	local xmlFile = createXMLFile("BetterHusbandry", xmlPath, "BetterHusbandry")
	
	Logging.info("[%s]: Saving settings to '%s' ..", BetterHusbandry.name, xmlPath)
	
	setXMLFloat(xmlFile, "BetterHusbandry.eggs#Multiplier", BetterHusbandry.settings.eggsMultiplier)
	setXMLFloat(xmlFile, "BetterHusbandry.wool#Multiplier", BetterHusbandry.settings.woolMultiplier)
	setXMLFloat(xmlFile, "BetterHusbandry.milk#Multiplier", BetterHusbandry.settings.milkMultiplier)
	setXMLFloat(xmlFile, "BetterHusbandry.manure#Multiplier", BetterHusbandry.settings.manureMultiplier)
	setXMLFloat(xmlFile, "BetterHusbandry.slurry#Multiplier", BetterHusbandry.settings.slurryMultiplier)
	
	saveXMLFile(xmlFile)
	delete(xmlFile)
	
	Logging.info("[%s]: Settings have been saved.", BetterHusbandry.name)
end

function BetterHusbandry:loadSettings()
	Logging.info("[%s]: Trying to load settings..", BetterHusbandry.name)
	
	local xmlPath = getUserProfileAppPath() .. "modSettings" .. "/" .. "BetterHusbandry.xml"
	
	Logging.info("[%s]: Loading settings from '%s' ..", BetterHusbandry.name, xmlPath)
	
	if fileExists(xmlPath) then
		Logging.info("[%s]: File founded, loading now the settings..", BetterHusbandry.name)
		
		local xmlFile = loadXMLFile("BetterHusbandry", xmlPath)
		
		if xmlFile == 0 then
			Logging.warning("[%s]: Could not read the data from XML file, maybe the XML file is empty or corrupted, using the default settings!", BetterHusbandry.name)
			
			BetterHusbandry:defSettings()
			
			Logging.info("[%s]: Default settings have been loaded.", BetterHusbandry.name)
			
			return
		end

		local eggsMultiplier = Utils.getNoNil( getXMLFloat(xmlFile, "BetterHusbandry.eggs#Multiplier"), 2);
		local woolMultiplier = Utils.getNoNil( getXMLFloat(xmlFile, "BetterHusbandry.wool#Multiplier"), 2);
		local milkMultiplier = Utils.getNoNil( getXMLFloat(xmlFile, "BetterHusbandry.milk#Multiplier"), 2);
		local manureMultiplier = Utils.getNoNil( getXMLFloat(xmlFile, "BetterHusbandry.manure#Multiplier"), 2);
		local slurryMultiplier = Utils.getNoNil( getXMLFloat(xmlFile, "BetterHusbandry.slurry#Multiplier"), 2);

		if eggsMultiplier < 0 then
			Logging.warning("[%s]: Could not retrieve the correct 'eggsMultiplier' digital number value because it is lower than '0' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			eggsMultiplier = 2
		end
		
		if woolMultiplier < 0 then
			Logging.warning("[%s]: Could not retrieve the correct 'woolMultiplier' digital number value because it is lower than '0' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			woolMultiplier = 2
		end
		
		if milkMultiplier < 0 then
			Logging.warning("[%s]: Could not retrieve the correct 'milkMultiplier' digital number value because it is lower than '0' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			milkMultiplier = 2
		end
		
		if manureMultiplier < 0 then
			Logging.warning("[%s]: Could not retrieve the correct 'manureMultiplier' digital number value because it is lower than '0' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			manureMultiplier = 2
		end
		
		if slurryMultiplier < 0 then
			Logging.warning("[%s]: Could not retrieve the correct 'slurryMultiplier' digital number value because it is lower than '0' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			slurryMultiplier = 2
		end
		
		if eggsMultiplier > 100 then
			Logging.warning("[%s]: Could not retrieve the correct 'eggsMultiplier' digital number value because it is higher than '100' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			eggsMultiplier = 2
		end
		
		if woolMultiplier > 100 then
			Logging.warning("[%s]: Could not retrieve the correct 'woolMultiplier' digital number value because it is higher than '100' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			woolMultiplier = 2
		end
		
		if milkMultiplier > 100 then
			Logging.warning("[%s]: Could not retrieve the correct 'milkMultiplier' digital number value because it is higher than '100' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			milkMultiplier = 2
		end
		
		if manureMultiplier > 100 then
			Logging.warning("[%s]: Could not retrieve the correct 'manureMultiplier' digital number value because it is higher than '100' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			manureMultiplier = 2
		end
		
		if slurryMultiplier > 100 then
			Logging.warning("[%s]: Could not retrieve the correct 'slurryMultiplier' digital number value because it is higher than '100' from the XML file or it is corrupted, using the default!", BetterHusbandry.name)
			
			slurryMultiplier = 2
		end
		
		BetterHusbandry.settings.eggsMultiplier = eggsMultiplier
		BetterHusbandry.settings.eggsOldMultiplier = eggsMultiplier
		
		BetterHusbandry.settings.woolMultiplier = woolMultiplier
		BetterHusbandry.settings.woolOldMultiplier = woolMultiplier
		
		BetterHusbandry.settings.milkMultiplier = milkMultiplier
		BetterHusbandry.settings.milkOldMultiplier = milkMultiplier
		
		BetterHusbandry.settings.manureMultiplier = manureMultiplier
		BetterHusbandry.settings.manureOldMultiplier = manureMultiplier
		
		BetterHusbandry.settings.slurryMultiplier = slurryMultiplier
		BetterHusbandry.settings.slurryOldMultiplier = slurryMultiplier
		
		delete(xmlFile)
					
		Logging.info("[%s]: Settings have been loaded.", BetterHusbandry.name)
	else
		BetterHusbandry:defSettings()

		Logging.info("[%s]: NOT any file founded!, using the default settings.", BetterHusbandry.name)
	end
end

function BetterHusbandry:initUi()
	if not BetterHusbandry.initUI then
		local uiSettingsBetterHusbandry = BetterHusbandryUI.new(BetterHusbandry.settings)
		
		uiSettingsBetterHusbandry:registerSettings()
		
		BetterHusbandry.initUI = true
	end
end

function BetterHusbandry:loadAnimals()
	if not self.isServer then return end

	Logging.info("[%s]: Initializing mod v%s (c) 2025 by westor.", BetterHusbandry.name, BetterHusbandry.version)

	BetterHusbandry:loadSettings()
	BetterHusbandry:initAllAnimals()
	
	Logging.info("[%s]: End of mod initalization.", BetterHusbandry.name)
end

function BetterHusbandry:initAllAnimals()
	if BetterHusbandry.settings.eggsMultiplier ~= 0 then
		local eggsTypes = { "CHICKEN" }
		
		BetterHusbandry.eggsUpdated = 0
		
		Logging.info("[%s]: Start of animals egg updates. - Total: %s", BetterHusbandry.name, table.getn(eggsTypes))

		BetterHusbandry:initEggs()
		
		Logging.info("[%s]: End of animals egg updates. - Updated: %s - Total: %s", BetterHusbandry.name, BetterHusbandry.eggsUpdated, table.getn(eggsTypes))
	end
	
	----------
	
	if BetterHusbandry.settings.woolMultiplier ~= 0 then
		local woolTypes = {
			"SHEEP_LANDRACE",
			"SHEEP_STEINSCHAF",
			"SHEEP_SWISS_MOUNTAIN",
			"SHEEP_BLACK_WELSH"
		}
		
		BetterHusbandry.woolUpdated = 0
		
		Logging.info("[%s]: Start of animals wool updates. - Total: %s", BetterHusbandry.name, table.getn(woolTypes))

		BetterHusbandry:initWool()
		
		Logging.info("[%s]: End of animals wool updates. - Updated: %s - Total: %s", BetterHusbandry.name, BetterHusbandry.woolUpdated, table.getn(woolTypes))
	end
	
	----------
	
	if BetterHusbandry.settings.manureMultiplier ~= 0 then
		local manureTypes = { 
			"COW_SWISS_BROWN", 
			"COW_HOLSTEIN", 
			"COW_ANGUS", 
			"COW_LIMOUSIN", 
			"COW_WATERBUFFALO",
			
			"PIG_LANDRACE",
			"PIG_BLACK_PIED",
			"PIG_BERKSHIRE",
			
			"HORSE_GRAY",
			"HORSE_PINTO",
			"HORSE_PALOMINO",
			"HORSE_CHESTNUT",
			"HORSE_BAY",
			"HORSE_BLACK",
			"HORSE_SEAL_BROWN",
			"HORSE_DUN"
		}
		
		BetterHusbandry.manureUpdated = 0
		
		Logging.info("[%s]: Start of animals manure updates. - Total: %s", BetterHusbandry.name, table.getn(manureTypes))

		BetterHusbandry:initManureAnimals(true, false, false)
		BetterHusbandry:initManureAnimals(false, true, false)
		BetterHusbandry:initManureAnimals(false, false, true)
		
		Logging.info("[%s]: End of animals manure updates. - Updated: %s - Total: %s", BetterHusbandry.name, BetterHusbandry.manureUpdated, table.getn(manureTypes))
	end
	
	----------
	
	if BetterHusbandry.settings.milkMultiplier ~= 0 then
		local milkTypes = { 
			"COW_SWISS_BROWN", 
			"COW_HOLSTEIN", 
			"COW_WATERBUFFALO",
			
			"GOAT"
		}
		
		BetterHusbandry.milkUpdated = 0
		
		Logging.info("[%s]: Start of animals milk updates. - Total: %s", BetterHusbandry.name, table.getn(milkTypes))

		BetterHusbandry:initMilkCows()
		BetterHusbandry:initMilkGoats()
		
		Logging.info("[%s]: End of animals milk updates. - Updated: %s - Total: %s", BetterHusbandry.name, BetterHusbandry.milkUpdated, table.getn(milkTypes))
	end
	
	----------
	
	if BetterHusbandry.settings.slurryMultiplier ~= 0 then
		local slurryTypes = { 
			"COW_SWISS_BROWN", 
			"COW_HOLSTEIN", 
			"COW_ANGUS", 
			"COW_LIMOUSIN", 
			"COW_WATERBUFFALO",
			
			"PIG_LANDRACE",
			"PIG_BLACK_PIED",
			"PIG_BERKSHIRE"
		}
		
		BetterHusbandry.slurryUpdated = 0
		
		Logging.info("[%s]: Start of animals slurry updates. - Total: %s", BetterHusbandry.name, table.getn(slurryTypes))

		BetterHusbandry:initSlurryAnimals(true, false)
		BetterHusbandry:initSlurryAnimals(false, true)
		
		Logging.info("[%s]: End of animals slurry updates. - Updated: %s - Total: %s", BetterHusbandry.name, BetterHusbandry.slurryUpdated, table.getn(slurryTypes))
	end
end

function BetterHusbandry:initEggs()
	for _1, subTypeIndex in ipairs(g_currentMission.animalSystem.nameToType["CHICKEN"].subTypes) do
		local subType = g_currentMission.animalSystem.subTypes[subTypeIndex]

		if subType.output.pallets then
			local fillType = subType.output.pallets.fillType
			local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
			local animalType = subType.name
			
			if fillType ~= nil and fillTypeName == "EGG" then
			
				BetterHusbandry.eggsUpdated = BetterHusbandry.eggsUpdated + 1
			
				for _2, output in ipairs(subType.output.pallets.curve.keyframes) do
					local amount = output[1]
					local age = output.time

					if amount ~= nil and amount ~= 0 and age ~= 0 then
						local newAmount = 0
						local defAmount = 0
						
						if BetterHusbandry.init then 
							defAmount = amount / BetterHusbandry.settings.eggsOldMultiplier
							newAmount = defAmount * BetterHusbandry.settings.eggsMultiplier
						else
							defAmount = amount
							newAmount = defAmount * BetterHusbandry.settings.eggsMultiplier
						end

						output[1] = newAmount
						
						Logging.info("[%s]: CHICKEN animal eggs amount has been updated. - Animal Type: %s - Age: %s - Default: %s - Old: %s - New: %s - Multiplier: %s", BetterHusbandry.name, animalType, age, defAmount, amount, newAmount, BetterHusbandry.settings.eggsMultiplier)
					end
					
				end
				
			end
			
		end
		
	end
end

function BetterHusbandry:initWool()
	for _1, subTypeIndex in ipairs(g_currentMission.animalSystem.nameToType["SHEEP"].subTypes) do
		local subType = g_currentMission.animalSystem.subTypes[subTypeIndex]

		if subType.output.pallets then
			local fillType = subType.output.pallets.fillType
			local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
			local animalType = subType.name
			
			if fillType ~= nil and fillTypeName == "WOOL" then
			
				BetterHusbandry.woolUpdated = BetterHusbandry.woolUpdated + 1
			
				for _2, output in ipairs(subType.output.pallets.curve.keyframes) do
					local amount = output[1]
					local age = output.time

					if amount ~= nil and amount ~= 0 and age ~= 0 then
						local newAmount = 0
						local defAmount = 0
						
						if BetterHusbandry.init then 
							defAmount = amount / BetterHusbandry.settings.woolOldMultiplier
							newAmount = defAmount * BetterHusbandry.settings.woolMultiplier
						else
							defAmount = amount
							newAmount = defAmount * BetterHusbandry.settings.woolMultiplier
						end

						output[1] = newAmount
						
						Logging.info("[%s]: SHEEP animal wool amount has been updated. - Animal Type: %s - Age: %s - Default: %s - Old: %s - New: %s - Multiplier: %s", BetterHusbandry.name, animalType, age, defAmount, amount, newAmount, BetterHusbandry.settings.woolMultiplier)
					end
					
				end
				
			end
			
		end
		
	end
end

function BetterHusbandry:initManureAnimals(animalCows, animalPigs, animalHorses)
	local animalCall = ""

	if animalCows then animalCall = "COW" end
	if animalPigs then animalCall = "PIG" end
	if animalHorses then animalCall = "HORSE" end

	for _1, subTypeIndex in ipairs(g_currentMission.animalSystem.nameToType[animalCall].subTypes) do
		local subType = g_currentMission.animalSystem.subTypes[subTypeIndex]

		if subType.output.manure then
			local animalType = subType.name
			
			BetterHusbandry.manureUpdated = BetterHusbandry.manureUpdated + 1
		
			for _2, output in ipairs(subType.output.manure.keyframes) do
				local amount = output[1]
				local age = output.time
				local newAmount = 0
				local defAmount = 0
				
				if BetterHusbandry.init then 
					defAmount = amount / BetterHusbandry.settings.manureOldMultiplier
					newAmount = defAmount * BetterHusbandry.settings.manureMultiplier
				else
					defAmount = amount
					newAmount = defAmount * BetterHusbandry.settings.manureMultiplier
				end

				output[1] = newAmount
				
				Logging.info("[%s]: %s animal manure amount has been updated. - Animal Type: %s - Age: %s - Default: %s - Old: %s - New: %s - Multiplier: %s", BetterHusbandry.name, animalCall, animalType, age, defAmount, amount, newAmount, BetterHusbandry.settings.manureMultiplier)
			end	

		end
		
	end
end

function BetterHusbandry:initMilkCows()
	for _1, subTypeIndex in ipairs(g_currentMission.animalSystem.nameToType["COW"].subTypes) do
		local subType = g_currentMission.animalSystem.subTypes[subTypeIndex]

		if subType.output.milk then
			local fillType = subType.output.milk.fillType
			local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
			local animalType = subType.name
			
			if fillType ~= nil and fillTypeName == "MILK" or fillTypeName == "BUFFALOMILK" then
			
				BetterHusbandry.milkUpdated = BetterHusbandry.milkUpdated + 1

				for _2, output in ipairs(subType.output.milk.curve.keyframes) do
					local amount = output[1]
					local age = output.time

					if amount ~= nil and amount ~= 0 and age ~= 0 then
						local newAmount = 0
						local defAmount = 0
						
						if BetterHusbandry.init then 
							defAmount = amount / BetterHusbandry.settings.milkOldMultiplier
							newAmount = defAmount * BetterHusbandry.settings.milkMultiplier
						else
							defAmount = amount
							newAmount = defAmount * BetterHusbandry.settings.milkMultiplier
						end

						output[1] = newAmount
						
						Logging.info("[%s]: COW animal milk amount has been updated. - Animal Type: %s - Age: %s - Default: %s - Old: %s - New: %s - Multiplier: %s", BetterHusbandry.name, animalType, age, defAmount, amount, newAmount, BetterHusbandry.settings.milkMultiplier)
					end
					
				end
				
			end
			
		end
		
	end
end

function BetterHusbandry:initMilkGoats()
	for _1, subTypeIndex in ipairs(g_currentMission.animalSystem.nameToType["SHEEP"].subTypes) do
		local subType = g_currentMission.animalSystem.subTypes[subTypeIndex]

		if subType.output.pallets then
			local fillType = subType.output.pallets.fillType
			local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
			local animalType = subType.name
			
			if fillType ~= nil and fillTypeName == "GOATMILK" then
			
				BetterHusbandry.milkUpdated = BetterHusbandry.milkUpdated + 1
			
				for _2, output in ipairs(subType.output.pallets.curve.keyframes) do
					local amount = output[1]
					local age = output.time

					if amount ~= nil and amount ~= 0 and age ~= 0 then
						local newAmount = 0
						local defAmount = 0
						
						if BetterHusbandry.init then 
							defAmount = amount / BetterHusbandry.settings.milkOldMultiplier
							newAmount = defAmount * BetterHusbandry.settings.milkMultiplier
						else
							defAmount = amount
							newAmount = defAmount * BetterHusbandry.settings.milkMultiplier
						end

						output[1] = newAmount
						
						Logging.info("[%s]: GOAT animal milk amount has been updated. - Animal Type: %s - Age: %s - Default: %s - Old: %s - New: %s - Multiplier: %s", BetterHusbandry.name, animalType, age, defAmount, amount, newAmount, BetterHusbandry.settings.milkMultiplier)
					end
					
				end
				
			end
			
		end
		
	end
end

function BetterHusbandry:initSlurryAnimals(animalCows, animalPigs)
	local animalCall = ""

	if animalCows then animalCall = "COW" end
	if animalPigs then animalCall = "PIG" end
	
	for _1, subTypeIndex in ipairs(g_currentMission.animalSystem.nameToType[animalCall].subTypes) do
		local subType = g_currentMission.animalSystem.subTypes[subTypeIndex]

		if subType.output.liquidManure then
			local animalType = subType.name
			
			BetterHusbandry.slurryUpdated = BetterHusbandry.slurryUpdated + 1
		
			for _2, output in ipairs(subType.output.liquidManure.keyframes) do
				local amount = output[1]
				local age = output.time
				local newAmount = 0
				local defAmount = 0
				
				if BetterHusbandry.init then 
					defAmount = amount / BetterHusbandry.settings.slurryOldMultiplier
					newAmount = defAmount * BetterHusbandry.settings.slurryMultiplier
				else
					defAmount = amount
					newAmount = defAmount * BetterHusbandry.settings.slurryMultiplier
				end

				output[1] = newAmount
				
				Logging.info("[%s]: %s animal slurry amount has been updated. - Animal Type: %s - Age: %s - Default: %s - Old: %s - New: %s - Multiplier: %s", BetterHusbandry.name, animalCall, animalType, age, defAmount, amount, newAmount, BetterHusbandry.settings.slurryMultiplier)
			end	

		end
		
	end
end

AnimalSystem.loadAnimals = Utils.appendedFunction(AnimalSystem.loadAnimals, BetterHusbandry.loadAnimals)

addModEventListener(BetterHusbandry)
local term = require("term")
local component = require("component")
local transposer = component.transposer

BloodAltarTier = 5  -- Change manually depending on your Altar level, Default: 5 (Tier: V)
 
dualinterfaceSide = 5
altarSide = 2
  
-- Altar slots do not need to be changed, unless WayOfTime add additional inventory slots or tanks to the Blood Altar
altarSlot = 1  
altarTank = 1

-- Configure your AE2 Systems targets here --
-- Setup the Dual Interface to have these in their progressional order, if not you can change it here --
SlateConfig = {
    {
        name = "Arcane Slate",
        slot = 1,
        target = 0
    },
    {
        name = "Blank Slate",
        slot = 2,
        target = 64
    },
    {
        name = "Reinforced Slate",
        slot = 3,
        target = 64
    },
    {
        name = "Imbued Slate",
        slot = 4,
        target = 64
    },
    {
        name = "Demonic Slate",
        slot = 5,
        target = 64
    },
    {
        name = "Ethereal Slate",
        slot = 6,
        target = 64
    }   
}
LifeEssenceTarget = 1000000
BloodOrbLabel = "Master Blood Orb"

-- Configured for GTNH, Higher blood requirements than normal.

SlateInfo = {
    {
        name = "Blank Slate",
        id = "AWWayOfTime:blankSlate",
        blood = 1000,
        tier = 1
    },
    {
        name = "Reinforced Slate",
        id = "AWWayOfTime:reinforcedSlate",
        blood = 2500,
        tier = 2
    },
    {
        name = "Imbued Slate",
        id = "AWWayOfTime:imbuedSlate",
        blood = 7500,
        tier = 3
    },
    {
        name = "Demonic Slate",
        id = "AWWayOfTime:demonicSlate",
        blood = 20000,
        tier = 4
    },
    {
        name = "Ethereal Slate",
        id = "AWWayOfTime:bloodMagicBaseItems",
        blood = 60000,
        tier = 5
    }   
}

function GetLifeEssence()
    for i, fluid in pairs(component.me_interface.getFluidsInNetwork()) do
        if fluid["label"] == "Life Essence" then
            return fluid.amount
        end
    end
end

function GetItem(name)
    for i, item in pairs(component.me_interface.getItemsInNetwork({label = name})) do
        return item.size
    end
end

function ConfigureFluidInterface()
end

function CraftSlate(craft, ingredient)
    local crafting = true
    -- Move Blood Orb Out --
    if transposer.getStackInSlot(config.altarSide, config.altarSlot).label == config.BloodOrbLabel then
        term.write("Found Blood Orb in Altar, moving it out to begin crafting\n")
        if transposer.transferItem(config.altarSide, config.dualinterfaceSide, 1, config.altarSlot, config.BloodOrbSlot) ~= 1 then
            term.write("Could not move Blood Orb, Failing\n")
        end
    end
    -- Insert a stone into the altar --
    if transposer.transferItem(config.dualinterfaceSide, config.altarSide, 1, config.SlateConfig[ingredient]["slot"], config.altarSlot) ~= 1 then
        term.write("Could not move Slate in, Failing\n")
    end
    while crafting do
        if transposer.getStackInSlot(config.altarSide, config.altarSlot).label == config.SlateConfig[craft]["slot"] then
            if transposer.transferItem(config.altarSide, config.dualinterfaceSide, 1, config.altarSlot, config.BloodOrbSlot) ~= 1 then
                term.write("Could not move Slate out, Failing\n")
            else
                term.write(string.format("Craft Complete: %s", craft))
                crafting=false
            end
        end
    end
end


function LifeEssenceStatus()
    if term.isAvailable() then
        term.clearLine()
        term.write(string.format("AE2 Blood Level:  %s mb / %s mb\n", GetLifeEssence(), config.LifeEssenceTarget))
    end
end

term.clear()
while true do
    LifeEssenceStatus()

    if GetItem("Arcane Slate") > 0 and GetItem("Blank Slate") < config.SlateConfig["Blank Slate"]["target"] then
        CraftSlate("Arcane Slate", "Blank Slate")

    elseif config.BloodAltarTier >= 2 and GetItem("Blank Slate") > 0 and GetItem("Reinforced Slate") < config.SlateConfig["Reinforced Slate"]["target"] then
        CraftSlate("Blank Slate", "Reinforced Slate")

    elseif config.BloodAltarTier >= 3 and GetItem("Reinforced Slate") > 0 and GetItem("Imbued Slate") < config.SlateConfig["Imbued Slate"]["target"] then
        CraftSlate("Reinforced Slate", "Imbued Slate")

    elseif  config.BloodAltarTier >= 4 and GetItem("Imbued Slate") > 0 and GetItem("Demonic Slate") < config.SlateConfig["Demonic Slate"]["target"] then
        CraftSlate("Imbued Slate", "Demonic Slate")

    elseif config.BloodAltarTier >= 5 and GetItem("Demonic Slate") > 0 and GetItem("Ethereal Slate") < config.SlateConfig["Ethereal Slate"]["target"] then
        CraftSlate("Demonic Slate", "Ethereal Slate")
    end
end
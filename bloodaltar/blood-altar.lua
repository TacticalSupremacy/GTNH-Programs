local term = require("term")
local component = require("component")
local transposer = component.transposer

local bloodAltarTier = 5  -- Change manually depending on your Altar level, Default: 5 (Tier: V)
 
local dualinterfaceSide = 5
local altarSide = 2
  
-- Altar slots do not need to be changed, unless WayOfTime add additional inventory slots or tanks to the Blood Altar
local altarSlot = 1  
local altarTank = 1

-- Configure your AE2 Systems targets here --
-- Setup the Dual Interface to have these in their progressional order, if not you can change it here --
local slateConfig = {
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
local lifeEssenceTarget = 1000000
local bloodOrbLabel = "Master Blood Orb"
local bloodOrbSlot = 7

-- Configured for GTNH, Higher blood requirements than normal.

local slateInfo = {
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
            a = fluid.amount
            if a == nil then
                return 0
            else
                return fluid.amount
            end
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
    if transposer.getStackInSlot(altarSide, altarSlot).label == bloodOrbLabel then
        term.write("Found Blood Orb in Altar, moving it out to begin crafting\n")
        if transposer.transferItem(altarSide, dualinterfaceSide, 1, altarSlot, bloodOrbSlot) ~= 1 then
            term.write("Could not move Blood Orb, Failing\n")
        end
    end
    -- Insert a stone into the altar --
    if transposer.transferItem(dualinterfaceSide, altarSide, 1, slateConfig[ingredient]["slot"], altarSlot) ~= 1 then
        term.write("Could not move Slate in, Failing\n")
    end
    while crafting do
        if transposer.getStackInSlot(altarSide, altarSlot).label == slateConfig[craft]["slot"] then
            if transposer.transferItem(altarSide, dualinterfaceSide, 1, altarSlot, bloodOrbSlot) ~= 1 then
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
        term.write(string.format("AE2 Blood Level:  %s mb / %s mb\n", GetLifeEssence(), lifeEssenceTarget))
    end
end

term.clear()
while true do
    LifeEssenceStatus()
    if GetItem("Arcane Slate") ~= nil then
        if GetItem("Arcane Slate") > 0 and GetItem("Blank Slate") < slateConfig["Blank Slate"]["target"] then
            CraftSlate("Arcane Slate", "Blank Slate")
        end
    end
    if GetItem("Arcane Slate") ~= nil then
        if bloodAltarTier >= 2 and GetItem("Blank Slate") > 0 and GetItem("Reinforced Slate") < slateConfig["Reinforced Slate"]["target"] then
            CraftSlate("Blank Slate", "Reinforced Slate")
        end
    end
    if GetItem("Arcane Slate") ~= nil then
        if bloodAltarTier >= 3 and GetItem("Reinforced Slate") > 0 and GetItem("Imbued Slate") < slateConfig["Imbued Slate"]["target"] then
            CraftSlate("Reinforced Slate", "Imbued Slate")
        end
    end
    if GetItem("Arcane Slate") ~= nil then
        if  bloodAltarTier >= 4 and GetItem("Imbued Slate") > 0 and GetItem("Demonic Slate") < slateConfig["Demonic Slate"]["target"] then
            CraftSlate("Imbued Slate", "Demonic Slate")
        end
    end
    if GetItem("Arcane Slate") ~= nil then
        if bloodAltarTier >= 5 and GetItem("Demonic Slate") > 0 and GetItem("Ethereal Slate") < slateConfig["Ethereal Slate"]["target"] then
        CraftSlate("Demonic Slate", "Ethereal Slate")
        end
    end
end
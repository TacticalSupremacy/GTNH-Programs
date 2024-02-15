local term = require("term")
local component = require("component")
local transposer = component.transposer

local bloodAltarTier = 5  -- Change manually depending on your Altar level, Default: 5 (Tier: V)
 
local dualinterfaceSide = 5
local dualinterfaceTank = 5
local altarSide = 2
  
-- Altar slots do not need to be changed, unless WayOfTime add additional inventory slots or tanks to the Blood Altar
local altarSlot = 1  
local altarTank = 1

-- Configure your AE2 Systems targets here --
-- Setup the Dual Interface to have these in their prrogressional order, if not you can change it here --
local slateConfig = {
    {
        label = "Arcane Slate",
        id = "dreamcraft:ArcaneSlate",
        blood = 0,
        tier = 0,
        slot = 1,
        target = 0
    },
    {
        label = "Blank Slate",
        id = "AWWayOfTime:blankSlate",
        blood = 1000,
        tier = 1,
        slot = 2,
        target = 128
    },
    {
        label = "Reinforced Slate",
        id = "AWWayOfTime:reinforcedSlate",
        blood = 2500,
        tier = 2,
        slot = 3,
        target = 128
    },
    {
        label = "Imbued Slate",
        id = "AWWayOfTime:imbuedSlate",
        blood = 7500,
        tier = 3,
        slot = 4,
        target = 128
    },
    {
        label = "Demonic Slate",
        id = "AWWayOfTime:demonicSlate",
        blood = 20000,
        tier = 4,
        slot = 5,
        target = 128
    },
    {
        label = "Ethereal Slate",
        id = "AWWayOfTime:bloodMagicBaseItems",
        blood = 60000,
        tier = 5,
        slot = 6,
        target = 128
    }   
}
local lifeEssenceTarget = 1000000
local altarCritical = 30000
local bloodOrbLabel = "Master Blood Orb"
local bloodOrbSlot = 7

-- Begin Program --

function AE2GetLifeEssence()
    for i, fluid in pairs(component.me_interface.getFluidsInNetwork()) do
        if fluid["label"] == "Life Essence" then
            local a = fluid.amount
            if a == nil then
                return 0
            else
                return fluid.amount
            end
        end
    end
end

function GetAltarLifeEssence()
    if component.transposer.getFluidInTank(altarSide) ~= nil then
        return component.transposer.getFluidInTank(altarSide, altarTank).amount
    else
        return 0
    end
end

function AE2GetItem(label)
    for i, item in pairs(component.me_interface.getItemsInNetwork({label = label})) do
        return item.size
    end
end

function LifeEssenceStatus()
    if term.isAvailable() then
        term.clearLine()
        term.write(string.format("AE2 Blood Level:  %s mb / %s mb\n", AE2GetLifeEssence(), lifeEssenceTarget))
    end
end

function CraftSlate(craft_slot, ingredient_slot)
    LifeEssenceStatus()
    if AE2GetItem(slateConfig[ingredient_slot].label) ~= nil and AE2GetItem(slateConfig[craft_slot].label) ~= nil then
        if AE2GetItem(slateConfig[ingredient_slot].label) > 0 and AE2GetItem(slateConfig[craft_slot].label) < slateConfig[craft_slot].target then
        else
            return
        end
    else
        return
    end

    local crafting = true
    -- Move Blood Orb Out --
    if transposer.getSlotStackSize(altarSide, altarSlot) == 0 then
        term.write("No Blood Orb in Altar detected\n")
    else
        if transposer.getStackInSlot(altarSide, altarSlot).label == bloodOrbLabel then
            term.write("Found Blood Orb in Altar, moving it out to begin crafting\n")
            if transposer.transferItem(altarSide, dualinterfaceSide, 1, altarSlot, bloodOrbSlot) ~= 1 then
                term.write("Could not move Blood Orb, Failing\n")
            end
        end
    end
    -- Insert a stone into the altar --
    if transposer.transferItem(dualinterfaceSide, altarSide, 1, slateConfig[ingredient_slot].slot, altarSlot) ~= 1 then
        term.write("Could not move Slate in, Failing\n")
    else
        term.write(string.format("Crafting: %s using %s mb\n", slateConfig[craft_slot].label, slateConfig[craft_slot].blood))
    end
    while crafting do
        if transposer.getStackInSlot(altarSide, altarSlot).label == slateConfig[craft_slot].label then
            if transposer.transferItem(altarSide, dualinterfaceSide, 1, altarSlot, craft_slot) ~= 1 then
                term.write("Could not move Slate out, Failing\n")
            else
                term.write(string.format("Craft Complete: %s\n", slateConfig[craft_slot].label))
                crafting=false
            end
        end
    end
end

function InsertBloodOrb()
    if transposer.getStackInSlot(dualinterfaceSide, bloodOrbSlot).label == bloodOrbLabel then
        term.write("Putting Blood Orb back in the Altar\n")
        if transposer.transferItem(dualinterfaceSide, altarSide, 1, bloodOrbSlot, altarSlot) ~= 1 then
            term.write("Could not move Blood Orb, Failing\n")
        end
    end
end

function RegenAltar()
    if GetAltarLifeEssence() <= altarCritical then
        term.write("Altar is Critical on Blood, Entering REGEN mode\n")
        local regen = true
        while regen do
            if GetAltarLifeEssence() >= altarCritical then
                term.write("Altar is recharged, exiting REGEN Mode\n")
            regen = false
            end
        end
    end
end

-- Core Loop --

term.clear()
while true do
    CraftSlate(2, 1)
    CraftSlate(3, 2)
    CraftSlate(4, 3)
    CraftSlate(5, 4)
    CraftSlate(6, 5)
    InsertBloodOrb()
    RegenAltar()
    -- Repeat --
end

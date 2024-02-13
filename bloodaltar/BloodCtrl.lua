--[[
BloodCtrl
Automated Blood Magic Slate Creation
Version: 0.2.0
Author: Originally by Haybale100, Extended by Ariel Rin
License: CC BY 4.0
]]

local config = require('config')
local slates = require('slates')

term = require("term")
component = require("component")

transpose = component.transposer
ae2 = component.ae2

stackInfo = {}
 
function SetStackInfoBasic()
    stackInfo[1] = transpose.getStackInSlot(config.chestSide, config.slateBSlot)
end
 
function SetStackInfoReinforced()
    stackInfo[2] = transpose.getStackInSlot(config.chestSide, config.slateRSlot)
end
 
function SetStackInfoImbued()
    stackInfo[3] = transpose.getStackInSlot(config.chestSide, config.slateISlot)
end
 
function SetStackInfoDemonic()
    stackInfo[4] = transpose.getStackInSlot(config.chestSide, config.slateDSlot)
end
 
function SetStackInfoEthereal()
    stackInfo[5] = transpose.getStackInSlot(config.chestSide, config.slateESlot)
end
 
function SetDefaultStackInfo()
    if pcall(SetStackInfoBasic) then ;
    else
        stackInfo[1].label = slates.slateInfo[1].name
        stackInfo[1].size = 0
    end
    if pcall(SetStackInfoReinforced) then ;
    else
        stackInfo[2].label = slates.slateInfo[2].name
        stackInfo[2].size = 0
    end
    if pcall(SetStackInfoImbued) then ;
    else
        stackInfo[3].label = slates.slateInfo[3].name
        stackInfo[3].size = 0
    end
    if pcall(SetStackInfoDemonic) then ;
    else
        stackInfo[4].label = slates.slateInfo[4].name
        stackInfo[4].size = 0
    end
    if pcall(SetStackInfoEthereal) then ;
    else
        stackInfo[5].label = slates.slateInfo[5].name
        stackInfo[5].size = 0
    end
end

function getTankInfo()
    tInfo = transpose.getFluidInTank(config.altarSide)
    tankAmount = tInfo[1].amount
    tankCapacity = tInfo[1].capacity
    tankPercent = (tankAmount / tankCapacity) * 100
 
    if term.isAvailable() then
      term.clearLine()
      term.write(string.format("Current Blood Level: %.2f %%, %.0d mb / %.0d mb\n", tankPercent, tankAmount, tankCapacity))
    end
end

function getReserveTankInfo()
    rTInfo = transpose.getFluidInTank(config.reserveTankSide)
    if rTInfo.n > 0 then
        rTankAmount = rTInfo[1].amount
        rTankCapacity = rTInfo[1].capacity
        rTPercent = (rTankAmount / rTankCapacity) * 100
        
        if term.isAvailable() then
            term.clearLine()
            term.write(string.format("Reserve Blood Level: %.2f %%, %.0d mb / %.0d mb\n", rTPercent, rTankAmount, rTankCapacity))
        end
    else
        if term.isAvailable() then
            term.write("No Reserve Tank Detected\n")
        end 
    end
end

function WriteRSBlood()
    if term.isAvailable() then
        term.clearLine()
        term.write("Blood Creation: ")
        if component.redstone.getInput(config.rsInputSide) == 0 then
            term.write("True \n")
        else
            term.write("False\n")
        end
    end
end

function BlankSlate()
    local crafting = true
    --Move 1 stone from Interface to Blood Altar
    transpose.transferItem(config.stoneSide, config.altarSide, 1, config.stoneSlot, config.altarSlot)
    while crafting do
        writeToTerm()
        term.write(slates.slateInfo[1].name.."\n")
        if transpose.getStackInSlot(config.altarSide, config.altarSlot).label == slates.slateInfo[1].name then
            crafting = false
            --Move 1 Blank Slate from Blood Altar to Chest
            transpose.transferItem(config.altarSide, config.chestSide, 1, config.altarSlot, config.slateBSlot)
        end
    end
end
   
function ReinforcedSlate()
    local crafting = true
    --Move 1 Blank Slate from Chest to Blood Altar
    transpose.transferItem(config.chestSide, config.altarSide, 1, config.slateBSlot, config.altarSlot)
    while crafting do
        writeToTerm()
        term.write(slates.slateInfo[2].name.."\n")
        if transpose.getStackInSlot(config.altarSide, config.altarSlot).label == slates.slateInfo[2].name then
            crafting = false
            --Move 1 Reinforced Slate from Blood Altar to Chest
            transpose.transferItem(config.altarSide, config.chestSide, 1, config.altarSlot, config.slateRSlot)
        end
    end
end
   
function ImbuedSlate()
    local crafting = true
    --Move 1 Reinforced Slate from Chest to Blood Altar
    transpose.transferItem(config.chestSide, config.altarSide, 1, config.slateRSlot, config.altarSlot)
    while crafting do
        writeToTerm()
        term.write(slates.slateInfo[3].name.."\n")
        if transpose.getStackInSlot(config.altarSide, config.altarSlot).label == slates.slateInfo[3].name then
            crafting = false
            --Move 1 Imbued Slate from Blood Altar to Chest
            transpose.transferItem(config.altarSide, config.chestSide, 1, config.altarSlot, config.slateISlot)
        end
    end
end
   
function DemonicSlate()
    local crafting = true
    --Move 1 Imbued Slate from Chest to Blood Altar
    transpose.transferItem(config.chestSide, config.altarSide, 1, config.slateISlot, config.altarSlot)
    while crafting do
        writeToTerm()
        term.write(slates.slateInfo[4].name.."\n")
        if transpose.getStackInSlot(config.altarSide, config.altarSlot).label == slates.slateInfo[4].name then
            crafting = false
            --Move 1 Demonic Slate from Blood Altar to Chest
            transpose.transferItem(config.altarSide, config.chestSide, 1, config.altarSlot, config.slateDSlot)
        end
    end
end
 
function EtherealSlate()
    local crafting = true
    --move 1 Demonic Slate from chest to Blood Altar
    transpose.transferItem(config.chestSide, config.altarSide, 1, config.slateDSlot, config.altarSlot)
    while crafting do
        
        if transpose.getStackInSlot(config.altarSide, config.altarSlot).label == slates.slateInfo[5].name then
            crafting = false
            --Move 1 Ethereal Slate from Blood Altar to Chest
            transpose.transferItem(config.altarSide, config.chestSide, 1, config.altarSlot, config.slateESlot)
        end
    end
end

function writeToTerm()
    term.setCursor(1,1)
    getTankInfo()
    getReserveTankInfo()
    WriteRSBlood()
    term.clearLine()
    term.write("Making: ")
end


term.clear()
while true do
    SetDefaultStackInfo()
    writeToTerm(" ")
    
    currentTank = transpose.getFluidInTank(config.altarSide, config.altarTank).amount
    
    if config.BloodAltarTier >= slates.slateInfo[1].tier and stackInfo[1].label == slates.slateInfo[1].name and stackInfo[1].size < config.slateBCount and currentTank >= slates.slateInfo[1].blood then
        BlankSlate()
    elseif config.BloodAltarTier >= slates.slateInfo[2].tier and stackInfo[2].label == slates.slateInfo[2].name and stackInfo[2].size < config.slateRCount and currentTank >= slates.slateInfo[2].blood then
        ReinforcedSlate()
    elseif config.BloodAltarTier >= slates.slateInfo[3].tier and stackInfo[3].label == slates.slateInfo[3].name and stackInfo[3].size < config.slateICount and currentTank >= slates.slateInfo[3].blood then
        ImbuedSlate()
    elseif config.BloodAltarTier >= slates.slateInfo[4].tier and stackInfo[4].label == slates.slateInfo[4].name and stackInfo[4].size < config.slateDCount and currentTank >= slates.slateInfo[4].blood then
        DemonicSlate()
    elseif config.BloodAltarTier >= slates.slateInfo[5].tier and stackInfo[5].label == slates.slateInfo[5].name and stackInfo[5].size < config.slateECount and currentTank >= slates.slateInfo[5].blood then
        EtherealSlate()
    end
end
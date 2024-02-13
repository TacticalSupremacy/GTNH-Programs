sides = require("sides")

BloodAltarTier = 5  -- Change manually depending on your Altar level, Default: 5 (Tier: V)
 
slateBCount = 8 -- Blank Slates, Default: 8
slateRCount = 8 -- Reinforced Slates, Default: 8
slateICount = 8 -- Imbued Slates, Default: 4
slateDCount = 8 -- Demonic Slates, Default: 4
slateECount = 2 -- Etherial Slates, Default: 1
 
chestSide = sides.top   -- Default: sides.top (1)
stoneSide = sides.back   -- Default: 2 (Back)
altarSide = sides.right   --Default: 4 (Right)
reserveTankSide = sides.left    --Default: 5 (Left), this is only used if a tank is detected
 
rsInputSide = sides.bottom --Default: 4 (Right), This is right of a computer with a Redstone card or right of a Redstone I/O block
 
stoneSlot = 10  --Default: 10 (Slot 10 is the first export slot for a Refined Storage Interface, Change this as needed)
 
-- Altar slots do not need to be changed, unless WayOfTime add additional inventory slots or tanks to the Blood Altar
altarSlot = 1  
altarTank = 1
 
-- Slate Slots below are the first 5 slots of a chest, change these if you are not using any type of regular chest (NOT tested with other mods like Iron Chests)
slateBSlot = 1
slateRSlot = 2
slateISlot = 3
slateDSlot = 4
slateESlot = 5
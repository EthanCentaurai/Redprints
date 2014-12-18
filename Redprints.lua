
--<< ================================================= >>--
--     Upvalues                                          --
--<< ================================================= >>--

local _G = _G
local GetBuildingInfo = _G.C_Garrison.GetBuildingInfo
local GetMerchantItemLink = _G.GetMerchantItemLink
local GetMerchantNumItems = _G.GetMerchantNumItems
local MerchantFrame = _G.MerchantFrame
local MERCHANT_ITEMS_PER_PAGE = _G.MERCHANT_ITEMS_PER_PAGE
local SetItemButtonNameFrameVertexColor = _G.SetItemButtonNameFrameVertexColor
local SetItemButtonNormalTextureVertexColor = _G.SetItemButtonNormalTextureVertexColor
local SetItemButtonSlotVertexColor = _G.SetItemButtonSlotVertexColor
local SetItemButtonTextureVertexColor = _G.SetItemButtonTextureVertexColor
local tonumber = _G.tonumber


--<< ================================================= >>--
--     Blueprints Database                               --
--<< ================================================= >>--

local blueprintToBuilding = {
	-- SMALL BUILDINGS --
	
	-- Alchemy Lab
--	[111812] = 76,  -- Level 1
	[111929] = 119, -- Level 2
	[111930] = 120, -- Level 3
	
	-- Enchanter's Study
--	[111817] = 93,  -- Level 1
	[111972] = 125, -- Level 2
	[111973] = 126, -- Level 3
	
	-- Engineering Works
--	[109258] = 91,  -- Level 1
	[109256] = 123, -- Level 2
	[109257] = 124, -- Level 3
	
	-- Gem Boutique
--	[111814] = 96,  -- Level 1
	[111974] = 131, -- Level 2
	[111975] = 132, -- Level 3
	
	-- Salvage Yard
--	[111957] = 52,  -- Level 1
	[111976] = 140, -- Level 2
	[111977] = 141, -- Level 3
	
	-- Scribe's Quarters
--	[111815] = 95,  -- Level 1
	[111978] = 129, -- Level 2
	[111979] = 130, -- Level 3
	
	-- Storehouse
	[111982] = 142, -- Level 2
	[111983] = 143, -- Level 3
	
	-- Tailoring Emporium
--	[111816] = 94,  -- Level 1
	[111992] = 127, -- Level 2
	[111993] = 128, -- Level 3
	
	-- The Forge
--	[111813] = 60,  -- Level 1
	[111990] = 117, -- Level 2
	[111991] = 118, -- Level 3
	
	-- The Tannery
--	[111818] = 90,  -- Level 1
	[111988] = 121, -- Level 2
	[111989] = 122, -- Level 3
	
	
	-- MEDIUM BUILDINGS --
	
	-- Barn
	[111968] = 25,  -- Level 2
	[111969] = 133, -- Level 3
	
	-- Gladiator's Sanctum
	[111980] = 160, -- Level 2
	[111981] = 161, -- Level 3
	
	-- Lumber Mill
	[109254] = 41,  -- Level 2
	[109255] = 138, -- Level 3
	
	-- Lunarfall Inn / Frostwall Tavern
	[107694] = 35,  -- Level 2, Alliance
	[116431] = 35,  -- Level 2, Horde
	[109065] = 36,  -- Level 3, Alliance
	[116432] = 36,  -- Level 3, Horde
	
	-- Trading Post
	[111986] = 144, -- Level 2
	[111987] = 145, -- Level 3
	
	
	-- LARGE BUILDINGS --
	
	-- Barracks
--	[111956] = 26,  -- Level 1
	[111970] = 27,  -- Level 2
	[111971] = 28,  -- Level 3
	
	-- Dwarven Bunker / War Mill
	[111966] = 9,   -- Level 2, Alliance
	[116185] = 9,   -- Level 2, Horde
	[111967] = 10,  -- Level 3, Alliance
	[116186] = 10,  -- Level 3, Horde
	
	-- Gnomish Gearworks / Goblin Workshop
	[111984] = 163, -- Level 2, Alliance
	[116200] = 163, -- Level 2, Horde
	[111985] = 164, -- Level 3, Alliance
	[116201] = 164, -- Level 3, Horde
	
	-- Mage Tower / Spirit Lodge
	[109062] = 38,  -- Level 2, Alliance
	[116196] = 38,  -- Level 2, Horde
	[109063] = 39,  -- Level 3, Alliance
	[116197] = 39,  -- Level 3, Horde
	
	-- Stables
	[112002] = 66,  -- Level 2
	[112003] = 67,  -- Level 3
	
	
	-- UNCHANGEABLE BUILDINGS --
	
	-- Fishing Shack
--	[109578] = 64,  -- Level 1
	[111927] = 134, -- Level 2
	[111928] = 135, -- Level 3
	
	-- Herb Garden
	[109577] = 136, -- Level 2
	[111997] = 137, -- Level 3
	
	-- Lunarfall Excavation / Frostwall Mines
	[109576] = 62,  -- Level 2, Alliance
	[116248] = 62,  -- Level 2, Horde
	[111996] = 63,  -- Level 3, Alliance
	[116249] = 63,  -- Level 3, Horde
	
	-- Pet Menagerie
	[111998] = 167, -- Level 2
	[111999] = 168, -- Level 3
}


--<< ================================================= >>--
--     The Vendor Hook                                   --
--<< ================================================= >>--

local function PaintItRed()
	if MerchantFrame.selectedTab ~= 1 then return end -- buyback tab

	local numitems = GetMerchantNumItems()

	for i=1, MERCHANT_ITEMS_PER_PAGE do
		local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)

		if index > numitems then break end

		local itemButton = _G["MerchantItem"..i.."ItemButton"]
		local merchantButton = _G["MerchantItem"..i]

		if not itemButton or not merchantButton then break end

		local itemLink = GetMerchantItemLink(index)
		local blueprint = tonumber( itemLink:match("item:(%d+)") )

		local buildingID = blueprintToBuilding[blueprint]

		if buildingID then
			-- id, name, texPrefix, icon, description, _, currencyID, currencyQty, goldQty, buildTime, needsPlan
			local _, _, _, _, _, _, _, _, _, _, needsPlan = GetBuildingInfo(buildingID)

			if not needsPlan then
				SetItemButtonNameFrameVertexColor(merchantButton, 0, 1, 0)
				SetItemButtonSlotVertexColor(merchantButton, 0, 1, 0)
				SetItemButtonTextureVertexColor(itemButton, 0, 1, 0)
				SetItemButtonNormalTextureVertexColor(itemButton, 0, 1, 0)
			end
		end
	end
end

hooksecurefunc("MerchantFrame_UpdateMerchantInfo", PaintItRed)

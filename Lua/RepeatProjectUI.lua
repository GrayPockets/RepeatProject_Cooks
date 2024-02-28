
function OnLocalPlayerTurnBegin()	
	RP_TurnActiveFlag = true;
end


--?^?[???I??????v???W?F?N?g??I?????????s?s????
function OnLocalPlayerTurnEnd()	
	local playerID	:number = Game.GetLocalPlayer();
	local pPlayer	:table = Players[playerID];
	if (pPlayer == nil) then
		return;
	end

	--?e?[?u?????????
	RP_ProjectCity = {}

	for i, pCity in pPlayer:GetCities():Members() do
		--?????L???[
		local currentlyBuilding = pCity:GetBuildQueue():GetCurrentProductionTypeHash()
		if(currentlyBuilding ~= nil) then
			for j, pType in pairs(RP_ProjectType) do
				if(currentlyBuilding == pType) then			
					RP_ProjectCity[pCity:GetName()] = currentlyBuilding
				end
			end
		end
    end
end

--?^?[???J?n????v???W?F?N?g????Z?b?g
function OnPlayerTurnActivated()	
	--???v???C???[??^?[????X?L?b?v
	if(RP_TurnActiveFlag == false) then
		return;
	end

	
	local playerID	:number = Game.GetLocalPlayer();
	local pPlayer	:table = Players[playerID];
	if (pPlayer == nil) then
		return;
	end
	
	local tParameters = {};
	if(RP_ProjectCity ~= nil) then
		for i, pCity in pPlayer:GetCities():Members() do
			if (CurrentlyBuildingCheck(pCity) == 0) then
				local tParameters = {};
				for key, value in pairs(RP_ProjectCity) do
					if(pCity:GetName() == key) then
						tParameters[CityOperationTypes.PARAM_PROJECT_TYPE] = value
						tParameters[CityOperationTypes.PARAM_INSERT_MODE] = CityOperationTypes.VALUE_EXCLUSIVE;
						CityManager.RequestOperation(pCity, CityOperationTypes.BUILD, tParameters);
					end
				end
			end --CurrentlyBuildingCheck
		end
	end

	RP_TurnActiveFlag = false;
end

function CurrentlyBuildingCheck(pCity)
	if (pCity ~= nil) then
		return pCity:GetBuildQueue():GetCurrentProductionTypeHash();
	end
	return "";
end



function Initialize()

	RP_TurnActiveFlag = false
	RP_ProjectCity = {}
	
	RP_ProjectType = {
		GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_HOLY_SITE"].Hash,
		GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_CAMPUS"].Hash,
		GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_ENCAMPMENT"].Hash,
		--GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_HARBOR"].Hash, -- Support Arsenals is for Admirals
		GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_COMMERCIAL_HUB"].Hash,
		GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_THEATER"].Hash,
		GameInfo.Projects["PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE"].Hash,
		GameInfo.Projects["PROJECT_CARNIVAL"].Hash
	}
	
	--Rise and Fall
	for t in GameInfo.Projects() do
		if(t.Name == "LOC_PROJECT_BREAD_AND_CIRCUSES_NAME") then -- Includes PROJECT_WATER_BREAD_AND_CIRCUSES
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_WATER_CARNIVAL_NAME") then
			table.insert(RP_ProjectType, t.Hash)
		end
	end	
	
	--Gathering Storm
	for t in GameInfo.Projects() do
		if(t.Name == "LOC_PROJECT_CARBON_RECAPTURE_NAME") then
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_TRAIN_ATHLETES_NAME") then
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_TRAIN_ASTRONAUTS_NAME") then
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_SEND_AID_NAME") then -- Allow Send Aid to repeat
			table.insert(RP_ProjectType, t.Hash)
		end
	end	

	--DLC -- Fully Tested
	for t in GameInfo.Projects() do
		if(t.Name == "LOC_PROJECT_COURT_FESTIVAL_NAME") then -- Catherine de Medici Persona Pack
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_LIJIA_FAITH_NAME") then -- Rulers of China Pack
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_LIJIA_FOOD_NAME") then -- Rulers of China Pack
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_LIJIA_GOLD_NAME") then -- Rulers of China Pack
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_OCCULT_RESEARCH_NAME") then -- Ethiopia Pack
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_DARK_SUMMONING_NAME") then -- Ethiopia Pack
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_AIF_SCENARIO_NAME") then -- Australia Civilization & Scenario Pack (for completeness)
			table.insert(RP_ProjectType, t.Hash)
		elseif(string.sub(t.Name,1,39)=="LOC_PROJECT_CREATE_CORPORATION_PRODUCT_") then -- All Products (Including Sukritact's Resources and Civitas Resources) -- Tested
			table.insert(RP_ProjectType, t.Hash)
		end
	end

	--Mods -- Fully Tested
	for t in GameInfo.Projects() do
		if(t.Name == "LOC_PROJECT_ENHANCE_DISTRICT_HARBOR_NAME") then -- Arsenals is for Admirals
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_ENHANCE_DISTRICT_ARSENAL_NAME") then -- Arsenals is for Admirals
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_LEU_ENHANCE_DISTRICT_PRESERVE_NAME") then -- Leugi's Greenery: Preserve Rework
			table.insert(RP_ProjectType, t.Hash)
		elseif(t.Name == "LOC_PROJECT_LEU_ENHANCE_DISTRICT_LEU_GARDEN_NAME") then -- Leugi's Greenery: Garden District
			table.insert(RP_ProjectType, t.Hash)
		end
	end

	Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin)
	Events.PlayerTurnActivated.Add(OnPlayerTurnActivated)
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd) -- ?^?[???I????
	
end


Initialize()
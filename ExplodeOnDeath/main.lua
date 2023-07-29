local ExplodeOnDeath = RegisterMod("ExplodeOnDeath", 1)

---@param player EntityPlayer
local function GetEffectiveHealth(player)
	local BoneHearts = player:GetBoneHearts() -- Bone Hearts = 1 each
	local EternalHearts = player:GetEternalHearts() -- Eternal Hearts = 1 each
	local Hearts = player:GetHearts() -- full Red Heart = 2, half Red Heart = 1
	local RottenHearts = player:GetRottenHearts() -- Rotten Hearts = 1
	local SoulHearts = player:GetSoulHearts() -- full Soul Heart = 2, half Soul Heart = 1; includes Black Hearts

	local hitsLeft = BoneHearts + EternalHearts + Hearts - RottenHearts + SoulHearts -- subtract Rotten Hearts from Hearts because EntityPlayer:GetHearts() improperly counts Rotten Hearts as 2 instead of 1
	--print("[DEBUG] Player health: " .. tostring(hitsLeft))
	--print("[DEBUG] Red: " .. (Hearts - RottenHearts * 2) .. " | Rotten: " .. RottenHearts .. " | Etrn: " .. EternalHearts .. " | Bone: " .. BoneHearts .. " | Soul: " .. SoulHearts)
	return hitsLeft
end

---@param entity Entity
---@param amtDmg number
---@param dmgFlags DamageFlag
function ExplodeOnDeath:OnDamageTaken(entity, amtDmg, dmgFlags)
	local player = entity:ToPlayer() -- returns nil if unsucessful
	if player then
		--print("[DEBUG] amtDmg: " .. amtDmg)
		if GetEffectiveHealth(player) - amtDmg <= 0 then -- if they are about to die
			-- spawn funny death explosion
			Isaac.Explode(player.Position, player, 0)
		end
	end
end

ExplodeOnDeath:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ExplodeOnDeath.OnDamageTaken)
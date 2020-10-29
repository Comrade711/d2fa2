

function Alternate01Create (keys)
	local caster = keys.caster 
	print('skin 01 add')
	if caster:GetName() == "npc_dota_hero_skywrath_mage" then 	
		print('skin gilgamesh casual')
		caster:SetModel("models/updated_by_seva_and_hudozhestvenniy_film_spizdili/gilgamesh/gilgameshcasualunanim.vmdl")
		caster:SetOriginalModel("models/updated_by_seva_and_hudozhestvenniy_film_spizdili/gilgamesh/gilgameshcasualunanim.vmdl")
		caster:SetModelScale(1.2)
		print('skin gilgamesh change')
	end

end

function Alternate01Destroy (keys)
	local caster = keys.caster 
	if caster:GetName() == "npc_dota_hero_skywrath_mage" then 
		caster:SetModel("models/gilgamesh/gilgamesh.vmdl")
		caster:SetOriginalModel("models/gilgamesh/gilgamesh.vmdl")
	end

end
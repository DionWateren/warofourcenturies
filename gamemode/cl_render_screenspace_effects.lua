local customMaterial = Material( "pp/colour" )

hook.Add("RenderScreenspaceEffects", "ColorExample", function()
	render.UpdateScreenEffectTexture()

	customMaterial:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

	customMaterial:SetFloat( "$pp_colour_addr", 0 )
	customMaterial:SetFloat( "$pp_colour_addg", 0 )
	customMaterial:SetFloat( "$pp_colour_addb", 0 )
	customMaterial:SetFloat( "$pp_colour_mulr", 0 )
	customMaterial:SetFloat( "$pp_colour_mulg", 0 )
	customMaterial:SetFloat( "$pp_colour_mulb", 0 )
	customMaterial:SetFloat( "$pp_colour_brightness", 0 )
	customMaterial:SetFloat( "$pp_colour_contrast", 0.5 )
	customMaterial:SetFloat( "$pp_colour_colour", 5 )

	render.SetMaterial( customMaterial )
	render.DrawScreenQuad()
end )
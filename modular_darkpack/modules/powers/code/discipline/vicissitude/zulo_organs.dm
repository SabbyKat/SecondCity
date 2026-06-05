// Sabby: this set Zulo form bodypart types used by /datum/species/tzimisce_zulo_form
// Sabby: mostly taken by using the same method as garou_organs.dm

/obj/item/bodypart/head/zulo
	head_flags = NONE
	limb_id = "tzizu1" // The limb_id part of garou organs is commented out, I learned that I need this, because it needs to point to the new "tzizu1" sprites.
	is_dimorphic = FALSE //Sabby: the bodyparts defined in bloodform.dm use is_dimorphic = FALSE. Not sure what it does, but I felt good to maintain code standard

/obj/item/bodypart/chest/zulo
	limb_id = "tzizu1"
	is_dimorphic = FALSE

/obj/item/bodypart/arm/left/zulo
	limb_id = "tzizu1"
	is_dimorphic = FALSE
	unarmed_sharpness = SHARP_EDGED
	unarmed_attack_verbs = list("slash", "tear","gash","cut") // Sabby: I figured 'claw' as verbs made no sense for zulo, but these different ones do.
	unarmed_attack_verbs_continuous = list("slashes", "tears","gash","cuts")
	appendage_noun = "claw" // Sabby: is apependage noun necessary? Garou uses, but Blood form doesn't use it
	unarmed_attack_effect = ATTACK_EFFECT_CLAW // Sabby: maintained from garou. Not sure what other attack effects there are
	unarmed_attack_sound = 'sound/items/weapons/slash.ogg' // Sabby: I played a bunch of oggs from the folder and the usual slash seemed to be the right go-to
	unarmed_miss_sound = 'sound/items/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/zulo
	limb_id = "tzizu1"
	is_dimorphic = FALSE
	unarmed_sharpness = SHARP_EDGED
	unarmed_attack_verbs = list("slash", "tear","gash","cut")
	unarmed_attack_verbs_continuous = list("slashes", "tears","gash","cuts")
	appendage_noun = "claw"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/items/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/items/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/zulo // Sabby: legs maintain the limb_id and unarmed_sharpness from garou (but the former activated), plus the dimorphic from bloodform
	limb_id = "tzizu1"
	is_dimorphic = FALSE
	unarmed_sharpness = SHARP_EDGED

/obj/item/bodypart/leg/right/zulo
	limb_id = "tzizu1"
	is_dimorphic = FALSE
	unarmed_sharpness = SHARP_EDGED

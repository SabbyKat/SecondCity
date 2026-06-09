/* Sabby:
This is a project to rebase the oldcode Zulo from The Final Nights, originally coded by Magisterium into the Dark Pack rebase.
The reason for this project is because old code Zulo functioned very, very well, and works as a carbon species rather than a basicmob.
I used the fera_species.dm code as a base template, whilst also taking cues from blood form and other vicissitude code.
*/

/* Sabby: from my understanding, mob/living/carbon/human is defined for the very first time ever in fera_species.dm? If so, seeing as I'm using it for
Zulo and other species code might use it in the future, would it be betetr to move the statements out of fera species and into its own dm? */

// /mob/living/carbon/human/update_body_parts(update_limb_data)
// 	if(dna?.species?.update_body_parts(src))
// 		return
// 	return ..()
// /datum/species/proc/update_body_parts(mob/living/carbon/human/human)
// 	return

// /mob/living/carbon/human/update_damage_overlays()
// 	if(dna?.species?.update_damage_overlays(src))
// 		return
// 	return ..()

// /datum/species/proc/update_damage_overlays(mob/living/carbon/human/human)
// 	return

/* Learning notes to self:
1. DO NOT define on_species_gain and loss for the exact same species datum more than once for that datum, ever.
	Consolidate everything into the same gain/loss define.
2. Masquerade_Violating_Face seems to do what any veil_breaching_form declarations that exited for fera_species.dm did
*/
// Sabby: below is just something I preserved from old basic mob zulo code for now, to prevent breaking on start up for testing and to figure out how to adapt for future carbon sprite selections
GLOBAL_LIST_INIT(zulo_forms, list(
	"Beast" = "weretzi",
	"Brust" = "4armstzi",
))


/datum/species/tzimisce_zulo_form
	name = "Zulo"
	plural_form = "Zulo"
	id = SPECIES_ZULO_FORM
	examine_limb_id = SPECIES_ZULO_FORM // Sabby: unsure of use, but adapted from blood form to keep the code consistent.
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	inherent_traits = list( // Sabby: note, a lot of traits came from my painstakingly looking at trait definitions, tracking them down in the code and checking what they seem to do.
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
		TRAIT_MASQUERADE_VIOLATING_FACE,
		TRAIT_STRONG_GRABBER, // Sabby: feels appropriate for a large warform to be able to skip passive grab and go into Agg grab.
		TRAIT_GIANT, // Sabby:  functionality at tackle.dm row 380. Makes target harder to tackle. Feels appropriate for large warform.
		TRAIT_PUSHIMMUNE, // Sabby: present in oldcode. According to living_defense.dm, it prevents an agg grab. By name, I thought it would prevents shove. I still believe it makes sense for a war form to not be agg grabbed.
		TRAIT_HARDLY_WOUNDED, // Sabby: present in oldcode. Functionality found in wounds.dm line 61. I don't quite understand what it does, however. Reduces wounds from damage? What does that mean?
		TRAIT_BRAWLING_KNOCKDOWN_BLOCKED, // Sabby: new feature. Found from declarations list and studied from item_attack.dm line 463 and tackle.dm. Basically keeps target from getting knocked down on hand-to-hand? Makes sense for a war form, however would like to add excpetion for attacks coming from a crinos.
		TRAIT_NO_STAGGER, // Sabby: new feature. Found from declarations list and studied from staggered.dm. Prevents application of /datum/status_effect/staggered (which is basically a daze sort of effect). Reason: large, lumbering war form. Again, exception vs crinos?
		TRAIT_NO_THROW_HITPUSH, // Sabby: new feature. Found from declarations list and studied from staggered.dm line 1330. Basically: prevents application of hitpush when hit by thrown items. Reasoning: same as above.
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_BLOOD_OVERLAY, // Sabby: got this from Fera code. Seems like it prevents bloody footprints? Might remove for Zulo.
		TRAIT_TRANSFORM_UPDATES_ICON, // Sabby: taken from fera code. Honestly not sure what it does. Need some assist.
		TRAIT_NO_CUFF, // Sabby: huge, monstrous warform probably impossible to cuff
		TRAIT_MUTANT_COLORS // Sabby: paired with fixed_mut_color below to give Zulo its own fixed sprite color rather than the character's skin tone
	)
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE | ITEM_SLOT_HEAD | ITEM_SLOT_EYES | ITEM_SLOT_EARS
	// Sabby: important to retain at least backpack slot - the Tzimisce soil bag needs to remain on the character.
	exotic_bloodtype = BLOOD_TYPE_KINDRED
/* Sabby: necessary vars for capturing pre-Zulo social stats and size for restoration on species loss */
	var/old_appearance
	var/old_manipulation
	var/old_charisma
	var/old_size
/* Zulo-specific bodyparts are defined in zulo_organs.dm. */
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zulo,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zulo,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zulo,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zulo,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zulo,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zulo,
	)
	var/mob_pixel_w = 0
	var/mob_pixel_z = 0

	// Sabby: flesh tone for tzizu1 greyscale sprites — grabbed the hex from the lightest bone-color used by the current zulo sprite.
	// Sabby: Paired with TRAIT_MUTANT_COLORS above to stop Zulo inheriting the character's skin color.
	// Sabby: may need revisiting if Zulo eventually supports multiple sprite options, since one fixed color won't suit all of them.
	fixed_mut_color = "#e5e0d0"

	/// Speed mod applied and removed upon gaining this species
	var/speed_mod = /datum/movespeed_modifier/tzimisce_zulo_form
	/// Fallback dmi to refrence if we fail to get one from our splat (this is what original comment said. Confused on how to implement for zulo?) Magisterium:That'd be a basic dmi with a basic sprite so they don't turn invisible if anything goes wrong. You'd want to create a backup one in that case.
	// var/fallback_icon = 'path/to/zulo.dmi'

/datum/species/tzimisce_zulo_form/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(speed_mod)
		human_who_gained_species.add_movespeed_modifier(speed_mod)
	human_who_gained_species.hairstyle = "Bald"
	human_who_gained_species.facial_hairstyle = "Shaved"
	human_who_gained_species.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	human_who_gained_species.add_offsets(type, w_add = mob_pixel_w, z_add = mob_pixel_z)
	human_who_gained_species.update_mob_height()
	old_size = human_who_gained_species.current_size
	human_who_gained_species.update_transform(1.50)
	old_appearance = human_who_gained_species.st_get_stat(STAT_APPEARANCE)
	old_manipulation = human_who_gained_species.st_get_stat(STAT_MANIPULATION)
	old_charisma = human_who_gained_species.st_get_stat(STAT_CHARISMA)
 // Sabby: I've been trying to reliably find ways to set social stats to 0 for Zulo.
 // Currently trying a new approach with just doing a negative mod equivalent to the total of the character's socials
 // before the transformation, then removing the mod on species loss. I'm not sure if I needed to put the if > 0 statements
 // for each, but the reason for that is because I'm concerned if something might break if someone already has base
 // appearance 0 and the code my crash/break if it tries to do a negative 0 mod.

	/// Sabby: +3 stat boots to all physical stats, and socials to 0 as per V20 - pages: 242
	if(old_appearance > 0)
		human_who_gained_species.st_add_stat_mod(STAT_APPEARANCE, -old_appearance, type)
	if(old_manipulation > 0)
		human_who_gained_species.st_add_stat_mod(STAT_MANIPULATION, -old_manipulation, type)
	if(old_charisma > 0)
		human_who_gained_species.st_add_stat_mod(STAT_CHARISMA, -old_charisma, type)
	human_who_gained_species.st_add_stat_mod(STAT_STRENGTH, 3, type)
	human_who_gained_species.st_add_stat_mod(STAT_DEXTERITY, 3, type)
	human_who_gained_species.st_add_stat_mod(STAT_STAMINA, 3, type)
	human_who_gained_species.remove_overlay(BODY_ADJ_LAYER)

/datum/species/tzimisce_zulo_form/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	if(speed_mod)
		human.remove_movespeed_modifier(speed_mod)
	/* Sabby: below is taken from oldcode to revert the = "bald" on_gain settinge from above. Does it work?
	From my understanding, the /choiced/hairstyle, etc. stuff is what's needed to call the player's selected things?
	*/
	if(human.client)
		human.hairstyle = human.client.prefs.read_preference(/datum/preference/choiced/hairstyle)
		human.facial_hairstyle = human.client.prefs.read_preference(/datum/preference/choiced/facial_hairstyle)
	human.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	human.remove_offsets(type)
	human.update_transform(old_size/human.current_size)
	human.st_remove_stat_mod(STAT_APPEARANCE, type) //Sabby: this should restore user's social stats when exiting Zulo
	human.st_remove_stat_mod(STAT_MANIPULATION, type) //Sabby: this should restore user's social stats when exiting Zulo
	human.st_remove_stat_mod(STAT_CHARISMA, type) //Sabby: this should restore user's social stats when exiting Zulo
	human.st_remove_stat_mod(STAT_STRENGTH, type)
	human.st_remove_stat_mod(STAT_DEXTERITY, type)
	human.st_remove_stat_mod(STAT_STAMINA, type)

/datum/movespeed_modifier/tzimisce_zulo_form
	multiplicative_slowdown = -0.25
	movetypes = GROUND

/* Sabby:
This is a project to rebase the oldcode Zulo from The Final Nights, originally coded by Magisterium into the Dark Pack rebase.

The reason for this project is because old code Zulo functioned very, very well, and works as a carbon species rather than a basicmob.

I used the fera_species.dm code as a base template
*/

/* Sabby: Okay. I commented rows below (19 to 32) for a specific reason: /mob/living/carbon/human/ is already inherent to base TG code, correct? And I'm using, as stated above,
the fera_species.dm file as a basis for the new zulo refactor, as recommended by Abby. The thing is that, since that original fera_species.dm is already defining
for /mob/living/carbon/human an update_pode_parts proc, then if I keep this duplicated in the new zulo file, it will cause errors because it's a duplicate of
something being created for a universal human carbon mob, right?

And these rows basically allow the carbon mob to override the original base tg human sprite in favor of, for example, the weretzi sprite, correct?

Please correct me if I'm wrong! And if that's also the case, could it maybe be a good idea to move those original rows from fera_species.dm out into a sort of
universal 'human carbon mob utilities' sort of .dm file for people to reference? */

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

/*Sabby: okay, so, the way this works pulling from the original fera_species.dm, is that the code that first defines a base datum/species/human/shifter type,
and it is basically a base shifter form full of declared vars. Then it builds the subsequent glabro, crinos, etc. by inheriting from the base shifter
type and modifying the declared vars in the shifter type.

This is not needed for Zulo form, because it's one zulo form. So is it acceptable practice to just do the single species datum, declare its vars and already
set the var values in its declarations (such as, for example, the list of stat bonuses)?
*/


/*
Sabby:
IMPORTANT QUESTION:

The following, below, is implemented in the Kindred SPLAT to account for the canonical damage reductions that Kindred have:

if ((damagetype == BRUTE) && (sharpness != SHARP_EDGED))
    damage_mods += 0.5

HOWEVER, this is /datum/splat/, not /datum/species/. Do I need to replicate the above lines somewhere below down in Zulo code?

*/

/* Learning notes to self:
1. DO NOT define on_species_gain and loss for the exact same species datum more than once for that datum, ever.
	Consolidate everything into the same gain/loss define.
2. Masquerade_Violating_Face seems to do what any veil_breaching_form declarations that exited for fera_species.dm did
*/
/datum/species/tzimisce_zulo_form
	name = "Zulo"
	plural_form = "Zulo"
	id = SPECIES_TZIMISCE_ZULO_FORM // we need to add this to the definitions dm files?
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID /* Sabby: I admit I'm trying to understand what 'inherent_biotypes' does, I took it as a cue from bloodform code,
	and, through testing, saw that we have 'MOB_UNDEAD' as an option, so I figured it would be appropriate for Zulo as a species due to being, well, undead. */
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER, // Sabby: present in oldcode. should allow for equiping tools/items in hand?
		TRAIT_LIMBATTACHMENT, // Sabby: present in oldcode. learned its functionality from bodyparts.dm line 600. Allows easy limb reattachment. Is this needed, given Kindred splat?
		TRAIT_VIRUSIMMUNE, // Sabby: present in oldcode. should make immune to disease. It seems to check mob living carbon human with CanContractDisease.
		TRAIT_NOBLOOD, // Sabby: present in oldcode. again from living carbon traits. Should prevent bleeding and blood loss? Makes sense for anything vampire/undead
		TRAIT_NOHUNGER, // Sabby: present in oldcode. pulls in nutrition toggle from mob.dm row 1494. Used to prevent undead from conventional food hunger?
		TRAIT_NOBREATH, // Sabby: present in oldcode. found functionality to study/understand on _lungs.dm it simply untoggles check_breath from lungs if = TRAT_NOBREATH.
		TRAIT_TOXIMMUNE, // Sabby: present in oldcode. studed functionality on damage_procs.dm. Basically untoggles toxic damage?
		TRAIT_NOCRITDAMAGE, // Sabby: present in oldcode. still a bit fuzzy on how this works. life.dm has functionality description. Basically keeps from going into critical?
		TRAIT_MASQUERADE_VIOLATING_FACE, // Sabby: present in oldcode. pretty self-explanatory I feel
		TRAIT_STRONG_GRABBER, // Sabby: present in oldcode. struggling to understand functionality from living.dm (~ line 410). Sensible for big war form to be strong at grabs, however.
		TRAIT_GIANT, // Sabby: present in oldcode. simple functionality at tackle.dm row 380. Makes target harder to tackle. It's a giant war form, complete with sprite and pixel offset.
		TRAIT_PUSHIMMUNE, // Sabby: present in oldcode. According to living_devense.dm, it prevents an agg grab. By name, I thought it would prevents shove. I still believe it makes sense for a war form to not be agg grabbed. However, a crinos should be able to?
		TRAIT_HARDLY_WOUNDED, // Sabby: present in oldcode. Functionality found in wounds.dm line 61. I don't quite understand what it does, however. Reduces wounds from damage? What does that mean?
		TRAIT_BRAWLING_KNOCKDOWN_BLOCKED, // Sabby: new feature. Found from declarations list and studied from item_attack.dm line 463 and tackle.dm. Basically keeps target from getting knocked down on hand-to-hand? Makes sense for a war form, however would like to add excpetion for attacks coming from a crinos.
		TRAIT_NO_STAGGER, // Sabby: new feature. Found from declarations list and studied from staggered.dm. Prevents application of /datum/status_effect/staggered (which is basically a daze sort of effect). Reason: large, lumbering war form. Again, exception vs crinos?
		TRAIT_NO_THROW_HITPUSH, // Sabby: new feature. Found from declarations list and studied from staggered.dm line 1330. Basically: prevents application of hitpush when hit by thrown items. Reasoning: same as above.
		TRAIT_NO_UNDERWEAR, // Sabby: saw this on Fera code. Is it relevant, considering I added setting underwear to none manually below on species gain?
		TRAIT_NO_BLOOD_OVERLAY, // Sabby: got this from Fera code. Seems like it prevents bloody footprints? Might remove for Zulo.
		TRAIT_NO_LYING_ANGLE, // Sabby: got this from Fera code. Seems to just prevent sprite from going horizontal? Could be relevant.
		TRAIT_TRANSFORM_UPDATES_ICON, // Sabby: taken from fera code. Honestly not sure what it does. Need some assist.
		TRAIT_PULL_BLOCKED, // Sabby: found this in declarations, but it seems to have no code anywhere? By the name, would make sense for zulo.
		TRAIT_NO_CUFF, // Sabby: huge, monstrous warform probably impossible to cuff
		TRAIT_USES_SKINTONES // Sabby: noticed it present in many living/carbon/ species (vampire.dm, humans.dm, etc.). Important? Still not sure what it does.
	)
	no_equip_flags = ITEM_SLOT_ON_BODY | ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE
	changesource_flags = NONE /* Sabby: doesn't this need to be set to the individual flags, using Blood form as example? */
/* Sabby: Needs to make sure to maintain Kindred blood type, as this is speciescode and doesn't derive from the splat */
	exotic_bloodtype = BLOOD_TYPE_KINDRED

/* Sabby: note - old code Zulo manually listed toxic_food and liked_food types, this is obselete now as I noticed everything is declared in the vampire
organ tongue, and can be brought in via mutant similarly to how it works for werewolf code */
	mutanttongue = /obj/item/organ/tongue/vampire // there is such a thing in vampire.dm - need to study it

/* Visible gender override, I believe, is just fluff stuff? Do we care about this for zulo, given it may eventually have many diverse sprites */
	visible_gender_override = "beast"

/* Sabby: necessary var for capturing pre-Zulo appearance stat for transformation appearance change/restore */
	var/old_appearance

/* form what i understand, this has to do with a procedure called update_body_parts and update_damage_parts to allow it to override renders. Do we want that?*/
	var/custom_body_render = TRUE
	var/custom_damage_render = TRUE

/* Below was also borrowed from shifter/dire. We might have to do limb overrides for zulo, considering most don't look distinctly human?
The zulo bodypart items and zulo organs/limbs do not exist at all in code, for purposes of damage, etc.
*/
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zulo,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zulo,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zulo,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zulo,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zulo,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zulo,
	)

/* Do we want to set specific pixel offsets? Check oldcode. Below values are placeholders */
	var/mob_pixel_w = -1
	var/mob_pixel_z = -1

	/// Sabby: +3 stat boots to all physical stats, as per V20 - pages: 242
	/// Sabby: note - Zulo should set appearance to 0. This is handled in code below on species gain, works differently from this list.
	var/list/form_bonus_stats = list(
	STAT_STRENGTH = 3,
	STAT_DEXTERITY = 3,
	STAT_STAMINA = 3
	)
	/// Fallback dmi to refrence if we fail to get one from our splat (this is what original comment said. Confused on how to implement for zulo?)
	var/fallback_icon = 'path/to/zulo.dmi'

	/* do we need to set speedmod's value into a var to be used below, or do we just want to declare the var value here and that's it? */
	/// Speed mod applied and removed upon gaining this species
	var/speed_mod = /datum/movespeed_modifier/tzimisce_zulo_form

/* Sabby: okay, so, again, still learning and this will probably take a good long while. But from what i'm understanding of the below code,
on_species_gain and similar things apply to the datum being defined. So, previously, it was /datum/species/human/shifter/on_species_gain.

From my understanding, translating into simple terms, that meant: 'when something gaints the /shifter/ species first ever defined here
in fera_species.dm, then do XYZ.

This means that I had to redefine it, for zulo, into /datum/species/tzimisce_zulo_form/on_species_gain to say:

'when something first gains the zulo form species, then apply XYZ'.

And vars and procs (such as add_buffs) don't necesarily have to come before the /datum/, in the code, for it to work?

On_Species_loss just reverts the character to baseline carbon human, undoes all changes.

Am I correct in this?

And then, all that the code below does is:
Apply on_species_gain to zulo form. And it does not need a /proc/ here because it already exists as a proc for /datum/species as a base,
in _species.dm, right? Defines human_who_gained_species for the code following

I do not understand why it needs the "old_species" definition
Do not yet understand what pref_load and regenerate_icons do
*/
/datum/species/tzimisce_zulo_form/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(speed_mod)
		human_who_gained_species.add_movespeed_modifier(speed_mod)
	human_who_gained_species.hairstyle = "Bald" // Sabby: same as oldcode. Necessary?
	human_who_gained_species.facial_hairstyle = "Shaved" // Sabby: same as oldcode. Necessary?
	human_who_gained_species.undershirt = "Nude" // Sabby: same as oldcode. Necessary?
	human_who_gained_species.underwear = "Nude" // Sabby: same as oldcode. Necessary?
	human_who_gained_species.socks = "Nude" // Sabby: same as oldcode. Necessary?
	/*Sabby: looking through the code, I noticed that such things exists in buffs.dm and and so on. Basically,
	they work to prevent a given datum from suffering from any damage-based movespeed penalties? It seems fair to apply
	to zulo, given it's a large warform? Possibly same for Crinos, in fact.

	In OldCode Zulo on TFN, it had 'TRAIT_IGNOREDAMAGESLOWDOW', which was the equivalent of this.

	I came across this solution while researching how to implement a similar functionality in the new code.*/
	human_who_gained_species.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	human_who_gained_species.add_offsets(type, w_add = mob_pixel_w, z_add = mob_pixel_z)
	/* Sabby: below should configure any sprite and mob size changes which we may want for zulo */
	human_who_gained_species.update_mob_height()
	human_who_gained_species.update_transform(1.25)
	add_buffs(human_who_gained_species)
	old_appearance = human_who_gained_species.st_get_stat(STAT_APPEARANCE) //Sabby: grabs and feeds into old_appearance var the user's appearance stat
	old_manipulation = human_who_gained_species.st_get_stat(STAT_MANIPULATION) //Sabby: grabs and feeds into old_appearance var the user's appearance stat
	old_charisma = human_who_gained_species.st_get_stat(STAT_CHARISMA) //Sabby: grabs and feeds into old_appearance var the user's appearance stat
	human_who_gained_species.st_set_stat(STAT_APPEARANCE,0) //Sabby: all Social stats drop to 0, as per V20 - pages: 242
	human_who_gained_species.st_set_stat(STAT_MANIPULATION,0) //Sabby: all Social stats drop to 0, as per V20 - pages: 242
	human_who_gained_species.st_set_stat(STAT_CHARISMA,0) //Sabby: all Social stats drop to 0, as per V20 - pages: 242


/datum/species/tzimisce_zulo_form/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	if(speed_mod)
		human.remove_movespeed_modifier(speed_mod)
	/* Sabby: below is taken from oldcode to revert the = "bald" and = "nude" on_gain settinge from above. Does it work?
	From my understanding, the /choiced/hairstyle, etc. stuff is what's needed to call the player's selected things?
	*/
	if(human.client)
		human.hairstyle = human.client.prefs.read_preference(/datum/preference/choiced/hairstyle)
		human.facial_hairstyle = human.client.prefs.read_preference(/datum/preference/choiced/facial_hairstyle)
		human.undershirt = human.client.prefs.read_preference(/datum/preference/choiced/undershirt)
		human.underwear = human.client.prefs.read_preference(/datum/preference/choiced/underwear)
		human.socks = human.client.prefs.read_preference(/datum/preference/choiced/socks)
	/*Sabby: I couldn't find by searching the codebase a 'remove' equivalent to the movespeed immunities from above.
	Does this work?*/
	human.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	human.remove_offsets(type)
	human.update_mob_height()
	human.update_transform()
	clear_buffs(human)
	human.st_set_stat(STAT_APPEARANCE,old_appearance) //Sabby: this should restore user's social stats when exiting Zulo
	human.st_set_stat(STAT_MANIPULATION,old_manipulation) //Sabby: this should restore user's social stats when exiting Zulo
	human.st_set_stat(STAT_CHARISMA,old_charisma) //Sabby: this should restore user's social stats when exiting Zulo

/datum/movespeed_modifier/tzimisce_zulo_form
	multiplicative_slowdown = -0.25
	movetypes = GROUND

/*Sabby: okay. So, time for me to start understanding for loops. Let me see if I got this straight for this below loop:
First, we're defining the add_buffs proc for the zulo species.
Next, we're setting the for loop.
First, var/key is necessary because a for loop does not understand, automatically, that a variable being called into it is a key?
Second, it sets 'value', that's because that's what it needs to apply.
Third: it needed to set var/key for it to understand that the first amount is a key, then the second one is a value. This is because it's
going to take the buff amounts from a LIST type created in form_bonus_stats. And that list in there is set as an associative list with key = value pattern?
Fourth: for each instance in that list, it runs a check if should add buff is true.
Fifth: if it is, it runs st_add_stat_mod

So the rows below are first defining the add_buffs procedure to be called somewhere.
Should_add_buff is called internally by this first one.
Then it sets up clear_buffs which just *also8 runs through the form_bonus_stats list and reverses them.
*/
/datum/species/tzimisce_zulo_form/proc/add_buffs(mob/living/carbon/human/human)
	for(var/key, value in form_bonus_stats)
		if(!should_add_buff(human, key, value))
			continue
		human.st_add_stat_mod(key, value, type) //Sabby: this is throwing me for a loop (eheheh). What is the 'type' part here of this procedure? Is that tzimisce_zulo_form?

/datum/species/tzimisce_zulo_form/proc/should_add_buff(mob/living/carbon/human/human, datum/st_stat/buff_type, amount)
	return TRUE

/datum/species/tzimisce_zulo_form/proc/clear_buffs(mob/living/carbon/human/human)
	for(var/key, value in form_bonus_stats)
		human.st_remove_stat_mod(key, type)

/* Sabby: NEED TO STILL REVIEW AND ADAPT THIS BASED ON HOW WEREWOLF CODE WORKS */

/* Sabby: This below comes from werewolf code. And says it's to fetch the mob.dmi from the splat?
Completely lost here.
*/
// /datum/species/human/shifter/proc/get_mob_icon(mob/living/carbon/human/human)
// 	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(human)
// 	var/icon_to_use
// 	if(shifter_splat)
// 		icon_to_use = shifter_splat.mob_icons[id]

// 	return icon_to_use ? icon_to_use : fallback_icon

// /datum/species/human/shifter/update_body_parts(mob/living/carbon/human/human)
// 	if(!custom_body_render)
// 		return FALSE

// 	human.remove_overlay(BODYPARTS_LAYER)

// 	var/fur_color = get_fur_color(human)
// 	var/mob_icon = get_mob_icon(human)

// 	var/main_iconstate = ""
// 	if(HAS_TRAIT(human, TRAIT_WYRMTAINTED_SPRITE))
// 		main_iconstate += "spiral"
// 	main_iconstate += fur_color
// 	if(human.body_position == LYING_DOWN)
// 		main_iconstate += "_rest"

// 	human.overlays_standing[BODYPARTS_LAYER] = list(image(mob_icon, main_iconstate))

// 	human.apply_overlay(BODYPARTS_LAYER)

// 	return TRUE

// /datum/species/human/shifter/update_damage_overlays(mob/living/carbon/human/human)
// 	if(!custom_damage_render)
// 		return FALSE

// 	human.remove_overlay(DAMAGE_LAYER)

// 	var/dam_amount
// 	switch(human.get_brute_loss() + human.get_fire_loss() + human.get_agg_loss())
// 		if(25 to 100)
// 			dam_amount = 1
// 		if(100 to 250)
// 			dam_amount = 2
// 		if(250 to INFINITY)
// 			dam_amount = 3
// 	if(dam_amount)
// 		human.overlays_standing[DAMAGE_LAYER] = mutable_appearance(get_mob_icon(human), "damage[dam_amount][human.body_position == LYING_DOWN ? "_rest" : ""]")

// 	human.apply_overlay(DAMAGE_LAYER)

// 	return TRUE

/mob/living/simple_animal/hostile/abnormality/punishing_bird
	name = "Punishing Bird"
	desc = "A white bird with tiny beak. Looks harmless."
	icon = 'icons/mob/punishing_bird.dmi'
	icon_state = "pbird"
	icon_living = "pbird"
	icon_dead = "pbird_dead"
	turns_per_move = 2
	response_help_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	density = FALSE
	is_flying_animal = TRUE
	maxHealth = 600
	health = 600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	see_in_dark = 10
	move_to_delay = 2
	harm_intent_damage = 10
	melee_damage_lower = 1
	melee_damage_upper = 2
	rapid_melee = 2
	stat_attack = SOFT_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	pass_flags = PASSTABLE
	faction = list("hostile", "Apocalypse")
	attack_sound = 'sound/weapons/pbird_bite.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	is_flying_animal = TRUE
	speak_emote = list("chirps")
	vision_range = 14
	aggro_vision_range = 28
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(40, 40, 40, 45, 45),
						ABNORMALITY_WORK_INSIGHT = 60,
						ABNORMALITY_WORK_ATTACHMENT = list(55, 55, 50, 50, 50),
						ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0)
						)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/beak,
		/datum/ego_datum/weapon/beakmagnum,
		/datum/ego_datum/armor/beak
		)
	gift_type =  /datum/ego_gifts/beak
	var/list/enemies = list()
	var/list/pecking_targets = list()
	var/list/already_punished = list()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED, .proc/OnAbnoWork)
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE, .proc/OnHumanInsane)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/TransformRed()
	visible_message("<span class='danger'>\The [src] turns its insides out as a giant bloody beak appears!</span>")
	icon_state = "pbird_red"
	icon_living = "pbird_red"
	attack_verb_continuous = "eviscerates"
	attack_verb_simple = "eviscerate"
	rapid_melee = 1
	melee_damage_lower = 400
	melee_damage_upper = 500
	obj_damage = 2500
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	stat_attack = DEAD
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/TransformBack()
	visible_message("<span class='notice'>\The [src] turns back into a fuzzy looking bird!</span>")
	icon_state = initial(icon_state)
	icon_living = initial(icon_living)
	attack_verb_continuous = initial(attack_verb_continuous)
	attack_verb_simple = initial(attack_verb_simple)
	rapid_melee = initial(rapid_melee)
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	obj_damage = initial(obj_damage)
	environment_smash = initial(environment_smash)
	stat_attack = initial(stat_attack)
	adjustHealth(-maxHealth) // Full restoration
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/OnAbnoWork(datum/source, datum/abnormality/abno_datum, mob/user, work_type)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(abno_datum == datum_reference) // They worked on us!
		return FALSE
	if(prob(20 - (abno_datum.threat_level * 5))) // So working on WAWs/ALEPHs won't do anything
		datum_reference.qliphoth_change(-1)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/OnHumanInsane(datum/source, mob/living/carbon/human/H, attribute)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE))
		return FALSE
	if(!H.mind) // That wasn't a player at all...
		return FALSE
	if(prob(33))
		datum_reference.qliphoth_change(-1)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/punishing_bird/Life()
	if(..())
		if(obj_damage > 0) // Already transformed
			return
		var/list/around = view(src, vision_range)
		var/list/priority_mobs = list()
		var/list/potential_mobs = list()
		for(var/mob/living/carbon/human/H in around)
			if(H.mind && !faction_check_mob(H))
				if(H.sanity_lost)
					priority_mobs += H
				else if(!(H in already_punished) && prob(10))
					potential_mobs += H

		if(LAZYLEN(priority_mobs))
			var/mob/living/carbon/le_target = pick(priority_mobs)
			pecking_targets |= le_target
		else if(LAZYLEN(potential_mobs))
			var/mob/living/carbon/le_target = pick(potential_mobs)
			pecking_targets |= le_target

/mob/living/simple_animal/hostile/abnormality/punishing_bird/AttackingTarget()
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(obj_damage <= 0) // Not transformed
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.adjustSanityLoss(10) // Heal sanity
					return
			if(prob(5) || L.health < L.maxHealth*0.4)
				if(L in enemies)
					enemies -= L
				if(L in pecking_targets)
					pecking_targets -= L
					already_punished |= L
				target = null
		else if(L.health <= 0)
			visible_message("<span class='danger'>\The [src] devours [L]!</span>")
			L.gib()
			TransformBack()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/Found(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		return L
	else if(ismecha(A))
		var/obj/vehicle/sealed/mecha/M = A
		if(LAZYLEN(M.occupants))
			return A

/mob/living/simple_animal/hostile/abnormality/punishing_bird/ListTargets()
	if(!enemies.len && !pecking_targets.len)
		return list()
	var/list/see = ..()
	var/list/targeting = list()
	targeting += enemies
	if(obj_damage <= 0)
		targeting |= pecking_targets
	see &= targeting // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/Retaliate(atom/movable/A)
	if((health < maxHealth * 0.9) && (obj_damage <= 0))
		enemies = list() // This is done so it stops attacking random people that punched it before transformation
		TransformRed()

	if(isliving(A))
		var/mob/living/M = A
		if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
			enemies |= M
	else if(ismecha(A))
		var/obj/vehicle/sealed/mecha/M = A
		if(LAZYLEN(M.occupants))
			enemies |= M
			enemies |= M.occupants

/mob/living/simple_animal/hostile/abnormality/punishing_bird/attack_hand(mob/living/carbon/human/M)
	..()
	if(M.a_intent == INTENT_HARM)
		Retaliate(M)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/attack_paw(mob/living/carbon/human/M)
	..()
	if(M.a_intent != INTENT_HELP)
		Retaliate(M)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			Retaliate(M)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(Proj.firer)
		Retaliate(Proj.firer)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/attackby(obj/item/I, mob/living/user, params)
	..()
	Retaliate(user)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/breach_effect(mob/living/carbon/human/user)
	..()
	addtimer(CALLBACK(src, .proc/kill_bird), 180 SECONDS)
	return

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/kill_bird()
	if(!(status_flags & GODMODE) && !target && icon_state != "pbird_red")
		QDEL_NULL(src)
	else
		addtimer(CALLBACK(src, .proc/kill_bird), 60 SECONDS)

// Modified patrolling
/mob/living/simple_animal/hostile/abnormality/punishing_bird/patrol_select()
	if(obj_damage > 0) // Already transformed
		return ..()

	var/list/target_turfs = list() // Insane people
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(!H.mind) // Absolutely not a player
			continue
		if(H.stat >= UNCONSCIOUS)
			continue
		if(get_dist(src, H) < 4) // Way too close
			continue
		if(H.sanity_lost) // Hey, they are insane!
			target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, /turf/proc/Distance_cardinal, 0, 200)
		return
	return ..()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/punishing_bird/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/punishing_bird/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	manual_emote("chirps!")
	return

/mob/living/simple_animal/hostile/abnormality/punishing_bird/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return


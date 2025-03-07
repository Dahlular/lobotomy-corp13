/mob/living/simple_animal/hostile/abnormality/nothing_there
	name = "Nothing There"
	desc = "A wicked creature that consists of various human body parts and organs."
	health = 4000
	maxHealth = 4000
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "nothing"
	icon_living = "nothing"
	icon_dead = "nothing_dead"
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	melee_damage_lower = 55
	melee_damage_upper = 65
	speed = 2
	move_to_delay = 3
	ranged = TRUE
	pixel_x = -8
	base_pixel_x = -8
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 40, 45),
						ABNORMALITY_WORK_INSIGHT = 0,
						ABNORMALITY_WORK_ATTACHMENT = 50,
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 16
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/mimicry,
		/datum/ego_datum/armor/mimicry
		)
	gift_type =  /datum/ego_gifts/mimicry
	var/mob/living/disguise = null
	var/saved_appearance
	var/can_act = TRUE
	var/current_stage = 1
	var/next_transform = null

	var/hello_cooldown
	var/hello_cooldown_time = 8 SECONDS
	var/hello_damage = 80
	var/goodbye_cooldown
	var/goodbye_cooldown_time = 20 SECONDS
	var/goodbye_damage = 500

	var/last_heal_time = 0
	var/heal_percent_per_second = 0.0085

	//Speaking Variables, not sure if I want to use the automated speach at the moment.
	var/heard_words = list()
	var/listen_chance = 10 // 20 for testing, 10 for base
	var/utterance = 5 // 10 for testing, 5 for base
	var/worker = null

/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	. = ..()
	saved_appearance = appearance

/mob/living/simple_animal/hostile/abnormality/nothing_there/Destroy()
	TransferVar(1, heard_words)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/PostSpawn()
	var/list/old_heard = RememberVar(1)
	if(islist(old_heard) && LAZYLEN(old_heard))
		heard_words = old_heard
	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/examine(mob/user)
	if(istype(disguise))
		return disguise.examine(user)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Moved()
	if(current_stage == 3)
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if((current_stage == 3) && (goodbye_cooldown <= world.time) && prob(35))
		return Goodbye()
	if((current_stage == 3) && (hello_cooldown <= world.time) && prob(35))
		var/turf/target_turf = get_turf(target)
		for(var/i = 1 to 3)
			target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
		return Hello(target_turf)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/OpenFire()
	if(!can_act)
		return

	if(current_stage == 3)
		if(hello_cooldown <= world.time)
			Hello(target)
		if((goodbye_cooldown <= world.time) && (get_dist(src, target) < 3))
			Goodbye()

	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/ListTargets()
	if(istype(disguise))
		return list()
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(istype(disguise) && (health < maxHealth * 0.95))
		drop_disguise()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Life()
	. = ..()
	var/speak_list = list()
	if(status_flags & GODMODE) // Contained
		if(prob(utterance) && LAZYLEN(heard_words))
			speak_list = pick(heard_words)
			speak_list = heard_words[speak_list]
			say(pick(speak_list))
		return
	if(.)
		if(!isnull(disguise) && LAZYLEN(heard_words[disguise]) && prob(utterance*2))
			speak_list = heard_words[disguise]
			say(pick(speak_list))
		else
			if(LAZYLEN(heard_words) && prob(utterance))
				var/mob/living/carbon/human/speaker = pick(heard_words)
				speak_list = heard_words[speaker]
				var/line = pick(speak_list)
				if((findtext(line, "uwu") || findtext(line, "owo") || findtext(line, "daddy") || findtext(line, "what the dog doin")) && !isnull(speaker) && speaker.stat != DEAD)
					forceMove(get_turf(speaker))
					GiveTarget(speaker)
				say(line)
		if((last_heal_time + 1 SECONDS) < world.time) // One Second between heals guaranteed
			var/heal_amount = ((world.time - last_heal_time)/10)*heal_percent_per_second*maxHealth
			if(health <= maxHealth*0.3)
				heal_amount *= 2
			adjustBruteLoss(-heal_amount)
			last_heal_time = world.time
		if(next_transform && (world.time > next_transform))
			next_stage()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods)
	. = ..()
	if(speaker == worker) // More likely to pick things up from those working on it
		listen_chance *= 2
	if(prob(listen_chance) && istype(speaker, /mob/living/carbon/human))
		if(!(speaker in heard_words)) // No words stored yet
			heard_words[speaker] = list()
		if(!(raw_message in heard_words[speaker]))
			heard_words[speaker] += raw_message
	listen_chance = initial(listen_chance)

/mob/living/simple_animal/hostile/abnormality/nothing_there/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(damagetype == RED_DAMAGE || damage < 5)
		return
	last_heal_time = world.time + 10 SECONDS // Heal delayed when taking damage; Doubled because it was a little too quick.

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/disguise_as(mob/living/M)
	if(!(status_flags & GODMODE)) // Already breaching
		return
	if(!istype(M))
		return
	for(var/turf/open/T in view(4, src))
		new /obj/effect/temp_visual/flesh(T)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/disguise.ogg', 75, 0, 5)
	new /obj/effect/gibspawner/generic(get_turf(M))
	to_chat(M, "<span class='userdanger'>Oh no...</span>")
	disguise = M
	appearance = M.appearance
	M.death()
	M.forceMove(src) // Hide them for examine message to work
	addtimer(CALLBACK(src, .proc/zero_qliphoth), rand(20 SECONDS, 50 SECONDS))

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/drop_disguise()
	if(!istype(disguise))
		return
	next_transform = world.time + rand(30 SECONDS, 40 SECONDS)
	move_to_delay = initial(move_to_delay)
	appearance = saved_appearance
	disguise.forceMove(get_turf(src))
	disguise.gib()
	disguise = null
	fear_level = ALEPH_LEVEL
	FearEffect()

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/next_stage()
	next_transform = null
	switch(current_stage)
		if(1)
			icon_state = "nothing_egg"
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1)
			can_act = FALSE
			next_transform = world.time + rand(10 SECONDS, 25 SECONDS)
		if(2)
			breach_affected = list() // Too spooky
			FearEffect()
			attack_verb_continuous = "strikes"
			attack_verb_simple = "strike"
			attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
			icon = 'ModularTegustation/Teguicons/64x96.dmi'
			icon_state = icon_living
			pixel_x = -16
			base_pixel_x = -16
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)
			can_act = TRUE
			melee_damage_lower = 65
			melee_damage_upper = 75
			move_to_delay = 5
	adjustBruteLoss(-maxHealth)
	current_stage = clamp(current_stage + 1, 1, 3)

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/Hello(target)
	if(hello_cooldown > world.time)
		return
	hello_cooldown = world.time + hello_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
	icon_state = "nothing_ranged"
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 2)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	SLEEP_CHECK_DEATH(5)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if (TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			for(var/mob/living/L in TF)
				if(faction_check_mob(L) || (L in been_hit))
					continue
				been_hit += L
				L.apply_damage(hello_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				if(L.health < 0)
					L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/Goodbye()
	if(goodbye_cooldown > world.time)
		return
	goodbye_cooldown = world.time + goodbye_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
	icon_state = "nothing_blade"
	SLEEP_CHECK_DEATH(8)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(goodbye_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/attempt_work(mob/living/carbon/human/user, work_type)
	if(istype(disguise))
		return FALSE
	worker = user
	return TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/work_chance(mob/living/carbon/human/user, chance)
	var/adjusted_chance = chance
	var/fort = get_attribute_level(user, FORTITUDE_ATTRIBUTE)
	if(fort < 100)
		adjusted_chance -= (100 - fort) * 0.5
	return adjusted_chance

/mob/living/simple_animal/hostile/abnormality/nothing_there/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	worker = null
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80)
		if(!istype(disguise)) // Not work failure
			datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if (GODMODE in user.status_flags)
		return
	disguise_as(user)
	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/breach_effect(mob/living/carbon/human/user)
	if(!(status_flags & GODMODE)) // Already breaching
		return
	..()
	if(!istype(disguise))
		next_transform = world.time + rand(30 SECONDS, 40 SECONDS)
		return
	// Teleport us somewhere where nobody will see us at first
	fear_level = 0 // So it doesn't inflict fear to those around them
	move_to_delay = 1.2 // This will make them move at a speed similar to normal players
	var/list/priority_list = list()
	for(var/turf/T in GLOB.xeno_spawn)
		var/people_in_range = 0
		for(var/mob/living/L in view(9, T))
			if(L.client && L.stat < UNCONSCIOUS)
				people_in_range += 1
				break
		if(people_in_range > 0)
			continue
		priority_list += T
	var/turf/target_turf = pick(GLOB.xeno_spawn)
	if(LAZYLEN(priority_list))
		target_turf = pick(priority_list)
	for(var/turf/open/T in view(3, src))
		new /obj/effect/temp_visual/flesh(T)
	forceMove(target_turf)
	addtimer(CALLBACK(src, .proc/drop_disguise), rand(40 SECONDS, 90 SECONDS))

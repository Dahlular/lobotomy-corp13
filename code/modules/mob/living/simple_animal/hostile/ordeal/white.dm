// White ordeal mobs, other than Claw
// Black Fixer
/mob/living/simple_animal/hostile/ordeal/black_fixer
	name = "Black Fixer"
	desc = "A humanoid creature wrapped in bandages."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "fixer_b"
	icon_living = "fixer_b"
	faction = list("hostile", "Head")
	maxHealth = 3000
	health = 3000
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	ranged = TRUE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.0, PALE_DAMAGE = 0.5)
	move_resist = MOVE_FORCE_OVERPOWERING
	projectiletype = /obj/projectile/black
	attack_sound = 'sound/weapons/ego/hammer.ogg'
	del_on_death = TRUE

	var/busy = FALSE
	var/pulse_cooldown
	var/pulse_cooldown_time = 20 SECONDS
	var/pulse_damage = 40 // Dealt consistently across the entire room 5 times
	var/hammer_cooldown
	var/hammer_cooldown_time = 8 SECONDS
	var/hammer_damage = 200
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/ordeal/black_fixer/Initialize()
	..()
	pulse_cooldown = world.time + (pulse_cooldown_time * 1.5)

/mob/living/simple_animal/hostile/ordeal/black_fixer/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!busy && pulse_cooldown < world.time)
		PulseAttack()

/mob/living/simple_animal/hostile/ordeal/black_fixer/Move()
	if(busy)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/black_fixer/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(amount < -10)
		pulse_cooldown = world.time + (pulse_cooldown_time * 0.5)

/mob/living/simple_animal/hostile/ordeal/black_fixer/AttackingTarget()
	if(busy)
		return
	..()
	if(prob(30) && hammer_cooldown < world.time)
		HammerAttack(target)

/mob/living/simple_animal/hostile/ordeal/black_fixer/OpenFire()
	if(busy)
		return
	if(prob(25) && (get_dist(src, target) < 10) && (hammer_cooldown < world.time))
		HammerAttack(target)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/black_fixer/proc/PulseAttack()
	icon_state = "fixer_b_attack"
	busy = TRUE
	playsound(src, 'sound/effects/ordeals/white/black_ability_start.ogg', 100, FALSE, 10)
	SLEEP_CHECK_DEATH(6)
	playsound(src, 'sound/effects/ordeals/white/black_ability.ogg', 75, FALSE, 15)
	for(var/i = 1 to 5)
		new /obj/effect/temp_visual/black_fixer_ability(get_turf(src))
		for(var/mob/living/L in livinginview(9, src))
			if(faction_check_mob(L))
				continue
			new /obj/effect/temp_visual/revenant(get_turf(L))
			L.apply_damage(pulse_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(5.6) // In total we wait for 2.8 seconds
	playsound(src, 'sound/effects/ordeals/white/black_ability_end.ogg', 100, FALSE, 30)
	for(var/obj/machinery/computer/abnormality/A in urange(24, src))
		if(prob(66) && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-1, -2))
	icon_state = icon_living
	SLEEP_CHECK_DEATH(5)
	pulse_cooldown = world.time + pulse_cooldown_time
	busy = FALSE

/mob/living/simple_animal/hostile/ordeal/black_fixer/proc/HammerAttack(target)
	if(hammer_cooldown > world.time)
		return
	hammer_cooldown = world.time + hammer_cooldown_time
	busy = TRUE
	been_hit = list()
	visible_message("<span class='warning'>[src] raises their hammer high above the ground!</span>")
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, 14, rand(-15,15))
	var/list/turfs_to_hit = getline(src, target_turf)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T) // Prepare yourselves
	SLEEP_CHECK_DEATH(4)
	playsound(get_turf(src), 'sound/effects/ordeals/white/black_swing.ogg', 75, 5)
	SLEEP_CHECK_DEATH(3)
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 100, 20)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		for(var/turf/open/TT in range(1, T))
			new /obj/effect/temp_visual/small_smoke/halfsecond(TT)
			for(var/mob/living/L in TT)
				if(L in been_hit)
					continue
				if(faction_check_mob(L))
					continue
				been_hit += L
				L.apply_damage(hammer_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		sleep(1)
	SLEEP_CHECK_DEATH(4)
	busy = FALSE

/obj/projectile/black
	name = "kunai"
	icon_state = "blackfixer"
	hitsound = 'sound/effects/ordeals/white/black_kunai.ogg'
	damage = 30
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE

// White Fixer
/mob/living/simple_animal/hostile/ordeal/white_fixer
	name = "White Fixer"
	desc = "An angelic creature wearing white and golden armor with a cannon-like weapon."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fixer_w"
	icon_living = "fixer_w"
	icon_dead = "fixer_w_dead"
	faction = list("hostile", "Head")
	maxHealth = 3000
	health = 3000
	move_to_delay = 5
	ranged_ignores_vision = TRUE
	ranged = TRUE
	minimum_distance = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	move_resist = MOVE_FORCE_OVERPOWERING
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	is_flying_animal = TRUE
	del_on_death = TRUE

	var/can_act = TRUE
	/// When this reaches 480 - begins reflecting damage
	var/damage_taken = 0
	var/damage_reflection = FALSE
	var/beam_cooldown
	var/beam_cooldown_time = 8 SECONDS
	/// White damage dealt on direct hit by beam
	var/beam_direct_damage = 250
	/// White damage dealt every 0.5 seconds to those standing in the beam's smoke
	var/beam_overtime_damage = 30
	var/list/been_hit = list()
	var/circle_cooldown
	var/circle_cooldown_time = 30 SECONDS
	var/circle_radius = 24
	var/circle_overtime_damage = 70

/mob/living/simple_animal/hostile/ordeal/white_fixer/Initialize()
	..()
	circle_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/white_fixer/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(can_act && circle_cooldown < world.time)
		CircleBeam()

/mob/living/simple_animal/hostile/ordeal/white_fixer/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_fixer/AttackingTarget()
	return

/mob/living/simple_animal/hostile/ordeal/white_fixer/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/H = the_target
		if(H.sanity_lost)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_fixer/OpenFire()
	if(!can_act)
		return
	if((get_dist(src, target) < 12) && (beam_cooldown < world.time))
		LongBeam(target)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_fixer/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 480 && !damage_reflection)
		StartReflecting()

/mob/living/simple_animal/hostile/ordeal/white_fixer/proc/LongBeam(target)
	if(beam_cooldown > world.time)
		return
	beam_cooldown = world.time + beam_cooldown_time
	can_act = FALSE
	icon_state = "fixer_w_beam"
	visible_message("<span class='warning'>[src] takes their weapon in hands, aiming it at [target]!</span>")
	playsound(src, 'sound/effects/ordeals/white/white_beam_start.ogg', 75, FALSE, 10)
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, 24, rand(-20,20))
	var/list/turfs_to_hit = getline(src, target_turf)
	for(var/turf/T in turfs_to_hit)
		new /obj/effect/temp_visual/cult/sparks(T) // Prepare yourselves
	SLEEP_CHECK_DEATH(13)
	playsound(src, 'sound/effects/ordeals/white/white_beam.ogg', 75, FALSE, 32)
	been_hit = list()
	var/i = 1
	for(var/turf/T in turfs_to_hit)
		addtimer(CALLBACK(src, .proc/LongBeamTurf, T), i*0.3)
		i++
	SLEEP_CHECK_DEATH(5)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/white_fixer/proc/LongBeamTurf(turf/T)
	var/list/affected_turfs = list()
	for(var/turf/TT in range(2, T))
		if(locate(/obj/effect/temp_visual/small_smoke/fixer_w) in TT) // Already affected by smoke
			continue
		affected_turfs += TT
		new /obj/effect/temp_visual/small_smoke/fixer_w(TT) // Lasts for 5 seconds
		for(var/mob/living/L in TT) // Direct hit
			if(L in been_hit)
				continue
			if(faction_check_mob(L))
				continue
			been_hit += L
			L.apply_damage(beam_direct_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)

	for(var/turf/TT in affected_turfs) // Remaining damage effect
		addtimer(CALLBACK(src, .proc/BeamTurfEffect, TT, beam_overtime_damage))

/mob/living/simple_animal/hostile/ordeal/white_fixer/proc/BeamTurfEffect(turf/T, damage = 10)
	for(var/i = 1 to 5)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		sleep(5)

/mob/living/simple_animal/hostile/ordeal/white_fixer/proc/CircleBeam()
	if(circle_cooldown > world.time)
		return
	can_act = FALSE
	icon_state = "fixer_w_pray"
	playsound(src, 'sound/effects/ordeals/white/white_circle.ogg', 100, FALSE, 48)
	SLEEP_CHECK_DEATH(21)
	var/turf/target_c = get_turf(src)
	var/remainder = pick(TRUE, FALSE) // Responsible for different circle pattern
	for(var/i = 1 to circle_radius)
		if(remainder) // Skip one segment so it's not difficult to dodge
			if(i % 2 != 1)
				continue
		else
			if(i % 2 == 1)
				continue
		var/list/turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/T in turf_list)
			new /obj/effect/temp_visual/small_smoke(T)
			addtimer(CALLBACK(src, .proc/BeamTurfEffect, T, circle_overtime_damage))
		SLEEP_CHECK_DEATH(0.5)
	SLEEP_CHECK_DEATH(5)
	icon_state = icon_living
	circle_cooldown = world.time + circle_cooldown_time
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/white_fixer/proc/StartReflecting()
	can_act = FALSE
	damage_reflection = TRUE
	damage_taken = 0
	playsound(src, 'sound/effects/ordeals/white/white_reflect.ogg', 50, TRUE, 7)
	visible_message("<span class='warning>[src] starts praying!</span>")
	icon_state = "fixer_w_pray"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	SLEEP_CHECK_DEATH(10 SECONDS)
	icon_state = icon_living
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	damage_reflection = FALSE
	can_act = TRUE

// All damage reflection stuff is down here
/mob/living/simple_animal/hostile/ordeal/white_fixer/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	for(var/turf/T in orange(1, src))
		new /obj/effect/temp_visual/sanity_heal(T)
	playsound(src, 'sound/effects/ordeals/white/white_reflect.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.apply_damage(damage, attack_type, null, attacker.getarmor(null, attack_type))
	new /obj/effect/temp_visual/revenant(get_turf(attacker))

/mob/living/simple_animal/hostile/ordeal/white_fixer/attack_hand(mob/living/carbon/human/M)
	..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attack_paw(mob/living/carbon/human/M)
	..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/ordeal/white_fixer/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/ordeal/white_fixer/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	ReflectDamage(user, I.damtype, damage)

// Black Fixer
/mob/living/simple_animal/hostile/ordeal/red_fixer
	name = "Red Fixer"
	desc = "A humanoid creature  resembling a robot or a cyborg."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fixer_r"
	icon_living = "fixer_r"
	faction = list("hostile", "Head")
	maxHealth = 3000
	health = 3000
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 35
	melee_damage_upper = 45
	move_to_delay = 2.4
	ranged = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	move_resist = MOVE_FORCE_OVERPOWERING
	attack_sound = 'sound/effects/ordeals/white/red_attack.ogg'
	del_on_death = TRUE

	var/busy = FALSE
	var/multislash_cooldown
	var/multislash_cooldown_time = 5 SECONDS
	var/multislash_damage = 75
	var/multislash_range = 6
	var/beam_cooldown
	var/beam_cooldown_time = 15 SECONDS
	/// Red damage dealt on direct hit by the beam
	var/beam_damage = 300

/mob/living/simple_animal/hostile/ordeal/red_fixer/Initialize()
	. = ..()
	beam_cooldown = world.time + beam_cooldown_time

/mob/living/simple_animal/hostile/ordeal/red_fixer/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!busy && beam_cooldown + 15 SECONDS < world.time && prob(10)) // Didn't use beam in a long time and there's no target
		var/turf/T = pick(GLOB.department_centers)
		LaserBeam(T)

/mob/living/simple_animal/hostile/ordeal/red_fixer/Move()
	if(busy)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/red_fixer/AttackingTarget()
	if(busy)
		return
	..()
	if(prob(80) && multislash_cooldown < world.time)
		MultiSlash(target)
		return
	if(prob(50) && beam_cooldown < world.time)
		LaserBeam(target)
		return

/mob/living/simple_animal/hostile/ordeal/red_fixer/OpenFire()
	if(busy)
		return
	if(prob(50) && (get_dist(src, target) < multislash_range) && (multislash_cooldown < world.time))
		MultiSlash(target)
		return
	if(prob(80) && (beam_cooldown < world.time))
		LaserBeam(target)
		return
	return

/mob/living/simple_animal/hostile/ordeal/red_fixer/proc/MultiSlash(target)
	if(multislash_cooldown > world.time)
		return
	multislash_cooldown = world.time + multislash_cooldown_time
	busy = TRUE
	var/turf/slash_start = get_turf(src)
	var/turf/slash_end = get_ranged_target_turf_direct(slash_start, target, multislash_range)
	var/list/hitline = getline(slash_start, slash_end)
	face_atom(target)
	for(var/turf/T in hitline)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(4)
	forceMove(slash_end)
	for(var/turf/T in hitline)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			to_chat(L, "<span class='userdanger'>[src] slashes you at a high speed!</span>")
			L.apply_damage(multislash_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	var/datum/beam/B1 = slash_start.Beam(slash_end, "volt_ray", time=3)
	B1.visuals.color = COLOR_YELLOW
	playsound(src, attack_sound, 50, FALSE, 4)
	SLEEP_CHECK_DEATH(3)
	forceMove(slash_start)
	for(var/turf/T in hitline)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			to_chat(L, "<span class='userdanger'>[src] slashes you at a high speed!</span>")
			L.apply_damage(multislash_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	var/datum/beam/B2 = slash_start.Beam(slash_end, "volt_ray", time=6)
	B2.visuals.color = COLOR_RED
	playsound(src, attack_sound, 75, FALSE, 8)
	busy = FALSE

/mob/living/simple_animal/hostile/ordeal/red_fixer/proc/LaserBeam(target)
	if(beam_cooldown > world.time)
		return
	busy = TRUE
	var/turf/beam_start = get_step(src, get_dir(src, target))
	var/turf/beam_end = get_ranged_target_turf_direct(beam_start, target, 48, rand(-5,5))
	var/list/hitline = getline(beam_start, beam_end)
	for(var/turf/T in hitline)
		new /obj/effect/temp_visual/cult/sparks(T)
	face_atom(target)
	icon_state = "fixer_r_beam"
	playsound(src, 'sound/effects/ordeals/white/red_beam.ogg', 75, FALSE, 32)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	var/datum/beam/B = beam_start.Beam(beam_end, "blood_beam", time = 10)
	var/matrix/M = matrix()
	M.Scale(3, 1)
	B.visuals.transform = M
	var/list/been_hit = list()
	for(var/turf/T in hitline)
		for(var/mob/living/L in range(1, T))
			if(L in been_hit)
				continue
			if(faction_check_mob(L))
				continue
			to_chat(L, "<span class='userdanger'>A red laser passes right through you!</span>")
			L.apply_damage(beam_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			been_hit |= L
			new /obj/effect/temp_visual/cult/sparks(get_turf(L))
	playsound(src, 'sound/effects/ordeals/white/red_beam_fire.ogg', 100, FALSE, 32)
	SLEEP_CHECK_DEATH(2 SECONDS)
	beam_cooldown = world.time + beam_cooldown_time
	busy = FALSE
	icon_state = icon_living

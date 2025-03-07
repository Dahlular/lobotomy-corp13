/datum/job/agent
	title = "Agent"
	department_head = list("Manager")
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the manager"
	selection_color = "#ccaaaa"
	exp_requirements = 60

	outfit = /datum/outfit/job/agent
	display_order = JOB_DISPLAY_ORDER_WARDEN

	access = list() // LC13:To-Do
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

	var/normal_attribute_level = 20 // Scales with round time

/datum/job/agent/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	// Assign department security
	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_agent_department
	var/ears = null
	var/accessory = null
	switch(department)
		if("Control")
			ears = /obj/item/radio/headset/headset_control
			accessory = /obj/item/clothing/accessory/armband/lobotomy
		if("Command")
			ears = /obj/item/radio/headset/headset_command/agent
			accessory = /obj/item/clothing/accessory/armband/lobotomy/command
		if("Training")
			ears = /obj/item/radio/headset/headset_training
			accessory = /obj/item/clothing/accessory/armband/lobotomy/training
		if("Information")
			ears = /obj/item/radio/headset/headset_information
			accessory = /obj/item/clothing/accessory/armband/lobotomy/info
		if("Safety")
			ears = /obj/item/radio/headset/headset_safety
			accessory = /obj/item/clothing/accessory/armband/lobotomy/safety
		if("Disciplinary")
			ears = /obj/item/radio/headset/headset_discipline
			accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
		if("Welfare")
			ears = /obj/item/radio/headset/headset_welfare
			accessory = /obj/item/clothing/accessory/armband/lobotomy/welfare
		if("Extraction")
			ears = /obj/item/radio/headset/headset_extraction
			accessory = /obj/item/clothing/accessory/armband/lobotomy/extraction
		if("Record")
			ears = /obj/item/radio/headset/headset_records
			accessory = /obj/item/clothing/accessory/armband/lobotomy/records

	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)
	if(H.mind.assigned_role == "Agent")
		if(ears)
			if(H.ears)
				qdel(H.ears)
			H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)
	if(department != "None" && department)
		to_chat(M, "<b>You have been assigned to [department]!</b>")
	else
		to_chat(M, "<b>You have not been assigned to any department.</b>")

	var/set_attribute = normal_attribute_level
	if(world.time >= 75 MINUTES) // Full facility expected
		set_attribute *= 4
	else if(world.time >= 60 MINUTES) // More than one ALEPH
		set_attribute *= 3
	else if(world.time >= 45 MINUTES) // Wowzer, an ALEPH?
		set_attribute *= 2.5
	else if(world.time >= 30 MINUTES) // Expecting WAW
		set_attribute *= 2
	else if(world.time >= 15 MINUTES) // Usual time for HEs
		set_attribute *= 1.5

	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	return ..()


/datum/outfit/job/agent
	name = "Agent"
	jobtype = /datum/job/agent

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

// Captain
/datum/job/agent/captain
	title = "Agent Captain"
	selection_color = "#BB9999"
	total_positions = 2
	spawn_positions = 2
	outfit = /datum/outfit/job/agent/captain
	display_order = JOB_DISPLAY_ORDER_HEAD_OF_SECURITY
	normal_attribute_level = 21 // :)

	access = list(ACCESS_COMMAND) // LC13:To-Do
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

/datum/outfit/job/agent/captain
	name = "Agent Captain"
	jobtype = /datum/job/agent/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/agent_captain/alt

// Trainee, for new players
/datum/job/agent/intern
	title = "Agent Intern"
	selection_color = "#ccaaaa"
	total_positions = -1
	spawn_positions = -1
	outfit = /datum/outfit/job/agent/intern
	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	normal_attribute_level = 20

/datum/outfit/job/agent/intern
	name = "Agent Intern"
	jobtype = /datum/job/agent/intern
	head = null
	backpack_contents = list(/obj/item/melee/classic_baton=1,
		/obj/item/paper/fluff/tutorial/levels=1 ,
		/obj/item/paper/fluff/tutorial/risk=1,
		/obj/item/paper/fluff/tutorial/damage=1,
		/obj/item/paper/fluff/tutorial/tips=1,)


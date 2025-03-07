// ALEPH armor, go wild, but attempt to keep total armor at ~245 total.
// Paradise lost and Twilight are the only exceptions.

/obj/item/clothing/suit/armor/ego_gear/paradise
	name = "paradise lost"
	desc = "\"My loved ones, do not worry; I have heard your prayers. \
	Have you not yet realized that pain is but a speck to a determined mind?\""
	icon_state = "paradise"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 80, BLACK_DAMAGE = 80, PALE_DAMAGE = 80) // 320
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/justitia
	name = "justitia"
	desc = "A black, bandaged coat with golden linings covering it."
	icon_state = "justitia"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 80) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/star
	name = "sound of a star"
	desc = "At the heart of the armor is a shard that emits an arcane gleam. \
	The gentle glow feels somehow more brilliant than a flashing light."
	icon_state = "star"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 70, BLACK_DAMAGE = 60, PALE_DAMAGE = 40) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/da_capo
	name = "da capo"
	desc = "A splendid tailcoat perfect for a symphony. \
	Superb leadership is required to create a perfect ensemble."
	icon_state = "da_capo"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 100, BLACK_DAMAGE = 60, PALE_DAMAGE = 20) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/mimicry
	name = "mimicry"
	desc = "It takes human hide to protect human flesh. To protect humans, you need something made out of humans."
	icon_state = "mimicry"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/twilight
	name = "twilight"
	desc = "The three birds united their efforts to defeat the beast. \
	This could stop countless incidents, but you’ll have to be prepared to step into the Black Forest…"
	icon_state = "twilight"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE_DAMAGE = 90) // 360
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/suit/armor/ego_gear/adoration
	name = "adoration"
	desc = "It is not as unpleasant to wear as it is to look at. \
	In fact, it seems to give you an illusion of comfort and bravery."
	icon_state = "adoration"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 50, BLACK_DAMAGE = 70, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/smile
	name = "smile"
	desc = "It is holding all of the laughter of those who cannot be seen here."
	icon_state = "smile"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 90, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/blooming
	name = "blooming"
	desc = "Just looking at this, you feel quite tacky."
	icon_state = "blooming"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 70, BLACK_DAMAGE = 0, PALE_DAMAGE = 80) // 230
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/flowering
	name = "flowering night"
	desc = "Ah, magicians are actually in greater need of mercy."
	icon_state = "air"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 80, BLACK_DAMAGE = 20, PALE_DAMAGE = 90) // 270
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/suit/armor/ego_gear/praetorian
	name = "praetorian"
	desc = "The queen's last line of defense."
	icon_state = "praetorian"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 40)	//Armor was made before the abnormality.
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/mockery
	name = "mockery"
	desc = "It's smug aura is almost mocking you."
	icon_state = "mockery"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/censored
	name = "CENSORED"
	desc = "Goodness, that’s disgusting."
	icon_state = "censored"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 40, BLACK_DAMAGE = 80, PALE_DAMAGE = 60)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

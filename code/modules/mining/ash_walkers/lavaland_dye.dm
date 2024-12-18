/obj/item/lavaland_dye
	name = "generic dye"
	desc = "Если вы это видите, то зюзя дебил конечно."
	icon = 'icons/obj/lavaland/lava_fishing.dmi'
	icon_state = "cinnabar_spleen"
	var/picked_dye = "Cinnabar Dyes"

/obj/item/lavaland_dye/attack(mob/living/carbon/human/target, mob/living/user, params, def_zone, skip_attack_anim)
	if(!ishuman(target) || user.a_intent != INTENT_HELP || !(target in view(1)))
		return ..()

	. = ATTACK_CHAIN_PROCEED

	target.change_markings(picked_dye, location = "body")

/obj/item/lavaland_dye/cinnabar
	name = "cinnabar-colored spleen"
	desc = "Селезёнка, добытая из тела лавовой рыбы. Содержит в себе частицы киновари и обладает характерным коричневато-красным цветом."
	icon_state = "cinnabar_spleen"
	picked_dye = "Cinnabar Dyes"

/obj/item/lavaland_dye/crimson
	name = "crimson-colored spleen"
	desc = "Селезёнка, добытая из тела лавовой рыбы. Содержит в себе частицы неизвестной жидкости, похожей на кровь, и обладает характерным кроваво-красным цветом."
	icon_state = "crimson_spleen"
	picked_dye = "Crimson Dyes"

/obj/item/lavaland_dye/indigo
	name = "indigo-colored spleen"
	desc = "Селезёнка, добытая из тела лавовой рыбы. Содержит в себе вещество, похожее на чернила, и обладает характерным тёмно-синим цветом."
	icon_state = "indigo_spleen"
	picked_dye = "Indigo Dyes"

/obj/item/lavaland_dye/mint
	name = "mint-colored spleen"
	desc = "Селезёнка, добытая из тела лавовой рыбы. Содержит в себе частицы минералов и обладает характерным мятно-зелёным цветом."
	icon_state = "mint_spleen"
	picked_dye = "Mint Dyes"

/obj/item/lavaland_dye/amber
	name = "amber-colored spleen"
	desc = "Селезёнка, добытая из тела лавовой рыбы. Содержит в себе частицы природного янтаря и обладает характерным янтарно-желтым цветом."
	icon_state = "amber_spleen"
	picked_dye = "Amber Dyes"


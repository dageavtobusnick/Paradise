/obj/item/reagent_containers/food/snacks/lavaland
	icon = 'icons/obj/lavaland/lava_fishing.dmi'

/obj/item/reagent_containers/food/snacks/lavaland/soft_meat
	name = "soft meat cut"
	desc = "Нежная мясная вырезка. Сырая в текущем виде, однако с правильными ингридиентами её можно превратить в прекрасное блюдо."
	icon_state = "soft_meat_cut"
	list_reagents = list("nutriment" = 3, "vitamin" = 4, "protein" = 6)
	bitesize = 2
	filling_color = "#D49284"
	tastes = list("raw meat" = 1)
	foodtype = MEAT | RAW

/obj/item/reagent_containers/food/snacks/lavaland/eel_filet
	name = "eel filet"
	desc = "Сырое филе донного угря. Хоть оно съедобно и в сыром виде, с правильными ингридиентами, ее можно превратить в прекрасное блюдо."
	icon_state = "eel_filet"
	list_reagents = list("nutriment" = 4, "menthol" = 3, "protein" = 8)
	bitesize = 2
	filling_color = "#414F71"
	tastes = list("raw meat" = 1)
	foodtype = MEAT | RAW

/obj/item/reagent_containers/food/snacks/lavaland/predator_meat
	name = "predatory fish slice"
	desc = "Достаточно большой кусок мяса, добытый из хищной рыбы. Не рекомендуется к употреблению в сыром виде."
	icon_state = "predatory_fish_slice"
	list_reagents = list("nutriment" = 4, "toxin" = 2, "protein" = 12)
	bitesize = 3
	filling_color = "#BE7C64"
	tastes = list("toxin meat" = 1)
	foodtype = MEAT | TOXIC | RAW

/obj/item/reagent_containers/food/snacks/lavaland_food
	name = "generic lavaland food"
	desc = "самое обычное блюдо. Если вы это видите, то зюзя напортачил"
	icon = 'icons/obj/lavaland/ashie_food.dmi'
	icon_state = "fine_meal"
	bitesize = 100 //eat whole thing down
	list_reagents = list("nutriment" = 6, "protein" = 6)
	has_special_eating_effects = TRUE
	eat_time = 5 SECONDS

/obj/item/reagent_containers/food/snacks/lavaland_food/on_mob_eating_effect(mob/user)
	to_chat(user, "тест, проверка. ты - [user].")
	return

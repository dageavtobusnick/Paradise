/obj/item/reagent_containers/food/snacks/lavaland
	icon = 'icons/obj/lavaland/lava_fishing.dmi'

/obj/item/reagent_containers/food/snacks/lavaland/soft_meat
	name = "soft meat cut"
	desc = "Нежная мясная вырезка. Сырая в текущем виде, однако с правильными ингридиентами её можно превратить в прекрасное блюдо."
	icon_state = "soft_meat_cut"
	list_reagents = list("nutriment" = 2, "vitamin" = 2, "protein" = 2)
	bitesize = 2
	tastes = list("raw meat" = 1)
	foodtype = MEAT | RAW

/obj/item/organ/external/head/vulpkanin
	species_type = /datum/species/vulpkanin

/obj/item/organ/external/head/vulpkanin/wolpin
	species_type = /datum/species/monkey/vulpkanin

/obj/item/organ/internal/liver/vulpkanin
	species_type = /datum/species/vulpkanin
	name = "vulpkanin liver"
	icon = 'icons/obj/species_organs/vulpkanin.dmi'
	item_state = "vulpkanin_liver"
	alcohol_intensity = 1.4

/obj/item/organ/internal/eyes/vulpkanin
	species_type = /datum/species/vulpkanin
	name = "vulpkanin eyeballs"
	icon = 'icons/obj/species_organs/vulpkanin.dmi'
	item_state = "vulpkanin_eyes"
	colourblind_matrix = MATRIX_VULP_CBLIND //The colour matrix parameter that the mob will recieve when they get the disability.
	replace_colours = PROTANOPIA_COLOR_REPLACE
	see_in_dark = 8

/obj/item/organ/internal/eyes/vulpkanin/wolpin //Being the lesser form of Vulpkanin, Wolpins have an utterly incurable version of their colourblindness.
	species_type = /datum/species/monkey/vulpkanin
	name = "wolpin eyeballs"
	colourmatrix = MATRIX_VULP_CBLIND
	see_in_dark = 8
	replace_colours = PROTANOPIA_COLOR_REPLACE

/obj/item/organ/internal/heart/vulpkanin
	species_type = /datum/species/vulpkanin
	name = "vulpkanin heart"
	icon = 'icons/obj/species_organs/vulpkanin.dmi'
	item_state = "vulpkanin_heart-on"
	item_base = "vulpkanin_heart"

/obj/item/organ/internal/brain/vulpkanin
	species_type = /datum/species/vulpkanin
	icon = 'icons/obj/species_organs/vulpkanin.dmi'
	icon_state = "brain2"
	item_state = "vulpkanin_brain"
	mmi_icon = 'icons/obj/species_organs/vulpkanin.dmi'
	mmi_icon_state = "mmi_full"

/obj/item/organ/internal/lungs/vulpkanin
	species_type = /datum/species/vulpkanin
	name = "vulpkanin lungs"
	icon = 'icons/obj/species_organs/vulpkanin.dmi'
	item_state = "vulpkanin_lungs"

/obj/item/organ/internal/kidneys/vulpkanin
	species_type = /datum/species/vulpkanin
	name = "vulpkanin kidneys"
	icon = 'icons/obj/species_organs/vulpkanin.dmi'
	item_state = "vulpkanin_kidneys"

/obj/item/organ/external/tail/vulpkanin
	species_type = /datum/species/vulpkanin
	name = "vulpkanin tail"
	icon_name = "vulptail_s"
	max_damage = 25
	min_broken_damage = 15

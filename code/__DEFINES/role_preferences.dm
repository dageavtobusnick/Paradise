//Values for antag preferences, event roles, etc. unified here

//Missing assignment means it's not a gamemode specific role, IT'S NOT A BUG OR ERROR.
//The gamemode specific ones are just so the gamemodes can query whether a player is old enough
//(in game days played) to play that role
GLOBAL_LIST_INIT(special_roles, list(
	ROLE_ABDUCTOR = /datum/game_mode/abduction, // Abductor
	ROLE_BLOB = /datum/game_mode/blob, // Blob
	ROLE_CHANGELING = /datum/game_mode/changeling, // Changeling
	ROLE_BORER, // Cortical borer
	ROLE_CULTIST = /datum/game_mode/cult, // Cultist
	ROLE_CLOCKER = /datum/game_mode/clockwork, // Clockwork Cultist
	ROLE_DEMON, // Demons (Slaughter/Laughter/Shadow)
	ROLE_DEVIL, // Devil
	ROLE_GSPIDER, // Giant spider
	ROLE_GUARDIAN, // Guardian
	ROLE_ELITE, // Lavaland Elite
	ROLE_MALF_AI = /datum/game_mode/traitor, // Malf AI
	ROLE_ESCAPING_PRISONER = /datum/game_mode/traitor, // Escaping Prisoner
	ROLE_MORPH, // Morph
	ROLE_OPERATIVE = /datum/game_mode/nuclear, // Operative
	ROLE_PAI, // PAI
	ROLE_POSIBRAIN, // Positronic brain
	ROLE_REVENANT, // Revenant
	ROLE_REV = /datum/game_mode/revolution, // Revolutionary
	ROLE_SENTIENT, // Sentient animal
	ROLE_SHADOWLING = /datum/game_mode/shadowling, // Shadowling
	ROLE_SPACE_DRAGON, // Space dragon
	ROLE_NINJA, // Space ninja
	ROLE_TERROR_SPIDER, // Terror Spider
	ROLE_THIEF = /datum/game_mode/thief, // Thief
	ROLE_THUNDERDOME, // Thunderdome
	ROLE_TRADER, // Trader
	ROLE_TRAITOR = /datum/game_mode/traitor, // Traitor
	ROLE_VAMPIRE = /datum/game_mode/vampire, // Vampire
	ROLE_RAIDER = /datum/game_mode/heist, // Vox raider
	ROLE_WIZARD = /datum/game_mode/wizard, // Wizard
	ROLE_ALIEN, // Xenomorph
))

#define ROLE_PRISONERS_MAX_COUNT 4

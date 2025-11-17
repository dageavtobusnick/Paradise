/datum/ai_behavior/find_and_set/empty_paper
	action_cooldown = 10 SECONDS

/datum/ai_behavior/find_and_set/empty_paper/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/empty_papers = list()

	for(var/obj/item/paper/target_paper in oview(search_range, controller.pawn))
		if(target_paper.is_empty())
			empty_papers += target_paper

	if(empty_papers.len)
		return pick(empty_papers)

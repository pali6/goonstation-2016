/datum/targetable/spell/stickstosnakes
	name = "Sticks to Snakes"
	desc = "Turns an item into a snake."
	icon_state = "snakes"
	targeted = 1
	cooldown = 400 // TODO
	requires_robes = 1
	offensive = 1
	target_anything = 1

	cast(atom/target)
		if(!holder)
			return

		var/atom/movable/stick = null
		if(istype(target, /obj/item))
			stick = target
		else if(istype(target, /mob))
			var/mob/living/carbon/human/M = target
			stick = M.equipped()
			if(!M.drop_item()) // if drop was unsuccessful
				stick = null
		else if(istype(target, /turf))
			var/list/items = list()
			for(var/obj/item/thing in target.contents)
				items.Add(thing)
			if(items.len)
				stick = pick(items)
		else if(istype(target, /obj/critter/domestic_bee))
			stick = target
		else if(istype(target, /obj/critter/snake))
			var/obj/critter/snake/snek = target
			if(snek.double)
				boutput(holder.owner, "<span style=\"color:red\">Your wizarding skills are not up to the legendary Triplesnake technique.</span>")
				return 1
			stick = target

		if(!stick)
			boutput(holder.owner, "<span style=\"color:red\">You must target an item or a person holding one.</span>")
			return 1 // No cooldown when it fails.
		if(!istype(stick.loc, /turf))
			boutput(holder.owner, "<span style=\"color:red\">The item must be lying on the ground.</span>")
			return 1 // No cooldown when it fails.

		holder.owner.say("STYX TUSNEKS")
		//playsound(holder.owner.loc, "sound/voice/wizard/GolemLoud.ogg", 50, 0, -1)
		// someone record the sound please

		var/obj/critter/snake/snake = new(stick.loc, stick)

		if (!holder.owner.wizard_spellpower())
			snake.aggressive = 0

		holder.owner.visible_message("<span style=\"color:red\">[holder.owner] turns [stick] into [snake]!</span>")
		playsound(holder.owner.loc, "sound/effects/mag_golem.ogg", 25, 1, -1)

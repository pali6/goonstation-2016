/obj/item/gun/reagent
	name = "reagent gun"
	icon = 'icons/obj/gun.dmi'
	item_state = "gun"
	m_amt = 2000
	g_amt = 1000
	mats = 16
	add_residue = 0 // Does this gun add gunshot residue when fired? Energy guns shouldn't.
	var/capacity = 100 // reagent capacity of the gun
	var/list/ammo_reagents = null // list of reagents accepted as ammo
	var/projectile_reagents = 0 // whether the reagents should actually get transfered to the projectiles

	New()
		create_reagents(capacity)
		..()
	
	is_open_container()
		return 1

	alter_projectile(var/obj/projectile/P)
		if(src.projectile_reagents)
			if (!P.reagents)
				P.reagents = new /datum/reagents(P.proj_data.cost)
				P.reagents.my_atom = P
			src.reagents.trans_to(P, P.proj_data.cost)
	
	on_reagent_change(add)
		if(!add || !src.ammo_reagents)
			src.update_icon()
			return
		var/found = 0
		for (var/reagent_id in src.reagents.reagent_list)
			if (!src.ammo_reagents.Find(reagent_id))
				src.reagents.del_reagent(reagent_id)
				found = 1
		if (found)
			if (ismob(src.loc))
				var/mob/M = src.loc
				M.show_text("[src] grumps a bit as it removes impurities.", "red")
			else
				src.visible_message("<span style=\"color:red\">[src] grumps a bit as it removes impurities.</span>")
		src.update_icon()

	examine()
		set src in usr
		src.desc = "[src.projectiles ? "It is set to [src.current_projectile.sname]. " : ""]There are [src.reagents.total_volume]/[src.reagents.maximum_volume] units left!"
		if(current_projectile)
			src.desc += " Each shot will currently use [src.current_projectile.cost] units!"
		else
			src.desc += "<span style=\"color:red\">*ERROR* No output selected!</span>"
		..()
		return

	update_icon()
		return 0

	canshoot()
		if(src.reagents && src.current_projectile)
			if(src.reagents.total_volume >= src.current_projectile.cost)
				return 1
		return 0

	process_ammo(var/mob/user)
		if(!src.projectile_reagents)
			src.reagents.remove_any(src.current_projectile.cost)
		return 1

	verb/empty_out()
		set name = "Drain contents"
		set desc = "Dump out all loaded reagents."

		set src in usr

		if (!reagents)
			boutput(usr, "<span style=\"color:red\">The little cap on the fluid container is stuck. Uh oh.</span>")
			return

		if (reagents.total_volume)
			reagents.clear_reagents()
			boutput(usr, "You dump out the [src.name]'s stored reagents.")
		else
			boutput(usr, "<span style=\"color:red\">There's nothing loaded to drain!</span>")

	attackby(obj/item/I as obj, mob/user as mob)
		if (istype(I, /obj/item/reagent_containers/glass))
			return

		return ..()

/obj/item/gun/reagent/ecto
	name = "ectoblaster"
	icon_state = "ecto0"
	ammo_reagents = list("ectoplasm")
	force = 7.0
	desc = "A weapon that launches concentrated ectoplasm. Harmless to humans, deadly to ghosts."

	New()
		current_projectile = new/datum/projectile/ecto
		projectiles = list(current_projectile)
		..()

	update_icon()
		if(src.reagents)
			var/ratio = min(1, src.reagents.total_volume / src.reagents.maximum_volume)
			ratio = round(ratio, 0.25) * 100
			src.icon_state = "ecto[ratio]"
			return

	attackby(obj/item/I as obj, mob/user as mob)
		if (istype(I, /obj/item/reagent_containers/food/snacks/ectoplasm) && !src.reagents.is_full())
			I.reagents.trans_to(src, I.reagents.total_volume)
			user.visible_message("<span style=\"color:red\">[user] smooshes a glob of ectoplasm into [src].</span>")
			qdel(I)
			return

		return ..()

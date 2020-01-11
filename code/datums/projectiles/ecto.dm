/datum/projectile/ecto
	name = "ectobolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ecto"

//How much of a punch this has, tends to be seconds/damage before any resist
	power = 6
//How much ammo this costs
	cost = 20
//How fast the power goes away
	dissipation_rate = 2
//How many tiles till it starts to lose power
	dissipation_delay = 4
//Kill/Stun ratio
	ks_ratio = 0.0
//name of the projectile setting, used when you change a guns setting
	sname = "dewraithize"
//file location for the sound you want it to play
	shot_sound = 'sound/weapons/Taser.ogg'
//How many projectiles should be fired, each will cost the full cost
	shot_number = 1

	damage_type = 0
	//With what % do we hit mobs laying down
	hit_ground_chance = 0
	//Can we pass windows
	window_pass = 0
	brightness = 0.8
	color_red = 0.6
	color_green = 0.9
	color_blue = 0.2

	disruption = 0

	hits_wraiths = 1

	on_hit(atom/hit)
		if(istype(hit, /mob/wraith))
			var/mob/wraith/W = hit
			if(!W.density)
				W.makeCorporeal()
				spawn(20)
					W.makeIncorporeal()
			W.TakeDamage(null, 0, src.power)
		// add some flavourful harmless interaction when hitting humans? what about ghosts?
/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	fire_sound = 'sound/weapons/Taser.ogg'

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 100 //How much energy is needed to fire.
	var/cell_type = "/obj/item/weapon/cell"
	var/projectile_type = "/obj/item/projectile/beam/practice"
	var/modifystate
	var/charge_states = 1 //if the gun changes icon states depending on charge, this is 1. Uses a var so it can be changed easily

/obj/item/weapon/gun/energy/emp_act(severity)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
		..()


/obj/item/weapon/gun/energy/process_chambered()
	if(in_chamber)	return 1
	if(!power_supply)	return 0
	if(!power_supply.use(charge_cost))	return 0
	if(!projectile_type)	return 0
	in_chamber = new projectile_type(src)
	return 1


/obj/item/weapon/gun/energy/update_icon()
	var/ratio
	if(power_supply)
		ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
	else
		ratio = 0
	if(modifystate && charge_states)
		icon_state = "[modifystate][ratio]"
	else if(charge_states)
		icon_state = "[initial(icon_state)][ratio]"

/obj/item/weapon/gun/energy/New()
	. = ..()

	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new(src)

	power_supply.give(power_supply.maxcharge)

/obj/item/weapon/gun/energy/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/cell))
		if(!power_supply)
			if(user)
				user.drop_item(W)
				usr << "<span class='notice'>You put cell into \the [src].</span>"
			W.loc = src
			power_supply = W
			W.update_icon()
			update_icon()
			return 1
		else
			usr << "<span class='notice'>Already cell inside \the [src].</span>"
			return 1

/obj/item/weapon/gun/energy/verb/unload_cell()
	set name = "Unload cell"
	set category = "Object"
	if(power_supply)
		power_supply.loc = get_turf(src.loc)
		if(usr)
			usr.put_in_hands(power_supply)
			usr << "<span class='notice'>You pull the cell out of \the [src]!</span>"
		power_supply.update_icon()
		power_supply = null
		update_icon()
		return 1
	else
		usr << "<span class='warning'>No cell inside \the [src]!</span>"
	return 0
/*
/obj/item/weapon/gun/energy/Destroy()
	if(power_supply)
		power_supply.loc = get_turf(src)
		power_supply = null

	..()
*/
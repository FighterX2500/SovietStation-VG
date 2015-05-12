/obj/item/device/rigspecieschanger
	name = "hardsuit species modification kit"
	desc = "Коробочка с наноботами, запрограммированными дл&#255; трансформации ригов."
	icon_state = "modkit"
	var/species = "Human"

	afterattack(obj/O, mob/user as mob)
		if(istype(O,/obj/item/clothing))
			var/obj/item/clothing/C = O
			if(!C.can_change_species)
				usr << "<span class='warning'>Наноботы с этим не работают.</span>"
				return 0
			else
				usr.visible_message("<span class='notice'>Наноботы начали трансформацию.</span>")
				playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				spawn(50)
					C.change_for_species(species)
					usr.visible_message("<span class='notice'>Трансформаци&#255; завершена.</span>")
	attack_self(mob/user)
		if(!ishuman(user))
			return 0
		species = input("Выберите расу, для которой будет трансформирован риг") in list("Human","Tajaran","Skrell","Unathi")
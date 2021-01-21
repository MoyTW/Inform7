"This Kitchen Is Too Cluttered" by MoyTW

[ Includes ]

Volume 1 - Setup

Chapter 1 - Definitions

Section 1 - Unit Definitions

A volume is a kind of value. 1.0 tsp (in US units, in tsp) or 1 teaspoon (in tsp, singular) or 2 teaspoons (in tsp, plural) specifies a volume.

The max volume is a volume that varies. The max volume is 2147483647 tsp.

1 tbsp (in US units, in tbsp) or 1 tablespoon (in tbsp, singular) or 2 tablespoons (in tbsp, plural) specifies a volume scaled up by 3.

1 fl oz (in US units, in fl oz) or 1 fluid ounce (in fl oz, singular) or 2 fluid ounces (in fl oz, plural) specifies a volume scaled up by 6.

1 cup (in cups, singular) or 1 c (in US units, in cups) or 2 cups (in cups, plural) specifies a volume scaled up by 48.

1 qt (in US units, in quarts) 1 quart (in quarts, singular) or 2 quarts (in quarts, plural) specifies a volume scaled up by 192.

1 gal (in US units, in gallons) or 1 gallon (in gallons, singular) or 2 gallons (in gallons, plural) specifies a volume scaled up by 768.

A temperature is a kind of value. 1 degree farenheit (singular) or 2 degrees farenheit (plural) or 1 F specifies a temperature.

The room temperature is always 70 F.

Section 2 - Ingredients & Ingredient Containers

An ingredient is a kind of value. The ingredients are defined by the Table of Cooking Ingredients.

Table of Cooking Ingredients
ingredient
active dry yeast
all-purpose flour
bread flour
cake flour
raisins
salt
water
white sugar

[ Ingredient container ]

An IngredientContainer is a kind of thing.

An IngredientContainer is either graduated or ungraduated. An IngredientContainer is usually ungraduated.
An IngredientContainer has a volume called capacity. An IngredientContainer has a list of ingredients called ingredients_list. An IngredientContainer has a list of volumes called volumes_list.

Check inserting something into an IngredientContainer (this is the can't put objects an ingredient container rule):
	say "The [second noun] [hold] only ingredients." instead.

[ TODO: Modify descriptions to fit & graduated/ungraduated ]
Rule after printing the name of an IngredientContainer when printing the locale description:
	let n be the number of entries in the ingredients_list of the item described;
	if n > 1:
		say " (containing a mixture of [ingredients_list])";
	else if n is 1:
		say " (containing some [entry 1 of the ingredients_list of the item described])";

Instead of examining an IngredientContainer:
	say "[The noun] ";
	let n be the number of entries in the ingredients_list of the noun;
	if n is 0:
		say "is empty.";
	else if n is 1:
		say "contains [entry 1 of the volumes_list of the noun] [entry 1 of the ingredients_list of the noun].";
	else:
		say "contains a mixture of [ingredients_list of the noun], quantities [volumes_list of the noun] - TODO: reformat.";

[ Filling ]

To fill is a verb.

Understand the command "fill" as something new.

Understand "fill [something] with/from [something]" as filling it with.
Understand "fill [something]" as filling it with.

Filling it with is an action applying to two things.

Carry out an actor filling something with something (this is the convert filling to pouring rule):
	try the actor pouring the second noun into the noun instead.

Rule for supplying a missing second noun while an actor filling (this is the query player for source rule):
	say "You'll need to specify what to fill [the noun] with."

[ Pouring ]

To pour is a verb.

Understand "pour [something] in/into/with [something]" as pouring it into.
Understand "empty [something] in/into/with [something]" as pouring it into.

[ TODO: Discourage the player pouring something into an ingredient source container ]

Pouring it into is an action applying to two things.
The pouring it into action has a list of ingredients called the ingredients_poured.
The pouring it into action has a list of volumes called the amounts_poured.

Setting action variables for pouring something into something (this is the setting ingredients poured rule):
	if the noun is an IngredientContainer:
		now the ingredients_poured is the ingredients_list of the noun.

Setting action variables for pouring something (called the source) into something (called the target) (this is the setting amounts poured rule):
	if the source is an IngredientContainer and the target is an IngredientContainer:
		[ target capacity ]
		let target_remaining_capacity be capacity of target;
		repeat with taken_capacity running through volumes_list of the target:
			decrease target_remaining_capacity by taken_capacity;
		[ source total ]
		let source_total_amount be 0 tsp;
		repeat with v running through volumes_list of the source:
			increase source_total_amount by v;
		[ amount poured ]
		if target_remaining_capacity is greater than the source_total_amount:
			now the amounts_poured is the volumes_list of the noun;
		otherwise:
			let new_volumes be a list of volumes;
			let scalar be target_remaining_capacity / source_total_amount;
			repeat with v running through volumes_list of the source:
				add scalar * v to new_volumes;
			now the amounts_poured is new_volumes;
		say "amounts_poured=[amounts_poured]";

[ TODO: can't pour two untouched things rule ]

[ TODO: can't pour without fluid containers rule ]

[ TODO: no pouring something into itself rule ]

[ TODO: can't pour empties rule ]

Carry out an actor pouring something (called source) into something (called target) (this is the standard carry out pouring rule):
	let s_i be 1;
	repeat with new_ingredient running through ingredients_poured:
		let new_volume be the entry s_i of the amounts_poured;
		if the new_ingredient is listed in the ingredients_list of the target:
			let t_i be 1;
			repeat with N running through the ingredients_list of the target:
				if N is the ingredient understood:
					increase entry t_i of the volumes_list of the target by the new_volume;
					break;
				increment t_i;
		else:
			add the new_ingredient to the ingredients_list of the target;
			add the new_volume to the volumes_list of the target;
		increment s_i;

[ For some reason "x 1.5-qt" tells you you can't see any such thing! ]
test i with "put 1.5-qt on Corian / put 3-qt on Corian / fill 1-tsp with salt / pour 1-tsp into 3-qt / x 3-qt / fill 1-cup with bread flour / pour 1-cup into 3-qt / x 3-qt / pour 3-qt into half-cup / x 3-qt / x half-cup"

Section 3 - Time

When play begins: now the right hand status line is "[time of day]".

[ See http://inform7.com/book/RB_4_1.html for the example this is taken from. ]

Examining something is acting fast. Looking is acting fast.

The take visual actions out of world rule is listed before the every turn stage rule in the turn sequence rules.

This is the take visual actions out of world rule: if acting fast, rule succeeds.

Volume 2 - Content

When play begins:
	say "Special verbs are [italic type]fill[roman type] and [italic type]pour[roman type]."

Book 1 - Object Rules

Section 1 - Stand Mixer

An abstract stand mixer is a kind of container.
An abstract mixer bowl is a kind of container.
An abstract mixer attachment is a kind of thing.

Check inserting something into an abstract stand mixer:
	if the noun is not an abstract mixer bowl and the noun is not an abstract mixer attachment:
		say "You can't put that into the stand mixer!" instead;
	otherwise if the noun is an abstract mixer attachment and the second noun contains an abstract mixer attachment:
		say "There's already an attachment!" instead;

Instead of putting an abstract mixer attachment on an abstract stand mixer:
	try inserting the noun into the second noun.
Instead of tying an abstract mixer attachment to an abstract stand mixer:
	try inserting the noun into the second noun.
Instead of putting an abstract mixer bowl on an abstract stand mixer:
	try inserting the noun into the second noun.
Instead of tying an abstract mixer bowl to an abstract stand mixer:
	try inserting the noun into the second noun.

[ Mixing test - we should be able to combine sugar and raisins. ]
Test mixing with "pour raisins into half-cup / pour half-cup into 4-cup / x 4-cup / pour white sugar into quarter-cup / pour quarter-cup into 4-cup / x 4-cup"

Section 2 - Oven

[ Oven states:
	OFF
	SET TEMP <Bake/Broil> AT <Temperature>
	Temperature of [X] degrees, if temperature < X then PREHEATING
  Oven usage:
	set oven to bake <- requests that you specify a temperature
	set oven to bake at 400 degrees farenheit
	set oven to broil <- requests that you specify a temperature.
	set oven to 400 degrees farenheit <- asks if you you want to bake or broil
	x oven <- to see the current settings and temperature
	set timer to 15 minutes
	stop oven
	turn oven off / turn off oven
]
Oven status is a kind of value. The oven statuses are off, bake, and broil.

An abstract oven is a kind of container. It is openable. It is usually closed.
An abstract oven has a temperature called current temperature. The current temperature of an abstract oven is usually 0 F.
An abstract oven has a temperature called target temperature. The target temperature of an abstract oven is usually 0 F.
An abstract oven has an oven status called target status. The target status of an abstract oven is usually OFF.

Instead of setting an abstract oven to something:
	say "You can set the oven to bake, broil, or off, or you can set it to a target temperature, in degrees farenheit."

Understand "set [abstract oven] to [oven status]" as setting it by oven status. Setting it by oven status is an action applying to one thing and one oven status.

Carry out setting an abstract oven by oven status:
	if the oven status understood is off:
		if the target status of the noun is off:
			say "It's already off.";
		otherwise:
			say "You hit the OFF button on the oven, clearing the [target status of the noun] and resetting the target temperature to 0 F.";
			now the target status of the noun is off;
			now the target temperature of the noun is 0 F;
	otherwise if the oven status understood is bake:
		if the target temperature of the noun is 0 F:
			say "You hit the bake button, but the oven buzzes with complaint. It needs a target temperature first.";
		otherwise if the target status of the noun is off:
			say "You hit the bake button and press start, beginning to heat the oven.";
			now the target status of the noun is bake;
		otherwise if the target status of the noun is bake:
			say "It's already set to bake.";
		otherwise if the target status of the noun is broil:
			say "You switch the oven from broil to bake.";
			now the target status of the noun is bake;
	otherwise if the oven status understood is broil:
		if the target temperature of the noun is 0 F:
			say "You hit the broil button, but the oven buzzes with complaint. It needs a target temperature first.";
		otherwise if the target status of the noun is off:
			say "You hit the broil button and press start, beginning to heat the oven.";
			now the target status of the noun is broil;
		otherwise if the target status of the noun is bake:
			say "You switch the oven from bake to broil.";
			now the target status of the noun is broil;
		otherwise if the target status of the noun is broil:
			say "The oven is already set to broil.";

Understand "set [abstract oven] to [temperature]" as setting it by temperature. Setting it by temperature is an action applying to one thing and one temperature.

Check setting an abstract oven by temperature:
	if the temperature understood is less than 200 F:
		say "The minimum temperature for the oven is 200 F." instead;
	otherwise if the temperature understood is greater than 500 F:
		say "The dial only goess to 500 F." instead;

Carry out setting an abstract oven by temperature:
	now the target temperature of the noun is the temperature understood.

Report setting an abstract oven by temperature:
	say "You set [the noun] to [temperature understood]."

Every turn:
	repeat with instance running through abstract ovens:
		if target status of instance is not OFF:
			if target temperature of instance is greater than current temperature of instance:
				now current temperature of instance is current temperature of the instance + 23 F;
			if current temperature of instance is greater than target temperature of instance:
				now current temperature of instance is target temperature of instance;
			say "Temp of [instance] is [current temperature of the instance]";
		if target status of the instance is OFF:
			if current temperature of instance is greater than room temperature:
				now current temperature of instance is current temperature of the instance - 23 F;
			if current temperature of instance is less than room temperature:
				now current temperature of instance is room temperature;

Test oven with "
set upper oven to asdf/
set upper oven to bake/
set upper oven to broil/
set upper oven to off/
set upper oven to 3/
set upper oven to 3 F/
set upper oven to 9999 F/
set upper oven to 250 degrees farenheit/
set upper oven to bake/
set upper oven to broil/
set upper oven to broil/
set upper oven to bake/
set upper oven to off/
set upper oven to off
"

Book 2 - Rooms

A recipe is carried by the player. The description is "Dead-Easy Bread[line break]
1 1/2 lb (about 6 1/4 cups) all-purpose flour[line break]
1 tsp salt[line break]
2 cups water[line break]
1 tsp sugar[line break]
1 tsp active dry yeast[line break]
Dump the flour and salt into a stand mixer, using the paddle attachment. Beat the sugar and yeast into the water, then dump the water into the mixer under the stir setting. Put it to speed 2 and leave it on for ~8 minutes-ish until it's done - usually I test it by poking it and seeing if it fills in the hole, but honestly it's probably fine. Most recipes will tell you to cover the dough with a cloth and leave it for an hour and a half at a warm-ish temperature, but what I like to do is actually boil some water, put the saucepan in the oven (off of course) and then put the dough in with it. The idea is you want to give it time to rise but don't want it to lose too much moisture. You'll be fine either way, bread's actually pretty hard to mess up.[line break]
Anyways after it rises, prep the baking sheet by putting some parchment paper on it. Take out the dough, flour a board and gently knead it a bit then shape it into an oval. Stick it on the sheet and cover it with a cloth (or put it back in the oven) and leave for another 45-minutes-ish.[line break]
Heat oven to 450 degrees and bake for ~20-25 minutes, then remove and cool.
"

Part 1 - Kitchen

The Kitchen is a room. "Objectively, your kitchen has a fair amount of counter space, but it never feels that way! Most of west wall is taken up by a [bold type]long Corian countertop[roman type] over various [bold type]drawers[roman type], with a [bold type]kitchen sink[roman type] and a [bold type]washing machine[roman type] cutting through the center. The east wall houses a [bold type]gas stovetop[roman type], a [bold type]double wall oven[roman type], a [bold type]small tile countertop[roman type], and the [bold type]fridge[roman type]. Above and below the countertops, crammed wherever there is space, are a profusion of [bold type]cabinets[roman type]. Morning light shines through the glass sliding door to the north, through which you can see the patio. To the south lies the dining room."

Section 1 - West Wall

[ Sink ]

A kitchen sink is in Kitchen. It is fixed in place. It is scenery.

[ Dish washer ]

A dishwashing machine is a supporter in the Kitchen. It is fixed in place and scenery.

Understand "washing machine" as dishwashing machine.

A drying rack is on the dishwashing machine. It is scenery. It is a container.

[ Large counter ]

A large Corian countertop is a supporter in the Kitchen. It is fixed in place. It is scenery.

Understand "large Corian counter" as large Corian countertop.

An abstract stand mixer called the stand mixer is on the large Corian countertop.

An abstract mixer bowl called the mixer bowl is in the stand mixer.

A plastic attachments tub is a container on the large Corian countertop. It is scenery.

An abstract mixer attachment called the paddle attachment is in the plastic attachments tub.

An abstract mixer attachment called dough hook attachment is in the plastic attachments tub.

An abstract mixer attachment called whisk attachment is in the plastic attachments tub.

Section 2 - East wall

[ Stove & fume hood ]

A fume hood is here. It is fixed in place. It is scenery.

A gas stovetop is here. It is fixed in place. It is scenery.

The upper-left burner, the upper-right burner, the lower-left burner, and the lower-right burner are parts of the stovetop.

Understand "stove" as gas stovetop.

[ Tall double wall oven ]

A tall double wall oven is here. It is fixed in place. It is scenery.
The upper oven is an abstract oven. It is part of the double wall oven.
The lower oven is an abstract oven. It is part of the double wall oven.

[ Small tile countertop ]

A small tile countertop is a supporter in the Kitchen. It is fixed in place. It is scenery.

Understand "small tile counter" as small tile countertop.

[ Refrigerator ]

A refrigerator is here. It is fixed in place. It is scenery. It is a container.

Understand "fridge" as refrigerator.

A small active dry yeast bottle is in the refrigerator. It is an IngredientContainer with capacity 4 fl oz and ingredients_list {active dry yeast} and volumes_list {2.4 fl oz}.

Section 3 - Drawers

A drawers is here. It is fixed in place. It is scenery. "You list off the drawers in your head. Dinnerware is in the [bold type]utensil drawer[roman type] on the left of the washing machine, and instruments are in the [bold type]instrument drawer[roman type] to the right of the sink."

[ Utensil drawer ]

A utensil drawer is here. It is fixed in place. It is scenery.

[ Small instrument drawer ]

An instrument cabinet is here. It is fixed in place. It is scenery. It is a container.

A 1/4-tsp measuring spoon is in the instrument cabinet. It is an IngredientContainer with capacity 0.25 tsp.
Understand "quarter-teaspoon measuring spoon" as 1/4-tsp measuring spoon. Understand "quarter-teaspoon" as 1/4-tsp measuring spoon.

A 1/2-tsp measuring spoon is in the instrument cabinet. It is an IngredientContainer with capacity 0.5 tsp.
Understand "half-teaspoon measuring spoon" as 1/2-tsp measuring spoon. Understand "half-teaspoon" as 1/2-tsp measuring spoon.

A 1-tsp measuring spoon is in the instrument cabinet. It is an IngredientContainer with capacity 1 tsp.
Understand "teaspoon measuring spoon" as 1-tsp measuring spoon. Understand "teaspoon" as 1-tsp measuring spoon.

A 1/4-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 2 fl oz.
Understand "quarter-cup dry measuring cup" as 1/4-cup dry measuring cup. Understand "quarter-cup" as 1/4-cup dry measuring cup.

A 1/3-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 16 tsp.
Understand "third-cup dry measuring cup" as 1/3-cup dry measuring cup. Understand "third-cup" as 1/3-cup dry measuring cup.

A 1/2-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 4 fl oz.
Understand "half-cup dry measuring cup" as 1/2-cup dry measuring cup. Understand "half-cup" as 1/2-cup dry measuring cup.

A 1-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 8 fl oz.
Understand "cup dry measuring cup" as 1-cup dry measuring cup. Understand "cup" as 1-cup dry measuring cup.

Section 4 - Cabinets

A cabinets is here. It is fixed in place. It is scenery. "You list off the cabinets in your head. The [bold type]spice rack[roman type] is over to the right of the sink, and the [bold type]mixing bowl cabinet[roman type] (which also has the liquid measuring cups) is the one next to it. The [bold type]pantry[roman type]'s down under the L-countertop near the dining room. Pans and saucepans are in the [bold type]under-stove cabinet[roman type], and pots proper are in the [bold type]pot cabinet[roman type] near the sliding door. Cleaning supplies (hopefully unnecessary) are in the [bold type]under-sink cabinet.[roman type] Good thing you know where everything is, right?"

[ Bowl cabinet ]

A mixing bowl cabinet is here. It is fixed in place. It is scenery. It is a container.

A 1.5-qt mixing bowl is in the bowl cabinet. It is a IngredientContainer with capacity 1.5 quarts.

A 3-qt mixing bowl is in the bowl cabinet. It is a IngredientContainer with capacity 3 quarts.

A 5-qt mixing bowl is in the bowl cabinet. It is a IngredientContainer with capacity 5 quarts.

A 4-cup wet measuring cup is in the bowl cabinet. It is an IngredientContainer with capacity 32 fl oz. It is graduated.

[ Towel cabinet ]

A towel cabinet is here. It is fixed in place. It is scenery.

[ Spice rack ]

A spice rack is here. It is fixed in place. It is scenery.

A 500g cylinder of salt is in the spice rack. It is an IngredientContainer with capacity 30 tbsp and ingredients_list {salt} and volumes_list {19 tbsp}.

[ Pantry ]

A pantry cabinet is here. It is fixed in place. It is scenery.

A all-purpose flour bin is in the pantry cabinet. It is an IngredientContainer with capacity 4 quarts and ingredients_list {all-purpose flour} and volumes_list {3.1 quarts}.

A bread flour bin is in the pantry cabinet. It is an IngredientContainer with capacity 4 quarts and ingredients_list {bread flour} and volumes_list {1.4 cups}.

A cake flour bin is in the pantry cabinet. It is an IngredientContainer with capacity 4 quarts and ingredients_list {cake flour} and volumes_list {2.7 cups}.

A sugar box is in the pantry cabinet. It is an IngredientContainer with capacity 2.5 cups and ingredients_list {white sugar} and volumes_list {1.9 cups}.

A raisins bag is in the pantry cabinet. It is an IngredientContainer with capacity 30 fl oz  and ingredients_list {raisins} and volumes_list {22 fl oz}.

[ Spoon & spatula rack ]

A instrument wall hook rack is a supporter in the Kitchen. It is fixed in place. It is scenery.

[ Saucepan rack ]

A saucepan wall hook rack is here. It is fixed in place. It is scenery.

Part 2 - Dining Room

The Dining Room is a room. It is north of the Kitchen. "Dining room description."
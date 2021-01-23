"This Kitchen Is Too Cluttered" by MoyTW

[ Includes ]

Volume 1 - Setup

Book 1 - Value Definitions

Part 1 - Units

A volume is a kind of value. 1.0 tsp (in US units, in tsp) or 1 teaspoon (in tsp, singular) or 2 teaspoons (in tsp, plural) specifies a volume.

The max volume is a volume that varies. The max volume is 2147483647 tsp.

1 tbsp (in US units, in tbsp) or 1 tablespoon (in tbsp, singular) or 2 tablespoons (in tbsp, plural) specifies a volume scaled up by 3.

1 fl oz (in US units, in fl oz) or 1 fluid ounce (in fl oz, singular) or 2 fluid ounces (in fl oz, plural) specifies a volume scaled up by 6.

1 cup (in cups, singular) or 1 c (in US units, in cups) or 2 cups (in cups, plural) specifies a volume scaled up by 48.

1 qt (in US units, in quarts) 1 quart (in quarts, singular) or 2 quarts (in quarts, plural) specifies a volume scaled up by 192.

1 gal (in US units, in gallons) or 1 gallon (in gallons, singular) or 2 gallons (in gallons, plural) specifies a volume scaled up by 768.

A temperature is a kind of value. 1 degree farenheit (singular) or 2 degrees farenheit (plural) or 1 F specifies a temperature.

The room temperature is always 70 F.

Part 2 - Ingredients

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

Book 2 - Verb Definitions

Part 1 - Fill Verb

To fill is a verb.

Understand the command "fill" as something new.

Understand "fill [something] with/from [something]" as filling it with.
Understand "fill [something]" as filling it with.

Filling it with is an action applying to two things.

Carry out an actor filling something with something (this is the convert filling to pouring rule):
	try the actor pouring the second noun into the noun instead.

Rule for supplying a missing second noun while an actor filling (this is the query player for source rule):
	say "You'll need to specify what to fill [the noun] with."

Part 2 - Pour Verb

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

[ TODO: can't pour two untouched things rule ]

Check an actor pouring something into something (this is the can't pour out of a non-IngredientContainer rule):
	if the noun is not an IngredientContainer:
		say "You can't pour out of that.";
		stop the action.

Check an actor pouring something into something (this is the can't pour into a non-IngredientContainer rule):
	if the second noun is not an IngredientContainer:
		say "That's not an appropriate container for cooking with!";
		stop the action.

Check an actor pouring something into something (this is the can't pour something into itself rule):
	if the noun is the second noun:
		say "No point pouring something into itself.";
		stop the action.

Check an actor pouring something into something (this is the can't pour out of empty containers rule):
	let total_taken_capacity be 0 tsp;
	repeat with taken_capacity running through volumes_list of the noun:
		increase total_taken_capacity by taken_capacity;
	if total_taken_capacity is 0 tsp:
		say "[The noun] [are] empty.";
		stop the action.

Check an actor pouring something into something (this is the can't pour into a full container rule):
	let total_taken_capacity be 0 tsp;
	repeat with taken_capacity running through volumes_list of the second noun:
		increase total_taken_capacity by taken_capacity;
	if total_taken_capacity is the capacity of the second noun:
		say "[The second noun] [are] full!";
		stop the action.

test pouring_checks with "pour salt into stand mixer / pour stand mixer into salt / pour salt into salt / x salt / pour salt into 4-cup / x salt / pour salt into 1-cup / x 1-cup"

[ TODO: Right now we accumulate 0-quantity ingredients for every type of ingredient that passes through a container, which we should either implement "clean" for, or just make it implicit. ]
Carry out an actor pouring something (called source) into something (called target) (this is the standard carry out pouring rule):
	let src_idx be 1;
	repeat with new_ingredient running through ingredients_poured:
		let new_volume be the entry src_idx of the amounts_poured;
		decrease entry src_idx of the volumes_list of the source by the new_volume;
		if the new_ingredient is listed in the ingredients_list of the target:
			let tar_idx be 1;
			repeat with N running through the ingredients_list of the target:
				if N is the new_ingredient:
					increase entry tar_idx of the volumes_list of the target by the new_volume;
					break;
				increment tar_idx;
		else:
			add the new_ingredient to the ingredients_list of the target;
			add the new_volume to the volumes_list of the target;
		increment src_idx;

Report an actor pouring something (called source) into something (called target) (this is the standard report someone pouring rule):
	if the capacity of the source is greater than the capacity of the target:
		say "[The actor] [fill] [the target] from [the source].";
	else:
		say "[The actor] [pour] [the source] into [the target].";

[ For some reason "x 1.5-qt" tells you you can't see any such thing! ]
test i with "put 1.5-qt on Corian / put 3-qt on Corian / fill 1-tsp with salt / pour 1-tsp into 3-qt / x 3-qt / fill 1-cup with bread flour / pour 1-cup into 3-qt / x 3-qt / pour 3-qt into half-cup / x 3-qt / x half-cup / pour half-cup into 4-cup / x half-cup"

Book 3 - Object Definitions

Part 1 - IngredientContainer

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

Part 2 - StandMixer

[ Ok, so...if you just write "zero, stir, two..." it will interpret "two" not to mean the string two but the numerical value two, and then throw an error due to mixed string/number types. Hence setting_number. ]
StandMixerStatus is a kind of value. The StandMixerStatuses are speed 0, stir, speed 2, speed 4, speed 6, speed 8 and speed 10.

A StandMixer is a kind of container.
A StandMixer has a StandMixerStatus called status. The status of a StandMixer is usually speed 0.

A StandMixerBowl is a kind of IngredientContainer. The capacity of a StandMixerBowl is usually 6 quarts.

A MixerAttachment is a kind of thing.

[ Inserting/attaching ]

Check inserting something into a StandMixer:
	if the noun is not an StandMixerBowl and the noun is not an MixerAttachment:
		say "You can't put that into the stand mixer!" instead;
	otherwise if the noun is a MixerAttachment and the second noun contains a MixerAttachment:
		say "There's already an attachment!" instead;

Instead of putting an MixerAttachment on a StandMixer:
	try inserting the noun into the second noun.
Instead of tying an MixerAttachment to a StandMixer:
	try inserting the noun into the second noun.
Instead of putting a StandMixerBowl on a StandMixer:
	try inserting the noun into the second noun.
Instead of tying a StandMixerBowl to a StandMixer:
	try inserting the noun into the second noun.

[ Status ]

Understand "set [StandMixer] to [a number]" as setting it by number. Setting it by number is an action applying to one thing and one number.
Understand "set [StandMixer] to [StandMixerStatus]" as setting it by StandMixerStatus. Setting it by StandMixerStatus is an action applying to one thing and one StandMixerStatus.

Instead of setting a StandMixer to something:
	say "The settings on the stand mixer are 0, stir, 2, 4, 6, 8, and 10.";

Check setting StandMixer by number (this is the only valid number settings rule):
	let valid_mixer_numbers be {0, 2, 4, 6, 8, 10};
	if the number understood is not listed in valid_mixer_numbers:
		say "The settings on the stand mixer are 0, stir, 2, 4, 6, 8, and 10.";
		stop the action.

Carry out setting StandMixer by number:
	if the number understood is:
		-- 0: try setting the noun by StandMixerStatus speed 0;
		-- 2: try setting the noun by StandMixerStatus speed 2;
		-- 4: try setting the noun by StandMixerStatus speed 4;
		-- 6: try setting the noun by StandMixerStatus speed 6;
		-- 8: try setting the noun by StandMixerStatus speed 8;
		-- 10: try setting the noun by StandMixerStatus speed 10;

Check setting a StandMixer by StandMixerStatus (this is the never set to current status rule):
	if the StandMixerStatus understood is the status of the noun:
		say "The stand mixer is already set to [the StandMixerStatus understood].";
		stop the action.

Check setting a StandMixer by StandMixerStatus (this is the stop if no attachment present by status rule):
	if the noun does not contain a MixerAttachment:
		say "[The noun] has no attachment mounted. Turning it on would accomplish nothing.";
		stop the action.

Check setting a StandMixer by StandMixerStatus (this is the do not start stand mixer if no bowl present rule):
	if the noun does not contain a StandMixerBowl:
		say "[The noun] has no bowl mounted. Turning it on now would accomplish nothing.";
		stop the action.

Carry out setting StandMixer by StandMixerStatus:
	now the status of the noun is the StandMixerStatus understood;

Report setting a StandMixer by StandMixerStatus:
	say "You set [the noun] to [the status of the noun]."

Test stand with "set stand mixer to asdf / set stand mixer to 0 / set stand mixer to zero"

Part 3 - Oven

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
				say "[The instance] plays a jaunty tune, indicating that it's finished preheating.";
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

[ Mixing test - we should be able to combine sugar and raisins. ]
Test mixing with "pour raisins into half-cup / pour half-cup into 4-cup / x 4-cup / pour white sugar into quarter-cup / pour quarter-cup into 4-cup / x 4-cup"

Book 3 - Time

When play begins: now the right hand status line is "[time of day]".

[ See http://inform7.com/book/RB_4_1.html for the example this is taken from. ]

Examining something is acting fast. Looking is acting fast.

The take visual actions out of world rule is listed before the every turn stage rule in the turn sequence rules.

This is the take visual actions out of world rule: if acting fast, rule succeeds.

Volume 2 - Content

When play begins:
	say "Special verbs are [italic type]fill[roman type] and [italic type]pour[roman type]."

Book 1 - Rooms

A recipe is carried by the player. The description is "Dead-Easy Bread[line break]
1 1/2 lb (about 5 1/4 cups) all-purpose flour[line break]
1 tsp salt[line break]
2 cups water[line break]
1 tsp sugar[line break]
1 tsp active dry yeast[line break]
Dump the flour and salt into the mixer bowl. In another bowl, beat the sugar and yeast into the water. Pour the liquids into the flour and stir until it comes together into a dough. Using the dough hook for the mixer, put it to speed 2 and leave it on for ~8 minutes-ish until it's done - you can test it by poking it and seeing if it fills in the hole, but honestly it's probably fine. Most recipes will tell you to cover the dough with a cloth and leave it for an hour and a half at a warm-ish temperature, but what I like to do is actually boil some water, put the saucepan in the oven (off of course) and then put the dough in with it. The idea is you want to give it time to rise but don't want it to lose too much moisture. You'll be fine either way, bread's actually pretty hard to mess up.[line break]
Anyways after it rises, prep the baking sheet by putting some parchment paper on it. Take out the dough, flour a board and gently knead it a bit then shape it into an oval. Stick it on the sheet and cover it with a cloth (or put it back in the oven) and leave for another 45-minutes-ish.[line break]
Heat oven to 450 degrees and bake for ~20-25 minutes, then remove and cool.
"

test happy with "
put 3-qt on corian /
pour all-purpose into 4-cup /
pour 4-cup into 3-qt /
fill 1-cup with all-purpose /
pour 1-cup into 3-qt /
fill quarter-cup with all-purpose /
pour quarter-cup into 3-qt /
fill 1-tsp with salt /
pour 1-tsp into 3-qt /
fill 1-cup from sink /
pour 1-cup into 4-cup /
fill 1-cup from sink /
pour 1-cup into 4-cup /
fill 1-tsp with active dry yeast /
pour 1-tsp into 4-cup /
fill 1-tsp with sugar /
pour 1-tsp into 4-cup /
x 4-cup /
x 3-qt /
beat 4-cup /
pour 3-qt into mixer bowl /
pour 4-cup into mixer bowl /
stir mixer bowl /
x mixer bowl /
attach paddle to stand mixer /
set stand mixer to 2 /
z /
z /
z /
x mixer bowl /
z /
z /
z /
x mixer bowl /
z /
z /
set mixer to off /
x mixer bowl
"

Part 1 - Kitchen

The Kitchen is a room. "Objectively, your kitchen has a fair amount of counter space, but it never feels that way! Most of west wall is taken up by a [bold type]long Corian countertop[roman type] over various [bold type]drawers[roman type], with a [bold type]kitchen sink[roman type] and a [bold type]washing machine[roman type] cutting through the center. The east wall houses a [bold type]gas stovetop[roman type], a [bold type]double wall oven[roman type], a [bold type]small tile countertop[roman type], and the [bold type]fridge[roman type]. Above and below the countertops, crammed wherever there is space, are a profusion of [bold type]cabinets[roman type]. Morning light shines through the glass sliding door to the north, through which you can see the patio. To the south lies the dining room."

Chapter 1 - West Wall

[ Sink ]

A kitchen sink is in Kitchen. It is fixed in place. It is scenery. It is an IngredientContainer with capacity 8 gallons and ingredients_list {water} and volumes_list {8 gallons}.

[ Dish washer ]

A dishwashing machine is a supporter in the Kitchen. It is fixed in place and scenery.

Understand "washing machine" as dishwashing machine.

A drying rack is on the dishwashing machine. It is scenery. It is a container.

[ Large counter ]

A large Corian countertop is a supporter in the Kitchen. It is fixed in place. It is scenery.

Understand "large Corian counter" as large Corian countertop.

A StandMixer called the stand mixer is on the large Corian countertop.

A StandMixerBowl called the mixer bowl is in the stand mixer.

A plastic attachments tub is a container on the large Corian countertop.

An MixerAttachment called the paddle attachment is in the plastic attachments tub.

An MixerAttachment called dough hook attachment is in the plastic attachments tub.

An MixerAttachment called whisk attachment is in the plastic attachments tub.

Chapter 2 - East wall

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

Chapter 3 - Drawers

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

Chapter 4 - Cabinets

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

A white sugar box is in the pantry cabinet. It is an IngredientContainer with capacity 2.5 cups and ingredients_list {white sugar} and volumes_list {1.9 cups}.

A raisins bag is in the pantry cabinet. It is an IngredientContainer with capacity 30 fl oz  and ingredients_list {raisins} and volumes_list {22 fl oz}.

[ Spoon & spatula rack ]

A instrument wall hook rack is a supporter in the Kitchen. It is fixed in place. It is scenery.

[ Saucepan rack ]

A saucepan wall hook rack is here. It is fixed in place. It is scenery.

Part 2 - Dining Room

The Dining Room is a room. It is north of the Kitchen. "Dining room description."
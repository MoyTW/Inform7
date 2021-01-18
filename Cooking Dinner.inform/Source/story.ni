"This Kitchen Is Too Cluttered" by MoyTW

[ Includes ]

Include Measured Liquid by Emily Short.

Section 1 - Definition (in place of Section 1I - Definition (for use without Metric Units by Graham Nelson) in Measured Liquid by Emily Short)

A volume is a kind of value. 1.0 tsp (in US units, in tsp) or 1 teaspoon (in tsp, singular) or 2 teaspoons (in tsp, plural) specifies a volume.

A fluid container has a volume called a fluid capacity. A fluid container has a volume called fluid content. The fluid capacity of a fluid container is usually 50 tsp. The fluid content of a fluid container is usually 0 tsp.

The sip size is a volume that varies. The sip size is usually 1 tsp.

The max volume is a volume that varies. The max volume is 2147483647 tsp.

Volume 1 - Setup

Section 1 - Definitions

1 tbsp (in US units, in tbsp) or 1 tablespoon (in tbsp, singular) or 2 tablespoons (in tbsp, plural) specifies a volume scaled up by 3.

1 fl oz (in US units, in fl oz) or 1 fluid ounce (in fl oz, singular) or 2 fluid ounces (in fl oz, plural) specifies a volume scaled up by 6.

1 cup (in cups, singular) or 1 c (in US units, in cups) or 2 cups (in cups, plural) specifies a volume scaled up by 48.

1 qt (in US units, in quarts) 1 quart (in quarts, singular) or 2 quarts (in quarts, plural) specifies a volume scaled up by 192.

1 gal (in US units, in gallons) or 1 gallon (in gallons, singular) or 2 gallons (in gallons, plural) specifies a volume scaled up by 768.

Table of Liquids (continued)
liquid	potable	flavor	description (text)
all-purpose flour	false	--	--
bread flour	false	--	--
cake flour	false	--	--
active dry yeast	false	--	--
white sugar	false	--	--

A temperature is a kind of value. 1 degree farenheit (singular) or 2 degrees farenheit (plural) or 1 F specifies a temperature.

The room temperature is always 70 F.

Section 2 - Time

When play begins: now the right hand status line is "[time of day]".

[ See http://inform7.com/book/RB_4_1.html for the example this is taken from. ]

Examining something is acting fast. Looking is acting fast.

The take visual actions out of world rule is listed before the every turn stage rule in the turn sequence rules.

This is the take visual actions out of world rule: if acting fast, rule succeeds.

Volume 2 - Content

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

The Kitchen is a room. "Objectively, your kitchen has a fair amount of counter space, but it never feels that way. The west and east walls are lined with appliances or countertops, with as many cabinets as can be crammed above of below them. Midday light shines through the glass sliding door to the north, through which you can see the patio. To the south lies the dining room."

[ Sink ]

A kitchen sink is here. It is fixed in place. It is a liquid stream. The liquid of the kitchen sink is water. [ Hunt down the code for "preferred for drinking" and make the sink "preferred for filling" so you don't have to specify sink every time. ]

[ Dish washer ]

A dishwashing machine is a supporter in the Kitchen. It is fixed in place.

Understand "washing machine" as dishwashing machine.

A drying rack is on the dishwashing machine. It is a container.

[ Large counter ]

A large L-shaped countertop is a supporter in the Kitchen. It is fixed in place.

Understand "large L-shaped counter" as large L-shaped countertop.

An abstract stand mixer called new stand mixer is on the large L-shaped countertop.

An abstract mixer bowl called mixer bowl is in the new stand mixer.

An plastic attachments tub is a container on the large L-shaped countertop.

An abstract mixer attachment called the paddle attachment is in the plastic attachments tub.

An abstract mixer attachment called dough hook attachment is in the plastic attachments tub.

An abstract mixer attachment called whisk attachment is in the plastic attachments tub.

A knife block is a container on the large L-shaped countertop. It is fixed in place.

[ Small counter ]

A small west countertop is a supporter in the Kitchen. It is fixed in place.

Understand "small west counter" as small west countertop.

[ Medium counter ]

An medium east countertop is a supporter in the Kitchen. It is fixed in place.

Understand "medium east counter" as medium east countertop.

[ Fridge ]

A refrigerator is here. It is fixed in place. It is a container.

Understand "fridge" as refrigerator.

A small bottle is in the refrigerator. It is a fluid container with fluid capacity 4 fl oz and fluid content 2.4 fl oz and liquid active dry yeast.

[ Stove & fume hood ]

A fume hood is here. It is fixed in place.

A gas stovetop is here. It is fixed in place.

The upper-left burner, the upper-right burner, the lower-left burner, and the lower-right burner are parts of the stovetop.

Understand "stove" as gas stovetop.

[ Oven ]

A double wall oven is here. It is fixed in place. 
The upper oven is an abstract oven. It is part of the double wall oven.
The lower oven is an abstract oven. It is part of the double wall oven.

[ Spoon & spatula rack ]

A instrument wall hook rack is a supporter in the Kitchen. It is fixed in place.

[ Saucepan rack ]

A saucepan wall hook rack is here. It is fixed in place.

[ Utensil drawer ]

A utensil drawer is here. It is fixed in place.

[ Instrument cabinet ]

An instrument cabinet is here. It is fixed in place. It is a container.

A 1/4-tsp measuring spoon is in the instrument cabinet. It is a fluid container with fluid capacity 0.25 tsp.

A 1/2-tsp measuring spoon is in the instrument cabinet. It is a fluid container with fluid capacity 0.5 tsp.

A 1-tsp measuring spoon is in the instrument cabinet. It is a fluid container with fluid capacity 1 tsp.

A 1/4-cup dry measuring cup is in the instrument cabinet. It is a fluid container with fluid capacity 2 fl oz.

A 1/3-cup dry measuring cup is in the instrument cabinet. It is a fluid container with fluid capacity 16 tsp.

A 1/2-cup dry measuring cup is in the instrument cabinet. It is a fluid container with fluid capacity 4 fl oz.

A 1-cup dry measuring cup is in the instrument cabinet. It is a fluid container with fluid capacity 8 fl oz.

A 4-cup wet measuring cup is in the instrument cabinet. It is a fluid container with fluid capacity 32 fl oz. It is graduated.

[ Towel cabinet ]

A towel cabinet is here. It is fixed in place.

[ Spice rack ]

A spice rack is here. It is fixed in place.

[ Pantry ]

A pantry cabinet is here. It is fixed in place.

A top bin is in the pantry cabinet. It is a fluid container with fluid capacity 4 quarts and fluid content 3.1 quarts and liquid all-purpose flour.

A middle bin is in the pantry cabinet. It is a fluid container with fluid capacity 4 quarts and fluid content 1.4 cups and liquid bread flour.

A bottom bin is in the pantry cabinet. It is a fluid container with fluid capacity 4 quarts and fluid content 2.7 cups and liquid cake flour.

A cardboard box is in the pantry cabinet. It is a fluid container with fluid capacity 2.5 cups and fluid content 1.9 cups and liquid white sugar.

The Dining Room is a room. It is north of the Kitchen. "Dining room description."
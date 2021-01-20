"Recipe" by PB

The Kitchen is a room.

Section - Preamble

[we will model the ingredients as number properties of their dispensers, which become depleted as ingredients are added to mixtures.
Mixtures are implemented as list properties of their containers (which don't contain any objects- their contents are represented by the mixture list and the corresponding amounts list, which are updated as ingredients are added)]

Section - Ingredients and Units

An ingredient is a kind of value. The ingredients are flour, sugar, yeast, water, cocoa, milk, raisins and butter.
A unit is a kind of value. The units are fluid ounce, ounce, teaspoonful and tablespoonful.

Table of Stores
dispenser	ingredient	amount left	unit
a milk jug	milk	5	fluid ounce
a packet of yeast	yeast	3	teaspoonful
a bag of flour	flour	9	ounce
a tin of cocoa	cocoa	4	tablespoonful
a packet of raisins	raisins	8	ounce
a butter dish	butter	8	ounce
a packet of sugar	sugar	20	ounce
a water tap	water	10000	fluid ounce


Section - Mixing Bowls

A mixing-bowl is kind of open unopenable container. A mixing-bowl has a list of ingredients called mixture. A mixing-bowl has a list of numbers called amounts.
Understand "mixture" as a mixing-bowl.

The mixing bowl is a mixing-bowl.  It is on the counter. The counter is in the Kitchen.
The pan is a mixing-bowl. It is in the cupboard. The cupboard is a closed, fixed in place, openable container. It is in the Kitchen.

A thing called box is a kind of container. Box is on the counter.

Rule before printing the name of a mixing-bowl:
	omit contents in listing; [otherwise we'll be told it's empty, even when it's got a mixture in it]
Rule after printing the name of a mixing-bowl when printing the locale description:
	let n be the number of entries in the mixture of the item described;
	if n > 1:
		say " (containing a mixture of [mixture])";
	else if n is 1:
		say " (containing some [entry 1 of the mixture of the item described])";
		
test mix with "add some sugar to mixing bowl / add some sugar to mixing bowl / add some flour to mixing bowl / add some butter to mixing bowl / add some flour to mixing bowl / add some sugar to mixing bowl /
add some water to mixing bowl / x mixing"

[intercept examining, so we can give our own version of what's in it]
Instead of examining a mixing-bowl:
	say "[The noun] ";
	let n be the number of entries in the mixture of the item described;
	if n is 0:
		say "is empty.";
	if n > 1:
		say "contains a mixture of [mixture], quantities [amounts].";
	else if n is 1:
		say "contains some [entry 1 of the mixture of the noun].";

[We need some way of reversing errors. It's assumed that ingredients once added can't be individually removed]
Emptying it is an action applying to one thing.		
Understand "Empty [mixing-bowl]" as emptying it.
Understand "Tip away/out [mixing-bowl]" as emptying it.

Check emptying:
	if the number of entries in the mixture of the noun is 0:
		say "[The noun] is already empty!";
		stop the action;
		
Carry out emptying:
	now the mixture of the noun is {};
	now the amounts of the noun is {};

To tip is a verb.	
Report emptying:
	say "[We] [tip] the contents of [the noun] down the sink.";
	
Section - Dispensers
		
A dispenser is a kind of thing. Every dispenser is on the counter. [we've already got everything out and ready to go!]
Some dispensers are defined by the Table of Stores.  The tap is fixed in place.
Instead of examining a dispenser which is not the tap:
	if amount left is 0:
		say "[The noun] is empty.";
	else:
		say "[The noun] contains about [amount left] [unit][if amount left of the noun is not 1]s[end if] of [ingredient].";
		
Section - Making Our Recipe- Adding Ingredients

[we define adding ingredients to mxing bowls as the main action, but also intercept attempts to 'put' the ingredients (interpreted by Inform as their dispensers, as the ingredients have no existence as objects in this implementation).] 

Adding it to is an action applying to one ingredient and one thing.
Understand "Add some/-- more/-- [ingredient] to [something]" as adding it to.
Understand "Put some/more [ingredient] in [something]" as adding it to.
Understand "Put some more [ingredient] in [something]" as adding it to.

[Allow the player to omit the mixing bowl, and just say e.g. 'Add butter']
Does the player mean adding an ingredient to a mixing-bowl: it is very likely.

The adding it to action has a number called the amount.
The adding it to action has a unit called the suitable-units.
The adding it to action has an object called the source.

[intercept things like 'put milk in the bowl'. 'put milk' is not permitted]
Instead of inserting a dispenser into a mixing-bowl:
	let ingredient_intended be the ingredient corresponding to a dispenser of the noun in the Table Of Stores;
	try adding ingredient_intended to the second noun;


Check adding:
	[stop the player messing up the kitchen]
	unless the second noun is a mixing-bowl:
		say "[We] [won't] achieve anything palatable by putting [the ingredient understood] [if the second noun is a container]in[else]on[end if] [the second noun]!";
		stop the action;
	[check how much we want to add and if there's enough available]
	now the source is the dispenser corresponding to an ingredient of the ingredient understood in the Table Of Stores;
	now the suitable-units is the unit corresponding to an ingredient of the ingredient understood in the Table Of Stores;
	[the parser only allows two variables (we've chosen the ingredient and the mixing bowl) in the typed command, so we now need to go back to the player for the amount]
	say "How many [suitable-units]s? >";
	now the amount is 1; [invoke I6 routine to read in a number]
	unless amount is at most the amount left of source:
		say "[There's] not enough left in the [source] to add [amount] [suitable-units][if amount > 1]s[end if].";
		stop the action;

		
Carry out adding:
	now the amount left of the source is the amount left of the source - amount;
	[if we're adding more of an existing ingredient, find the relevant entry in the mixture and add the amount to the amounts]
	if the ingredient understood is listed in the mixture of the second noun:
		let count be 1;
		repeat with N running through the mixture of the second noun:
			if N is the ingredient understood:
				now entry count of the amounts of the second noun is entry count of the amounts of the second noun + amount;
				break;
		increment count;
	else:
		add the ingredient understood to the mixture of the second noun;
		add the amount to the amounts of the second noun;
	

Report adding:
	let n be the number of entries in the mixture of the second noun;
	say "[We] add [amount] [suitable-units][if amount is not 1]s[end if] of [the ingredient understood] to [if n > 1]the mixture in [end if][the second noun].";


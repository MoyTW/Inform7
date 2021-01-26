"Scratch" by MoyTW

Section Definitions

A volume is a kind of value. 1.0 tsp (in US units, in tsp) or 1 teaspoon (in tsp, singular) or 2 teaspoons (in tsp, plural) specifies a volume.

An Ingredient is a kind of thing.
An Ingredient has a volume called current_volume.

A CompoundIngredient is a kind of Ingredient.
A CompoundIngredient has a list of Ingredients called the ingredients_list.
A CompoundIngredient has a list of volumes called the volumes_list.

An IngredientMixture is a kind of thing.
An IngredientMixture has a list of Ingredients called the ingredients_list.
An IngredientMixture has a list of volumes called the volumes_list.

BaseFlour is a kind of Ingredient. Flour is a kind of BaseFlour. There are 10 flours.
BaseSalt is a kind of Ingredient. Salt is a BaseSalt.
BaseWater is a kind of Ingredient. Water is a BaseWater.
BaseSugar is a kind of Ingredient. Sugar is a BaseSugar.
BaseActiveDryYeast is a kind of Ingredient. Active Dry Yeast is a BaseActiveDryYeast.

BreadDough is a kind of CompoundIngredient. A bread dough is a BreadDough. 5 bread doughs are nowhere.
RisenDough is a kind of CompoundIngredient. A risen dough is a RisenDough. 5 risen doughs are nowhere.
UnrisenDough is a kind of CompoundIngredient. An unrisen dough is an UnrisenDough. 5 unrisen doughs are nowhere.
DryIngredients are a kind of CompoundIngredient. A dry ingredients is a DryIngredients.
WetIngredients are a kind of CompoundIngredient. A wet ingredients is a WetIngredients. 5 wet ingredients are nowhere.

LoafOfBread is a kind of thing. A loaf of bread is a LoafOfBread. 5 loafs of bread are nowhere.

A transformation is a kind of value. The transformations are defined by the Table of Transformations.

Table of Transformations
name	duration_min	duration_max	temperature
BAKE_450F_20-25	20	25	450
RISE_90	80	100	--
KNEAD_8	6	10	--
BEAT	--	--	--

A recipe is a kind of value. The recipes are defined by the Table of Recipes.

Table of Recipes
name	product	ingredients	ratios	transformations
r_lob	loaf of bread	{ bread dough }	{ 1 }	{ BAKE_450F_20-25 }
r_rd	risen dough	{ unrisen dough }	{ 1 }	{ RISE_90 }
r_urd	unrisen dough	{ dry ingredients, wet ingredients }	{ 1, 1 }	--
[ Ok, so, apparently, this is a constant list, meaning you can't store types in it? ]
r_di	dry ingredients	{ flour, salt }	{ 252, 1 }	--
r_wi	wet ingredients	{ water, sugar, active dry yeast }	{ 96, 1, 1 }	{ BEAT }

Section Verbs

To combine is a verb.

Understand "combine [container]" as combining it. Combining it is an action applying to one thing.

Carry out combining it:
	let candidates be the list of things held by the noun;
	if there is a product corresponding to an ingredients of candidates in the Table of Recipes:
		choose the row with the ingredients of candidates in the Table of Recipes;
		if the transformations entry is empty:
			say "Combined to create [product entry].";
			now product entry is in the big bowl;
		else:
			say "Needs a transformation.";
	else:
		say "No such combination found.";

Section Kitchen

The kitchen is a room.

The Corian countertop is in the kitchen. The countertop is a supporter. It is fixed in place.

The big bowl is on the Corian countertop. It is a container.
The small bowl is on the Corian countertop. It is a container.
On the Corian countertop is some flour.
Some salt is on the Corian countertop.
Some water is on the Corian countertop.
Some active dry yeast is on the Corian countertop.

test game with "put one flour in big bowl / put one salt in big bowl / combine big bowl / x big bowl / put one flour in small bowl / put one salt in small bowl / combine small bowl / x small bowl"
"Scratch" by MoyTW

The Kitchen is a room.

Section 1 - Stand Mixer

[ Ok, so...if you just write "zero, stir, two..." it will interpret "two" not to mean the string two but the numerical value two, and then throw an error due to mixed string/number types. Hence speed <number>. ]
[ I would put "off" in here but I also have an oven with off/bake/broil, and apparently you can only define one "off" in the whole file (!?) - so it's speed 0 here. ]
StandMixerStatus is a kind of value. The StandMixerStatuses are speed 0, stir, speed 2, speed 4, speed 6, speed 8 and speed 10.

A StandMixer is a kind of thing.
A StandMixer has a StandMixerStatus called status. The status of a StandMixer is usually speed 0.

Instead of examining a StandMixer:
	say "[The noun] is currently set at [the status of the noun]";

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
		[ -- 0: try setting the stand mixer to speed 0; ] [ This is what I *want* to do ]
		-- 0: try putting the noun on the table; [ Try clearly works in this case ]
		-- 2: now the status of the noun is speed 2;
		-- 4: now the status of the noun is speed 4;
		-- 6: now the status of the noun is speed 6;
		-- 8: now the status of the noun is speed 8;
		-- 10: now the status of the noun is speed 10;

Carry out setting StandMixer by StandMixerStatus:
	now the status of the noun is the StandMixerStatus understood;

Test stand with "set stand mixer to asdf / x stand mixer / set stand mixer to 4 / x stand mixer / set stand mixer to 0 / x stand mixer / set stand mixer to speed 0 / x stand mixer / set stand mixer to speed 8 / x stand mixer"

Section 2 - Room

A countertop is a supporter in the kitchen. It is fixed in place.

The StandMixer called the stand mixer is on the countertop.

A table is a supporter in the kitchen. It is fixed in place.
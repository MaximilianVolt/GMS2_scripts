///@ CIRCULAR BAR v2.2.7 - IMPROVED PERFORMANCE AND CUSTOMIZATION UPDATE

/*
	--------------------
	draw_circular_bar();
	--------------------

	Author:         [Maximilian Volt.][IT] --> https://github.com/MaximilianVolted (whole script)
	Also thanks to: [Dragon-Developer][BR] --> https://github.com/Dragon-Developer (v1.7.0)
	Created on [DMY]: 24/08/2022
	Last updated on [DMY]: 23/02/2024
	Description: draws a circular bar with advanced customizable aesthetics

	NOTES:
	> BASED ON --> http://www.davetech.co.uk/gamemakercircularhealthbars
	  > Please support the original circular bar script creator

	> CONSIDER USING draw_set_circle_precision() TO CHANGE THE BAR'S INNER SMOOTHNESS

	> MAXIMUM PRECISION SUPPORTED: 999. IT IS RECOMMENDED TO USE THE DEFAULT VALUES DEFINED IN
	* CIRCULAR_BAR_PRECISION_PRESETS

	> refresh_mask IS A HEAVY PARAMETER TO PASS AS true, YOU SHOULD RESET IT TO false AS SOON AS
	* YOU'RE DONE MAKING THE GRAPHICAL CHANGES TO THE BAR MASK

	> WHEN OPERATING WITH THESE SCRIPTS, MAKE SURE TO PASS THE RIGHT DATA TYPES: SOME OF THEM
	* ARE ARRAYS, AND ARE ALL MARKED WITH PLURAL NAMES.
  *
	* E.G:
	* * circular_bar_auto_set_divisors(bar, divisor_count, divisor_amplitudes, divisor_edges)
  * *                                                               ARRAY ^        ARRAY ^
	* *
	* * circular_bar_auto_set_divisors(myBar, 3, [15], [1]);

	> IT IS NOT RECOMMENDED TO EDIT NOR CALL ANY OF THE METHODS DIRECTLY.
*/

/*
	HOW TO USE THE SCRIPT:

	------------------------------
	1. Initialise an object
	------------------------------

	bar = circular_bar_create(...);

	// EDGES:
		// 0 = FLAT (NONE)
		// 1 = ROUND
		// 2 = CHEVRON
		// 3 = RECTANGLE
		// 4 = BUBBLY ON TOP
		// 5 = BUBBLY ON CENTER
		// 6 = BUBBLY ON BOTTOM
		// 7 = DART ON TOP
		// 8 = DART ON CENTER
		// 9 = DART ON BOTTOM
		// 10 = DIAMOND ON TOP
		// 11 = DIAMOND ON CENTER
		// 12 = DIAMOND ON BOTTOM
		// 13 = TRIANGLE ON TOP
		// 14 = TRIANGLE ON CENTER
		// 15 = TRIANGLE ON BOTTOM
		// 16 = TRAPEZOID ON TOP
		// 17 = TRAPEZOID ON CENTER
		// 18 = TRAPEZOID ON BOTTOM
		// 19 = ROUNDED DIAMOND ON TOP
		// 20 = ROUNDED DIAMOND ON CENTER
		// 21 = ROUNDED DIAMOND ON BOTTOM

	------------------------------
	2. Call the script
	------------------------------

	draw_circular_bar(bar, ...);
*/
///@ADVANCED CIRCULAR BAR v2.1.0 - IMPROVED CUSTOMIZATION UPDATE

/*
	--------------------------------
	draw_advanced_circular_bar();
	--------------------------------

	Author:         [Maximilian Volt.][IT] --> https://github.com/MaximilianVolted (whole script)
	Also thanks to: [Dragon-Developer][BR] --> https://github.com/Dragon-Developer (v1.7.0)
	Created on [DMY]: 24/8/2022
	Last updated on [DMY]: 8/12/2023
	Description: draws a circular bar with advanced customizable aesthetics

	NOTES:
	> BASED ON --> http://www.davetech.co.uk/gamemakercircularhealthbars
	  > Please support the original circular bar script creator

	> CONSIDER USING draw_set_circle_precision() TO CHANGE THE BAR'S INNER SMOOTHNESS

	> MAXIMUM PRECISION SUPPORTED: 999. IT IS RECOMMENDED TO USE THE DEFAULT VALUES DEFINED IN
	* ADVANCED_CIRCULAR_BAR_QUALITY

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
		// 2 = BUBBLY
		// 3 = CHEVRON
		// 4 = RECTANGLE
		// 5 = DIAMOND ON TOP
		// 6 = DIAMOND ON CENTER
		// 7 = DIAMOND ON BOTTOM
		// 8 = TRIANGLE ON TOP
		// 9 = TRIANGLE ON CENTER
		// 10 = TRIANGLE ON BOTTOM
		// 11 = TRAPEZOID ON TOP
		// 12 = TRAPEZOID ON CENTER
		// 13 = TRAPEZOID ON BOTTOM
		// 14 = ROUNDED DIAMOND ON TOP
		// 15 = ROUNDED DIAMOND ON CENTER
		// 16 = ROUNDED DIAMOND ON BOTTOM
		// 17 = DART ON TOP
		// 18 = DART ON CENTER
		// 19 = DART ON BOTTOM

	------------------------------
	2. Call the script
	------------------------------

	draw_circular_bar(bar, ...);
*/
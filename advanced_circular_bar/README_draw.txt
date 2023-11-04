///@ADVANCED CIRCULAR BAR v2.0.5 - TOWARDS ANIMATION

/*
	--------------------------------
	draw_advanced_circular_bar();
	--------------------------------

	Author:         [Maximilian Volt.][IT] --> https://github.com/MaximilianVolted (whole script)
	Also thanks to: [Dragon-Developer][BR] --> https://github.com/Dragon-Developer (v1.7.0)
	Created on [DMY]: 24/8/2022
	Last updated on [DMY]: 4/11/2023
	Description: draws a circular bar with advanced customizable aesthetics

	NOTES:
	> BASED ON --> http://www.davetech.co.uk/gamemakercircularhealthbars
	  > Please support the original circular bar script creator

	> CONSIDER USING draw_set_circle_precision() TO CHANGE THE BAR'S INNER SMOOTHNESS
		> MAXIMUM PRECISION SUPPORTED: 999

	>	TO REMOVE EDGES' EXTENSION CALCULATION, DECOMMENT LINE 287

	> refresh_mask IS A HEAVY PARAMETER TO PASS AS true, YOU SHOULD RESET IT TO false AS SOON AS
	* YOU'RE DONE MAKING THE GRAPHICAL CHANGES TO THE BAR MASK
*/

/*
	HOW TO USE THE SCRIPT:

	------------------------------
	1. Initialise an object
	------------------------------
	
	bar = new Advanced_circular_bar(...);

	// EDGES:
		// 0 = FLAT (NONE)
		// 1 = ROUND
		// 2 = BUBBLY
		// 3 = CHEVRON
		// 4 = RECTANGLE
		// 5 = TRIANGLE ON TOP
		// 6 = TRIANGLE ON CENTER
		// 7 = TRIANGLE ON BOTTOM
		// 8 = TRAPEZOID ON TOP
		// 9 = TRAPEZOID ON CENTER
		// 10 = TRAPEZOID ON BOTTOM
		// 11 = ROUNDED TRIANGLE ON TOP
		// 12 = ROUNDED TRIANGLE ON CENTER
		// 13 = ROUNDED TRIANGLE ON BOTTOM

	------------------------------
	2. Call the script
	------------------------------

	draw_advanced_circular_bar(bar, ...);
*/
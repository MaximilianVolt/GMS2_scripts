///@ CIRCULAR BAR v2.5.1 - COLOR STOPS

/*
	--------------------
	draw_circular_bar();
	--------------------

	Author: [Maximilian Volt.][IT] --> https://github.com/MaximilianVolt (whole script)
	Also thanks to: [Dragon-Developer][BR] --> https://github.com/Dragon-Developer (v1.7.0)
	Created on [DMY]: 24/08/2022
	Last updated on [DMY]: 10/11/2024
	Description: draws a circular bar with advanced customizable aesthetics

	NOTES:
	> BASED ON --> http://www.davetech.co.uk/gamemakercircularhealthbars
	  > Please support the original circular bar script creator

	> CONSIDER USING draw_set_circle_precision() TO CHANGE THE BAR'S INNER SMOOTHNESS

	> MAXIMUM PRECISION SUPPORTED: 999. IT IS RECOMMENDED TO USE THE DEFAULT VALUES DEFINED IN
	* CIRCULAR_BAR_PRECISION_PRESETS

	> refresh_mask IS A HEAVY PARAMETER TO PASS AS true, YOU SHOULD RESET IT TO false AS SOON AS
	* YOU'RE DONE MAKING THE GRAPHICAL CHANGES TO THE BAR MASK

	> IT IS RECOMMENDED TO ONLY USE THE INTERFACING FUNCTIONS.
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
# Guide for using the circular bar script

Thanks for checking out this guide!
In this file are described some cases of how to use the circular bar, but for any doubt or question, don't hesitate to contact me on Discord: **maximilian.volt**!

## RECENT UPDATES

### ADVANCED CIRCULAR BAR v1.5.0 - WHAT'S NEW

> Version 1.5.0 has new utility functions ready to be used!

- Added several utility functions!
- Added option to set surface scalng to the drawing functions!
- Moved the flash and rotattion functions from this script file!

### ADVANCED CIRCULAR BAR v1.4.0

- Improved the `smoothen()` function!

### CIRCULAR BAR v2.4.0 - WHAT'S NEW

> Version 2.4.0 brings tons of new utility functions! This will definitely make your life easier!

- Added several utility functions!
- Added option to set surface scaling to the drawing function!
- Moved the flash and rotattion functions in this script file!

### CIRCULAR BAR v2.3.0

- Improved border function! Say goodbye to those old angle calculations!
- New utility function `circular_bar_get_anchor_point()` added! You can now retrieve the relative x and y coordinates of a bar with value and anchor overrides! This can be useful when adding elements on top of the bar, like an icon or a sprite!
- Improved from the older patches a new way to specify blendmodes and shaders to make your UI stand out with your own custom effects!
- Added varying transparency! Just like the colors, specify and array of 2 values that go from 0 to 1.
- Consolidated the nomenclature! Try typing `circular_bar_*`, I dare you.
- Performance micro-optimazions! I tried to save that CPU where possible!

## SCRIPT DOCUMENTATION

### Create a circular bar

#### Pie bar

To create a simple pie bar you can do the following:

```gml
bar = circular_bar_create(500, 500, 100);
```

Or this:

```gml
bar = circular_bar_create_amplitude(500, 500, 100);
```

Both will create a circular bar with coordinates P(500; 500) and a radius of 100 pixels.

#### Ring bar

To make a ring bar, use the 4th parameter to specify the width of the bar, from the circumference.

```gml
bar = circular_bar_create(500, 500, 100, 20);
```

Or, alternatively:

```gml
bar = circular_bar_create_amplitude(500, 500, 100, 20);
```

## The guide is currently being worked on! :O

> Hang tight!

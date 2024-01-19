# Guide for using the circular bar script

Thanks for checking out this guide!
In this file are described some cases of how to use the circular bar, but for any doubt or question, don't hesitate to contact me on Discord: **maximilian.volt**!

## Create a circular bar

### Pie bar

To create a simple pie bar you can do the following:

```gml
bar = circular_bar_create(500, 500, 100);
```

Or this:

```gml
bar = circular_bar_create_amplitude(500, 500, 100);
```

Both will create a circular bar with coordinates P(500; 500) and a radius of 100 pixels.

### Ring bar

To make a ring bar, use the 4th parameter to specify the width of the bar, from the circumference.

```gml
bar = circular_bar_create(500, 500, 100, 20);
```

Or, alternatively:

```gml
circular_bar_create_amplitude(500, 500, 100, 20);
```

## The guide is currently being worked on! :O

> Hang tight!

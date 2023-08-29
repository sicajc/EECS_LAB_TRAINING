# Q & A
1. When drawing finFet layout, what are the common steps you would take to complete the full &layout, take an inverter as example?
>>>


2. In VLSI, stick diagram can be drawn first to give a brief overview about the layout, can I do the same thing to Finifet layout, if so what are the common steps or Procedures for doing so?

3. When trying to draw the layout of multiple finfet fundamental building blocks, how do you usually connect them together to achieve smaller area? When considering the constraint of unidirectional VDD,GND and metal? The idea I got from other course?

4. What are the common mistakes you might make when drawing projects or drawing such layouts?


# Environment setting
1. Everytime you run virtuoso must
```
    source setup.csh
```

2. Replace cds.lib -> line8 , add asap_TechLib_10


3. Small window is the central command line, which enables the use of command line layouting.
4. This is used to emphasize the layout layers, metal or via or else...


# HotKeys and windows
1. Filters can be used to search the layer you would like to use.
2. Press R, rectangle layout can be drawn.
3. HOTKEY for Undo? Ways to customize hotkeys?
4. K and shift+K is the ruler for viewing the length of the layout, shift+K removes all rulers.


# DRC
1. ACTIVE.LUP.1 this error can be ignored.


# CDL generation
1. Must fix CDL-> From LVS we can find the corresponding error pins.
2. Must add pins and ensure that your layout and Hspice has the same circuit.

# Debug
1. From the interface, debug the lvs.

Prefab created by chrjen#2648 (discord) v.2

If you can, please credit me if you use this in a map.
Making these takes time and effort!

===========

Basic button as seen in the game. Can be used to turn things on or off.
Options for glow and custom colours.

Changes:
  - v.2
    - Made the output accessible from outside the prefab removing the need to collapse it.
    - Added a metal backplate and an only button version without any backplate at all.
    - Added options for glow.
    - Added options for unique colours.

Outputs:
  - OnPressed: Triggered once when the button is pressed down.
  - OnReleased: Triggered once when the button stop being pressed.

Inputs:
  - StartGlow: Make the button start to glow.
  - StopGlow: Make the button stop glowing.
  - ToggleGlow: Toggles the glow effect.

How to:
  1. Drag .vmap files to <SDK>/content/hlvr/maps/prefabs
  2. From withing hammer, click prefab tab and find the prefabs and drag them onto a wall and rotate if necessary.
  3. With the prefab selected hit alt+Enter and go to Outputs tab and add an output for OnPressed to activate something on button press.

PS: You can press Shift+O to hide editor only objects from view.
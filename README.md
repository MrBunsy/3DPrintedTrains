# 3DPrintedTrains

Various attempts to 3D print OO gauge trains and accessories. Licenced under GNU GPL-3.0-or-later.

## MWA Wagons

There are three variants: MWA (green), MWA-B (grey) and IOA (yellow). See below for more details.

Assembly requires up to eight 4mm M2 screws or hot glue. There are square pits in the bottom of the 'top' and top of the 'base' to allow space for hot glue without changing the shape of the finished wagon, alternatively you can use small (4/5mm) m2 screws - but the glue is more reliable. The bogies require a 10mm M3 screw and two M3 washers (one above and one below the bogie, to help with rotation). The bogies provide fixings for a dapol-style coupling, my 3D printed design works well. The brake wheels, cylinders and buffers should slot in with only a little encouragement - if needed you can clear out the hole by first screwing in an m2 screw, but don't clean the hole too much as they rely on friction to stay in. Since the small slot-in components are easy to snap I recommend printing them in something slightly more flexible than PLA, like PETG.

The main body of the wagon is split into two files ("wagon_top" and "wagon_base") to avoid too much warping when printing. Alternatively the entire wagon is avaible as "wagon_wagon". Good base adhesion is required for printing the top of the wagon. Even with good adhesion there is a slight line of warping, but this is mostly not too visible.

The bogie requires scafolding only on the underside of the coupling holder. If you want a more accurate, but harder to print, version of the bogie set BOGIE_EASY_PRINT to false.

Run gen_mwa_wagon.bat to generate all the STL files required. 

### MWA

Uses the MWA_wagon_\*.stl files. The four-pronged brake wheel (white PETG) slots into the sides of the wagon base. The two brake cylinders (black PETG) slot into the bottom of the wagon base. Print the following:

 - MWA_wagon_base: Green PLA
 - MWA_wagon_top: Green PLA
 - MWA_wagon_bogie (x2): Black PLA
 - MWA_wagon_brake_cylinder (STL contains two objects): Black PETG
 - MWA_wagon_buffer (x4): Black PETG
 - MWA_wagon_brake_wheel (x2): White PETG
 
### MWA-B

Uses the MWA-B_wagon_\*.stl files and some MWA_wagon_\*.stl files. The three-pronged brake wheels slot into the sides of one of the bogies. This bogie should be attached at the end furthest from the brake cylinder - there is only one brake cylinder on the MWA-B. Otherwise the same as the MWA wagon.

 - MWA-B_wagon_base: Grey PLA
 - MWA-B_wagon_top: Grey PLA
 - MWA-B_wagon_bogie (x1): Black PLA
 - MWA_wagon_bogie (x1): Black PLA
 - MWA-B_wagon_brake_cylinder : Black PETG
 - MWA_wagon_buffer (x4): Black PETG
 - MWA-B_wagon_brake_wheel (x2): White PETG

### IOA

Uses the IOA_wagon_\*.stl files and some MWA_wagon_\*.stl files. The brake cylinders are part of the base as they're also yellow. Brake wheels slot into the sides of the wagon base, like MWA. The IOA wagon uses the MWA bogies.

 - IOA_wagon_base: Yellow PLA
 - IOA_wagon_top: Yellow PLA
 - MWA_wagon_bogie (x2): Black PLA
 - MWA_wagon_buffer (x4): Black PETG
 - MWA_wagon_brake_wheel (x2): White PETG

## Couplings

My first attempt at a coupling (hornby_bachman_style.scad) is an equivilant to Hornby's X8031. This is compatible with Bachman's trucks as well (at least the ones from the 90s). With the hook holder, it is slightly wider than the original, so may not fit all situations (I can't mount them on a hornby loco). The version without the hook should fit.

A new configurable coupling generator (couplings_parametric.scad) is capable of producing not just a Hornby/Bachmann X8031, but a Dapol/Hornby/Airfix X9660 and Hornby dovetail fixing.

### Hornby Dovetail
Usually the real dovetail fixing creates a NEM socket, but I've skipped the middleman and produced a coupling that can slot straight into the Hornby chassis. In my experience, the real dovetail connectors fall out far too easily. The printed version isn't perfect, but stays in better than the real hornby ones I've used (when fitted with a wide coupling).

## Class 66

Print at 51 degrees.

For base: print settings->Infil->bridging angle to 231 to get bridging for battery holder at shortest angle
settings->Infil->fill angle to 51

brim and no skirt for base and shell, need support for the socket and switch holes. need to investigate distance for brim - hard to remove cleanly on last print

Shell didn't print roof without support. not tried with support yet - but possibly upside down will need less support?
Even with 5mm brim the shell lifted at the ends. Not sure if to try more brim, custom brim on the inside of the model or a raft

## Intermodal Wagon

Based on an amalgamation of an FTA and FSA intermodal flat wagon. It was hard to get buffer heights correct for OO, so the mix seemed the best compromise. ISO containers (see my fork of phrxmd's container) can optionally be fixed to the wagon with m2 screws and washers. Visible holes at either end for the containers are optional, and not needed unless you want a 20ft container at either end. I'd like to experiment with friction or magnetic ways to hold the containers in place.

The wagon is made of multiple parts, with the cosmetic parts slotting in and held by friction and the mechnical parts held in with machine screws. For the cosmetic attachments, screwing in and removing an m2 screw helps clear the holes ready for easy attaching.

### Intermodal Bogies

An aproximation of what I think is a varient of Y25 bogie. Fits 12.5mm wheels from Dapol, Hornby or Bachmann (only ones I've tested). Coupling fixing for attaching a hornby/bachmann style coupling (or the 3d printed version included here) with an m2 machine screw. Attaches to the base of the wagon with two washers and an m3 machine screw. These work well in PETG, not tested in PLA yet.

### Brake wheels

Two brake wheels, one on either side. These work best in PETG, PLA is a bit too brittle

### Modern Buffers

Like the brake wheel, these work best in PETG for some slight flexibility.

### Brake Cylinder

Not entirely sure what this is for in real life (pneumatic brakes?). Prints easily with brim, and I've had success at printing in PETG without brim. This slots into the underside of the main chassis arm.

## Fruit van

A fruit-van style covered wagon, intended to house a pi and batteries for my WiFiPi trains. Again made of multiple parts:

## Truck Base

Functional, but cosmetics for the cart spring mechanism need improvement. This comes with variations to hold a 9V battery or raspberry pi with camera. These versions are deliberately oversized because the pi is a bit too wide, and it's hard to get the camera in the right place if it's at an angle.

## Fruit Van

The fruit van attaches to the truck base with m2 machine screws.

## Fruit Van Roof

The roof just slots in top of the fruit van.

## Buffers

0.2mm layer height without brim seems to print well. "Buffer" for round ended buffers for trucks, and "Buffer Modern" for square ended for intermodal wagon.
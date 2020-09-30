# 3DPrintedTrains

Various attempts to 3D print OO gauge trains and accessories.

## Couplings

I've had some success at producing an equivilant to Hornby's X8031. This is compatible with Bachman's trucks as well (at least the ones from the 90s). With the hook holder, it is slightly wider than the original, so may not fit all situations (I can't mount them on a hornby loco). The version without the hook should fit.

Still TODO hornby/dapol X9660 style.

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
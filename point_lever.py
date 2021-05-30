import cadquery as cq

if 'show_object' not in globals():
    def show_object(*args, **kwargs):
        pass


point_travel_distance=5-1.9
lever_travel_distance=point_travel_distance*2

#TODO M3?
hinge_d = 3.2

gap_thick = 8
wiggle = 0.2

lever_top_hinge_above_axle=20
lever_top_d = 15
lever_axle_height = 15
lever_width = 8
lever_thick = gap_thick-wiggle*2

rod_length = 100
rod_base_thick = 3
rod_lever_bit_thick= 1
rod_lever_bit_height = (lever_axle_height - rod_base_thick)*0.8
#TODO real maths on this
rod_lever_bit_width = 15

def gen_lever():
    #lever = cq.Workplane("XY")

    #main lever shape without the circle on top
    lever = cq.Workplane("XY").tag("lever_base").move(0,lever_top_hinge_above_axle).line(lever_width/2,0).lineTo(lever_width/2,-(lever_axle_height-lever_width/2-wiggle)).radiusArc((0,-(lever_axle_height-wiggle)), lever_width/2-wiggle)
    #make 3D
    lever = lever.mirrorY().extrude(lever_thick)
    lever = lever.union(lever.workplaneFromTagged("lever_base").center(0,lever_top_hinge_above_axle).circle(lever_top_d/2).extrude(lever_thick))
    #hinge hole
    lever = lever.pushPoints([(0,0) , (0,lever_top_hinge_above_axle )]).circle(hinge_d/2).cutThruAll()
    return lever

def gen_rod():
    rod = cq.Workplane("XY").tag("rod_base").rect(rod_length,gap_thick).extrude(rod_base_thick)
    rod = rod.faces(">Y").workplane().move(rod_lever_bit_width/2,0).line(0,rod_lever_bit_height).line(rod_lever_bit_thick,0).line(rod_lever_bit_height,-rod_lever_bit_height).close().mirrorY().extrude(-gap_thick)

    return rod

lever = gen_lever()
rod = gen_rod()

# show_object(lever)
show_object(rod)
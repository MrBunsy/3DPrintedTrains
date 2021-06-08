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
    rod = cq.Workplane("XY").tag("rod_base").box(rod_length, gap_thick, rod_base_thick)#rect(rod_length,gap_thick).extrude(rod_base_thick)
    #add slot on top for the point lever to move
    rod = rod.faces(">Y").workplane(centerOption="CenterOfMass").move(rod_lever_bit_width/2,0).line(0,rod_lever_bit_height).line(rod_lever_bit_thick,0).line(rod_lever_bit_height,-rod_lever_bit_height).close().mirrorY().extrude(-gap_thick)
    rod = rod.union(gen_spring(rod.faces(">X").workplane(centerOption="CenterOfMass"), rod_base_thick,20,gap_thick*2,3))
    rod = rod.union(
        gen_spring(rod.faces("<X").workplane(centerOption="CenterOfMass"), rod_base_thick, 20, gap_thick*2, 4))
    return rod

def gen_spring(workplaneOnEnd, thick, totalLength, width, kinks):
    '''
    Spring on the XY plane in the Y direction
    TODO fix the shape of the end of teh spring
    :param thick:
    :param totalLength:
    :param width:
    :param kinks:
    :return:
    '''
    #transforming workplane doesn't work, this does. I want to know why
    workplaneInline = cq.Workplane(cq.Plane(origin=workplaneOnEnd.plane.origin, xDir=workplaneOnEnd.plane.xDir, normal=-workplaneOnEnd.plane.yDir))
    #workplane is flat on the end of what wants a spring
    kinkLength = totalLength/(kinks)
    points = [(0,0),(width/2,kinkLength/2)]
    #path = workplaneInline.line(width/2,kinkLength/2)
    for i in range(kinks-1):
        posNeg= -1 if i%2 == 0 else 1
        points.append((posNeg*width/2,kinkLength*(i+1.5)))
    points.append((0, totalLength))
    path = workplaneInline.polyline(points)
    return workplaneOnEnd.rect(thick, thick).sweep(path,isFrenet=True)

lever = gen_lever()
rod = gen_rod()
#spring = gen_spring(cq.Workplane("XY"), 3,20,10,5)

#show_object(spring)

# show_object(lever)
show_object(rod)
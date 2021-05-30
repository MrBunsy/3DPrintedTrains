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
    # rod = add_spring(rod.faces(">X").workplane(), rod_base_thick, -rod_base_thick,gap_thick)
    test = rod.faces(">X").workplane().val()
    #rod.faces(">X").workplane().transformed(rotate=cq.Vector(0,90,0))
    rod.faces(">X").workplane()
    rod = rod.union(gen_spring(cq.Workplane("YZ"),cq.Workplane("XY"), 3,20,10,5).rotate((0,0,0),(0,0,1),-90).translate(rod.faces(">X").workplane().val()).translate((0,0,3/2)))
    return rod

def add_spring(workplane,thick,height,width,kinks=4):

    splinepoints = [(0,height/2,0)]
    path = cq.Workplane("XY").line(width/2,thick)
    length = 0
    for i in range(kinks):
        posNeg= -1 if i%2 == 0 else 1
        length = length + thick*2
        splinepoints.append((posNeg*width/2,height/2,length))
        path=path.line(posNeg*width,thick*2)
    # path = workplane.spline(splinepoints)
    # cq.Wire.
    # return path
    # return workplane.rect(thick,thick).sweep(path)#, makeSolid=True, isFrenet=True)
    # return cq.Workplane("XZ").rect(thick, thick).sweep(path, makeSolid=True, isFrenet=True)
    return workplane.rect(thick, thick).sweep(path, makeSolid=True, isFrenet=True)

# def gen_spring(thick, totalLength, width, kinks):
#     '''
#     Spring on the XY plane in the Y direction
#     :param thick:
#     :param totalLength:
#     :param width:
#     :param kinks:
#     :return:
#     '''
#     kinkLength = totalLength/(kinks)
#     path = cq.Workplane("XY").line(width/2,kinkLength/2)
#     for i in range(kinks-1):
#         posNeg= -1 if i%2 == 0 else 1
#         path=path.line(posNeg*width,kinkLength)
#     path = path.lineTo(0,totalLength)
#     # path = path.line(0, 1)
#     return cq.Workplane("XZ").rect(thick, thick).sweep(path)

def gen_spring(workplaneOnEnd, workplaneInline, thick, totalLength, width, kinks):
    '''
    Spring on the XY plane in the Y direction
    :param thick:
    :param totalLength:
    :param width:
    :param kinks:
    :return:
    '''
    #workplane is flat on the end of what wants a spring
    kinkLength = totalLength/(kinks)
    path = workplaneInline.line(width/2,kinkLength/2)
    for i in range(kinks-1):
        posNeg= -1 if i%2 == 0 else 1
        path=path.line(posNeg*width,kinkLength)
    path = path.lineTo(0,totalLength)
    # path = path.line(0, 1)
    return workplaneOnEnd.rect(thick, thick).sweep(path)

lever = gen_lever()
rod = gen_rod()
# spring = gen_spring(3,20,10,5)

# show_object(spring)

# show_object(lever)
show_object(rod)
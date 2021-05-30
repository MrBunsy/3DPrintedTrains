import cadquery as cq
from cadquery import Solid, Vector
from cadquery import exporters

def m2mm(metres):
    return metres*1000/76.2

def ft2mm(feet, inches):
    return m2mm(feet*12*2.54/100) + m2mm(inches*2.54/100)

class Class60:
    '''
    Ideas:

     - Shell that clicks into place over the base, so base is less wide than total, how do I do lights?

     - Base and walls are a single piece, with roof separate. Might need lots of support?
        - Could do this, with underhanging bits of the base attaching separately, no support needed, can stick to using screws/glue
        - roof click in or screw in? Could have just the centre section of roof separate, since that's visually fitting
    '''
    def __init__(self):
        #wild guess
        self.buffer_to_buffer_length = m2mm(21.34)
        #measured from old line drawing, results in buffers 7.3mm long - which is 55cm, so seems about right
        self.length = 265.5
        self.bufferlength = (self.buffer_to_buffer_length - self.length)/2

        #up to the edge of the vertical slot that houses the doorhandle
        self.bodylength = 20.3
        #70ft
        # self.length = m2mm(21.34) - 2* self.bufferlength
        #8'8"
        self.width = m2mm(2.64)
        #rail to top of roof
        #13ft - note this appears to only be top of the cab roof, there are bits which stick a little higher
        self.height = m2mm(3.95)
        #distance between centres of bogies
        self.bogie_pivot_distance = m2mm(13.02)
        #distance between axles on bogies, which apparently are different!
        self.bogie_front_axle_distance = m2mm(2.1)
        self.bogie_inner_axle_distance = m2mm(2.03)
        self.wheel_diameter = ft2mm(3, 8)


train = Class60()
print(train.wheel_diameter)
print(train.bufferlength*76.2)
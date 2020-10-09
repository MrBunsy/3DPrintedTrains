import os
from multiprocessing import Pool
import multiprocessing
from pathlib import Path


Path("out").mkdir(parents=True, exist_ok=True)

door_styles = 8
lengths = [True, False]
highcubes = [True, False]
coins = ["penny","tuppence","none"]

class JobDescription():
    def __init__(self, scad, filename):
        self.variables = {}
        self.scad = scad
        self.filename = filename

    def addVariable(self, name, value):
        self.variables[name] = value

    def getVariableString(self):
        return " ".join(["-D {varname}={varvalue}".format(varname=key,varvalue=self.variables[key]) for key in self.variables])

    def do(self):
        cmd =  "openscad -o out/{filename}.stl {variablestring} {scad}".format(filename = self.filename, variablestring = self.getVariableString(), scad=self.scad)
        print(cmd)
        os.system(cmd)
        print("finished {}".format(self.filename))

def executeJob(job):
    job.do()


jobs = []

class66Variables = ["base", "shell", "bogies","motor_clip"]
at_angle = ["base","shell"]
full66Job = JobDescription("class66.scad", "class66_model")
full66Job.addVariable("GEN_IN_PLACE", "true")

for v in class66Variables:
    full66Job.addVariable("GEN_"+v.upper(), "true")
    job = JobDescription("class66.scad", "class66_{}".format(v))
    job.addVariable("GEN_IN_PLACE", "false")
    #so it fits on the print bed without me having to fiddle it every tiem in the slicer
    job.addVariable("ANGLE", "51" if v in at_angle else "0")
    for v2 in class66Variables:
        job.addVariable("GEN_"+v2.upper(), "true" if v==v2 else "false")
    jobs.append(job)
jobs.append((full66Job))

if __name__ == '__main__':
    p = Pool(multiprocessing.cpu_count()-1)
    p.map(executeJob, jobs)
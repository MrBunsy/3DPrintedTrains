import os
from multiprocessing import Pool
import multiprocessing
from pathlib import Path
import argparse

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
        if isinstance(value, str):
            self.variables[name] = "\\\"{}\\\"".format(value)
        if type(value)==bool:
            self.variables[name] = "true" if value else "false"

    def getVariableString(self):
        return " ".join(["-D {varname}={varvalue}".format(varname=key,varvalue=self.variables[key]) for key in self.variables])

    def do(self):
        cmd =  "openscad -o out/{filename}.stl {variablestring} {scad}".format(filename = self.filename, variablestring = self.getVariableString(), scad=self.scad)
        print(cmd)
        os.system(cmd)
        print("finished {}".format(self.filename))

def executeJob(job):
    job.do()

def class66_jobs():
    jobs = []
    #"walls", "roof",
    class66Variables = ["base", "shell", "bogies" ,"motor_clip", "pi_mount"]
    at_angle = ["base", "shell", "walls"]
    full66Job = JobDescription("class66.scad", "class66_model")
    full66Job.addVariable("GEN_IN_PLACE", "true")
    for v in ["base", "shell", "bogies"]:
        full66Job.addVariable("GEN_"+v.upper(), "true")

    full66Job.addVariable("DUMMY", "true")

    for v in class66Variables:
        #full66Job.addVariable("GEN_"+v.upper(), "true")
        job = JobDescription("class66.scad", "class66_{}".format(v))
        job.addVariable("GEN_IN_PLACE", "false")
        #so it fits on the print bed without me having to fiddle it every tiem in the slicer
        job.addVariable("ANGLE", "51" if v in at_angle else "0")
        for v2 in class66Variables:
            job.addVariable("GEN_"+v2.upper(), "true" if v==v2 else "false")
        jobs.append(job)
    jobs.append(full66Job)
    return jobs

def couplings_jobs():
    jobs = []


    for hook in ["inline", "chunky", "no"]:
        for style in ["wide"]:
            for fixing in ["X8031","dovetail","dapol"]:
                job = JobDescription("couplings_parametric.scad", "coupling_{}_{}_{}_hook".format(style, fixing, hook))
                job.addVariable("GEN_IN_SITU", False)
                job.addVariable("GEN_COUPLING", True)
                job.addVariable("GEN_HOOK", False)
                job.addVariable("STYLE", style)
                job.addVariable("HOOK", hook)
                job.addVariable("FIXING", fixing)
                jobs.append(job)
        if hook != "no":
            job2 = JobDescription("couplings_parametric.scad", "coupling_hook_{}".format(hook))
            job2.addVariable("GEN_IN_SITU", False)
            job2.addVariable("GEN_COUPLING", False)
            job2.addVariable("GEN_HOOK", True)
            job2.addVariable("HOOK", hook)
            jobs.append(job2)

    return jobs

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Generate all variants of a parametric object")
    parser.add_argument("--class66",action='store_true')
    parser.add_argument("--couplings",action='store_true')
    args = parser.parse_args()
    jobs = []


    if args.class66:
        jobs.extend(class66_jobs())
    if args.couplings:
        jobs.extend(couplings_jobs())

    p = Pool(multiprocessing.cpu_count()-2)
    p.map(executeJob, jobs)
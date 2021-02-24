'''
Copyright Luke Wallin 2020

This file is part of Luke Wallin's 3DPrintedTrains project.

The 3DPrintedTrains project is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The 3DPrintedTrains project is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with The 3DPrintedTrains project.  If not, see <https:www.gnu.org/licenses/>.
'''

import os
from multiprocessing import Pool
import multiprocessing
from pathlib import Path
import argparse
import numpy
import stl
from stl import mesh

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
        elif type(value)==bool:
            self.variables[name] = "true" if value else "false"
        else:
            self.variables[name] = value

    def getVariableString(self):
        return " ".join(["-D {varname}={varvalue}".format(varname=key,varvalue=self.variables[key]) for key in self.variables])

    def do(self):
        cmd =  "openscad -o out/{filename}.stl {variablestring} {scad}".format(filename = self.filename, variablestring = self.getVariableString(), scad=self.scad)
        print(cmd)
        os.system(cmd)
        print("finished {}".format(self.filename))
        model = mesh.Mesh.from_file("out/{filename}.stl".format(filename = self.filename))
        model.save("out/{filename}-binary.stl".format(filename = self.filename), mode=stl.Mode.BINARY)
        #TODO can even use matplotlib to render it!


def executeJob(job):
    job.do()

def class66_jobs():
    jobs = []
    #"walls", "roof",
    class66Variables = ["base", "shell", "bogies" ,"motor_clip", "pi_mount", "headlights"]
    at_angle = ["base", "shell", "walls"]
    full66Job = JobDescription("class66.scad", "class66_model")
    full66Job.addVariable("GEN_IN_PLACE", True)
    for v in ["base", "shell", "bogies"]:
        full66Job.addVariable("GEN_"+v.upper(), True)

    full66Job.addVariable("DUMMY", True)

    for v in class66Variables:
        #full66Job.addVariable("GEN_"+v.upper(), "true")
        job = JobDescription("class66.scad", "class66_{}".format(v))
        job.addVariable("GEN_IN_PLACE", False)
        #so it fits on the print bed without me having to fiddle it every tiem in the slicer
        job.addVariable("ANGLE", 51 if v in at_angle else 0)
        for v2 in class66Variables:
            job.addVariable("GEN_"+v2.upper(), v==v2)
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

def wagon_jobs():
    jobs = []
    couplings = ["X8031","dapol"]
    wagon_types = ["van"]
    wagon_variants = ["normal", "battery","pi"]
    wagon_options = ["base", "top", "roof"]

    for type in wagon_types:
        for variant in wagon_variants:
            name = "wagon_{}_{}_".format(type, variant)
            model_job = JobDescription("wagons_parametric.scad", name + "model")
            model_job.addVariable("GEN_IN_SITU", True)
            model_job.addVariable("VARIANT", variant)
            model_job.addVariable("TYPE", type)
            #model_job.addVariable("COUPLING", coupling)
            for option in wagon_options:
                for coupling in couplings:
                    couplingName = ""
                    if option != "base" and coupling != couplings[0]:
                        #don't need to generate anything other than the base with the coupling types!
                        continue
                    if option == "base":
                        couplingName = "_"+coupling
                    model_job.addVariable("GEN_{}".format(option.upper()), True)
                    job = JobDescription("wagons_parametric.scad", name + option + couplingName)
                    job.addVariable("GEN_IN_SITU", False)
                    job.addVariable("VARIANT", variant)
                    job.addVariable("TYPE", type)
                    job.addVariable("COUPLING", coupling)
                    for option2 in wagon_options:
                        #set all to false by default
                        job.addVariable("GEN_{}".format(option2.upper()), False)
                    #set only the one we want to true
                    job.addVariable("GEN_{}".format(option.upper()), True)
                    jobs.append(job)
            jobs.append(model_job)



    return jobs

def mwa_wagon_jobs():
    jobs = []
    for style in ["MWA", "MWA-B", "IOA"]:
        MWAariables = ["bogie", "brake_cylinder", "base", "top", "brake_wheel", "wagon", "buffer"]
        fullMWAJob = JobDescription("MWA_wagon.scad", "{}_wagon_model".format(style))
        fullMWAJob.addVariable("GEN_IN_SITU", True)
        fullMWAJob.addVariable("STYLE", style)
        fullMWAJob.addVariable("GEN_BASE", False)
        fullMWAJob.addVariable("GEN_TOP", False)
        fullMWAJob.addVariable("GEN_MODEL_BITS", True)
        #want more realistic bogies for the model
        fullMWAJob.addVariable("BOGIE_EASY_PRINT", False)
        for v in ["wagon", "bogie", "brake_cylinder", "brake_wheel", "buffer"]:
            fullMWAJob.addVariable("GEN_"+v.upper(), True)

        for v in MWAariables:
            job = JobDescription("MWA_wagon.scad", "{}_wagon_{}".format(style, v))
            job.addVariable("GEN_IN_SITU", False)
            job.addVariable("GEN_MODEL_BITS", False)
            job.addVariable("BOGIE_EASY_PRINT", True)
            job.addVariable("STYLE", style)
            for v2 in MWAariables:
                job.addVariable("GEN_"+v2.upper(), v==v2)
            jobs.append(job)
        jobs.append(fullMWAJob)
    return jobs

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Generate all variants of a parametric object")
    parser.add_argument("--class66",action='store_true')
    parser.add_argument("--couplings",action='store_true')
    parser.add_argument("--wagons", action='store_true')
    parser.add_argument("--mwa", action='store_true')
    args = parser.parse_args()
    jobs = []


    if args.class66:
        jobs.extend(class66_jobs())
    if args.couplings:
        jobs.extend(couplings_jobs())
    if args.wagons:
        jobs.extend(wagon_jobs())
    if args.mwa:
        jobs.extend(mwa_wagon_jobs())

    p = Pool(multiprocessing.cpu_count()-1)
    p.map(executeJob, jobs)
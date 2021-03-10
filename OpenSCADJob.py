import os
from multiprocessing import Pool
import multiprocessing
import numpy
import stl
from stl import mesh

def executeJob(job):
    job.do()


class JobDescription():
    def __init__(self, scad, filename):
        self.variables = {}
        self.scad = scad
        self.filename = filename

    def addVariable(self, name, value):
        if isinstance(value, str):
            self.variables[name] = "\\\"{}\\\"".format(value)
        elif type(value) == bool:
            self.variables[name] = "true" if value else "false"
        elif isinstance(value, list):
            # just hope it's a list of strings, otherwise I cba to refactor this
            self.variables[name] = "[\\\"" + ("\\\",\\\"".join(value)) + "\\\"]"
        else:
            self.variables[name] = value

    def addVariables(self, dict):
        '''
        given dict of ["variable name"] = value, add them all
        :param dict:
        :return:
        '''
        for key in dict:
            self.addVariable(key, dict[key])

    def getVariableString(self):
        return " ".join(
            ["-D {varname}={varvalue}".format(varname=key, varvalue=self.variables[key]) for key in self.variables])

    def do(self):
        cmd = "openscad -o out/{filename}.stl {variablestring} {scad}".format(filename=self.filename,
                                                                              variablestring=self.getVariableString(),
                                                                              scad=self.scad)
        print(cmd)
        os.system(cmd)
        print("finished {}".format(self.filename))
        model = mesh.Mesh.from_file("out/{filename}.stl".format(filename=self.filename))
        model.save("out/{filename}-binary.stl".format(filename=self.filename), mode=stl.Mode.BINARY)
        # TODO can even use matplotlib to render it!

        #

def multiprocessJobs(jobs):
    p = Pool(multiprocessing.cpu_count() - 1)
    p.map(executeJob, jobs)
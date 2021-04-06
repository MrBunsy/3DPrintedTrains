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
from OpenSCADJob import JobDescription, multiprocessJobs

Path("out").mkdir(parents=True, exist_ok=True)

door_styles = 8
lengths = [True, False]
highcubes = [True, False]
coins = ["penny", "tuppence", "none"]



def intermodal_wagon_jobs():
    '''
    These aren't nicely in one parametric file, they're mostly spread across multiple files
    :return:
    '''
    jobs = []
    wagon_variables = ["front", "back", "no", "all"]

    for v in wagon_variables:
        job = JobDescription("intermodal_wagon.scad", "intermodal_wagon_with_{}_holes".format(v))
        for w in wagon_variables:
            job.addVariable("screwholes_for_containers_at_{}".format(w), w == v or v == "all")

        jobs.append(job)

    bufferJob = JobDescription("buffer_modern.scad", "intermodal_wagon_buffer")
    bufferJob.addVariable("GEN_BUFFER", True)

    jobs.append(bufferJob)

    bogieJob = JobDescription("intermodal_bogie.scad", "intermodal_wagon_bogie")
    jobs.append(bogieJob)

    accessory_variables = ["brake_wheel", "brake_cylinder"]

    for a in accessory_variables:
        job = JobDescription("intermodal_wagon_accessories.scad", "intermodal_wagon_{}".format(a))
        for v in accessory_variables:
            job.addVariable("gen_{}".format(v), v == a)

        jobs.append(job)
    return jobs


def class66_jobs():
    jobs = []
    # "walls", "roof",
    class66Variables = ["base", "shell", "bogies", "motor_clip", "pi_mount", "headlights", "buffer"]
    at_angle = ["base", "shell", "walls"]
    full66Job = JobDescription("class66.scad", "class66_model")
    full66Job.addVariable("GEN_IN_PLACE", True)
    for v in ["base", "shell", "bogies"]:
        full66Job.addVariable("GEN_" + v.upper(), True)

    full66Job.addVariable("DUMMY", True)

    for v in class66Variables:
        # full66Job.addVariable("GEN_"+v.upper(), "true")
        job = JobDescription("class66.scad", "class66_{}".format(v))
        job.addVariable("GEN_IN_PLACE", False)
        # so it fits on the print bed without me having to fiddle it every tiem in the slicer
        job.addVariable("ANGLE", 51 if v in at_angle else 0)
        for v2 in class66Variables:
            job.addVariable("GEN_" + v2.upper(), v == v2)
        jobs.append(job)
    jobs.append(full66Job)
    return jobs


def couplings_jobs():
    jobs = []
    fixings = {
            "hornby": {"FIXING": "X8031",
                      "HOOK": "chunky",
                      },
            "hornby_nohook": {"FIXING": "X8031",
                       "HOOK": "no",
                       },
            "dapol": {
                    "FIXING": "dapol",
                    "HOOK": "inline"
                    },
            "dovetail": {
                "FIXING": "dovetail",
                "HOOK": "inline"
            },
            "NEM": {
                "FIXING": "NEM",
                "HOOK": "inline"
            }
        }

    for hook in ["inline", "chunky"]:
        job = JobDescription("couplings_parametric.scad", "coupling_hook_{}".format(hook))
        job.addVariable("GEN_IN_SITU", False)
        job.addVariable("GEN_COUPLING", False)
        job.addVariable("GEN_HOOK", True)
        job.addVariable("HOOK", hook)
        jobs.append(job)

    for style in ["wide"]:
        for fixing in fixings.keys():
            job = JobDescription("couplings_parametric.scad", "coupling_{}_{}".format(fixing,style))

            job.addVariable("GEN_IN_SITU", False)
            job.addVariable("GEN_COUPLING", True)
            job.addVariable("GEN_HOOK", False)
            job.addVariables(fixings[fixing])
            jobs.append(job)

    return jobs


def wagon_jobs():
    jobs = []
    couplings = ["X8031", "dapol"]
    wagon_types = ["van"]
    wagon_variants = ["normal", "battery", "pi"]
    wagon_options = ["base", "top", "roof"]

    for type in wagon_types:
        for variant in wagon_variants:
            name = "wagon_{}_{}_".format(type, variant)
            model_job = JobDescription("wagons_parametric.scad", name + "model")
            model_job.addVariable("GEN_IN_SITU", True)
            model_job.addVariable("VARIANT", variant)
            model_job.addVariable("TYPE", type)
            # model_job.addVariable("COUPLING", coupling)
            for option in wagon_options:
                for coupling in couplings:
                    couplingName = ""
                    if option != "base" and coupling != couplings[0]:
                        # don't need to generate anything other than the base with the coupling types!
                        continue
                    if option == "base":
                        couplingName = "_" + coupling
                    model_job.addVariable("GEN_{}".format(option.upper()), True)
                    job = JobDescription("wagons_parametric.scad", name + option + couplingName)
                    job.addVariable("GEN_IN_SITU", False)
                    job.addVariable("VARIANT", variant)
                    job.addVariable("TYPE", type)
                    job.addVariable("COUPLING", coupling)
                    for option2 in wagon_options:
                        # set all to false by default
                        job.addVariable("GEN_{}".format(option2.upper()), False)
                    # set only the one we want to true
                    job.addVariable("GEN_{}".format(option.upper()), True)
                    jobs.append(job)
            jobs.append(model_job)

    return jobs


def mwa_wagon_jobs(just_gravel = False):
    jobs = []
    allOptions = ["bogie", "brake_cylinder", "base", "top", "brake_wheel", "wagon", "buffer", "gravel"]
    variables = {
        #all except gravel, for now
        "MWA": allOptions[:-1],
        # bogies are currently same for IOA and MWA, with one bogie different for MWA-B
        # buffers are same for all
        "MWA-B": ["brake_cylinder", "base", "top", "brake_wheel", "wagon", "bogie"],
        # IOA has no separate brake cylinders
        "IOA": ["base", "top", "brake_wheel", "wagon"]}

    if just_gravel:
        for seed in range(1,10):
            job = JobDescription("MWA_wagon.scad", "MWA_wagon_gravel_{}".format(seed))
            job.addVariable("GEN_IN_SITU", False)
            job.addVariable("GEN_MODEL_BITS", False)

            # disable anything left set to True
            for dont in allOptions:
                job.addVariable("GEN_" + dont.upper(), False)

            job.addVariable("GEN_GRAVEL", True)
            job.addVariable("GRAVEL_SEED", seed)
            jobs.append(job)
        return jobs

    for style in ["MWA", "MWA-B", "IOA"]:
        MWAariables = variables[style]
        fullMWAJob = JobDescription("MWA_wagon.scad", "{}_wagon_model".format(style))
        fullMWAJob.addVariable("GEN_IN_SITU", True)
        fullMWAJob.addVariable("STYLE", style)
        fullMWAJob.addVariable("GEN_BASE", False)
        fullMWAJob.addVariable("GEN_TOP", False)
        fullMWAJob.addVariable("GEN_MODEL_BITS", True)
        # want more realistic bogies for the model
        fullMWAJob.addVariable("BOGIE_EASY_PRINT", False)
        for v in ["wagon", "bogie", "brake_cylinder", "brake_wheel", "buffer"]:
            fullMWAJob.addVariable("GEN_" + v.upper(), True)

        for v in MWAariables:

            couplings = [""]
            if v == "bogie":
                couplings = ["dapol", "NEM"]
            for coupling in couplings:
                coupling_name = "" if len(coupling) == 0 else "_"+coupling
                job = JobDescription("MWA_wagon.scad", "{}_wagon_{}{}".format(style, v, coupling_name))
                job.addVariable("GEN_IN_SITU", False)
                job.addVariable("GEN_MODEL_BITS", False)
                job.addVariable("BOGIE_EASY_PRINT", True)
                if len(coupling) > 0:
                    job.addVariable("COUPLING_TYPE", coupling)

                # disable anything left set to True
                for dont in allOptions:
                    job.addVariable("GEN_" + dont.upper(), False)
                job.addVariable("STYLE", style)
                for v2 in MWAariables:
                    job.addVariable("GEN_" + v2.upper(), v == v2)
                jobs.append(job)
        jobs.append(fullMWAJob)
    return jobs


def wheel_jobs():
    jobs = []
    options = {
        # 12.5mm wheelset spacer
        "wheel_spacer_12_5mm": {"GEN_WHEELSET_SPACER": True,
                          "GEN_WHEEL": False,
                          "BEARING_TYPE": "spike",
                          "DUMMY": False,
                          "DIAMETER": 12.5,
                          },
        # 12.5mm pointed axle wheel
        "wheel_spiked_12_5mm": {"GEN_WHEELSET_SPACER": False,
                                    "GEN_WHEEL": True,
                                    "BEARING_TYPE": "spike",
                                    "DUMMY": False,
                                    "DIAMETER": 12.5,
                                    "WHEEL_POINTED": False
                                    },
        # 12.5mm pointed wheel
        "wheel_flat_12_5mm": {"GEN_WHEELSET_SPACER": False,
                                   "GEN_WHEEL": True,
                                   "BEARING_TYPE": "spike",
                                   "DUMMY": False,
                                   "DIAMETER": 12.5,
                                   "WHEEL_POINTED": True
                                   },
        # class66
        # "class66_wheel": {"GEN_WHEELSET_SPACER": False,
        #                   "GEN_WHEEL": True,
        #                   "BEARING_TYPE": "axle",
        #                   "DUMMY": False,
        #                   "DIAMETER": 14
        #                   },
        # "class66_dummy_wheel": {"GEN_WHEELSET_SPACER": False,
        #                         "GEN_WHEEL": True,
        #                         "BEARING_TYPE": "axle",
        #                         "DUMMY": True,
        #                         "DIAMETER": 14
        #                         },
        "wheel_flat_14mm": {"GEN_WHEELSET_SPACER": False,
                               "GEN_WHEEL": True,
                               "BEARING_TYPE": "spike",
                               "DUMMY": False,
                               "DIAMETER": 14
                               },
        "wheel_flat_14mm_dummy": {"GEN_WHEELSET_SPACER": False,
                                 "GEN_WHEEL": True,
                                 "BEARING_TYPE": "spike",
                                 "DUMMY": True,
                                 "DIAMETER": 14
                                 },
        "wheel_spacer_14mm": {"GEN_WHEELSET_SPACER": True,
                                "GEN_WHEEL": False,
                                "BEARING_TYPE": "spike",
                                "DUMMY": False,
                                "DIAMETER": 14,
                                },
    }

    for key in options:
        job = JobDescription("wheel.scad", "{}".format(key))
        job.addVariables(options[key])
        jobs.append(job)

    return jobs


if __name__ == '__main__':

    options = {"class66":lambda:class66_jobs(),
               "couplings":lambda:couplings_jobs(),
              "wagons":lambda:wagon_jobs(),
              "mwa":lambda:mwa_wagon_jobs(),
              "wheels":lambda:wheel_jobs(),
              "intermodal":lambda:intermodal_wagon_jobs(),
               "mwagravel": lambda:mwa_wagon_jobs(True)
               }

    parser = argparse.ArgumentParser(description="Generate all variants of a parametric object")
    # parser.add_argument("--class66", action='store_true')
    # parser.add_argument("--couplings", action='store_true')
    # parser.add_argument("--wagons", action='store_true')
    # parser.add_argument("--mwa", action='store_true')
    # parser.add_argument("--wheels", action='store_true')
    # parser.add_argument("--intermodal", action='store_true')
    for opt in options.keys():
        parser.add_argument("--{}".format(opt), action='store_true')

    args = parser.parse_args()
    jobs = []

    all = True
    for opt in options.keys():
        #https://stackoverflow.com/questions/43624460/python-how-to-get-value-from-argparse-from-variable-but-not-the-name-of-the-var
        if vars(args).get(opt):
            all = False

    for opt in options.keys():
        if vars(args).get(opt) or all:
            jobs.extend(options[opt]())

    # if args.class66 or all:
    #     jobs.extend(class66_jobs())
    # if args.couplings or all:
    #     jobs.extend(couplings_jobs())
    # if args.wagons or all:
    #     jobs.extend(wagon_jobs())
    # if args.mwa or all:
    #     jobs.extend(mwa_wagon_jobs())
    # if args.wheels or all:
    #     jobs.extend(wheel_jobs())
    # if args.intermodal or all:
    #     jobs.extend(intermodal_wagon_jobs())

    multiprocessJobs(jobs)

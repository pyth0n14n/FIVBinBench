# Fault Injection Vulnerability Detection Tools

We made the following changes:

| Tool                      | Changes                                                          |  License |
|---------------------------|------------------------------------------------------------------|----------|
| FaultFinder               | Bugfixes and functional changes (see submodule for details)      | MIT |
| Armory                    | Output PC address for register fault model (see submodule for details) | MIT |
| ChaosDuck                 | Bugfixes (see details below)                                     | - |
| FaultArm                  | Bugfixes (see details below)                                     | - |
| Archie                    | N/A                                                              | Apache 2.0 |
| FaultInjectionSimulator   | N/A                                                              | MIT |
| fault-injection-simulation| Create FVD script from Jupyter notebook                          | - |

We modified Armory, FaultFinder, ChaosDuck, and FaultArm for our evaluation.  Forked repositories for Armory and FaultFinder are published.  
**Note:** Since their repositories do not have a LICENSE file, we did not fork and commit the modifications.  
However, we provide some implementation hints below.

## ChaosDuck
- **x86**
  - Support 64-bit binaries in Capstone usage
- **ARM**
  - Support ARM instruction set instead of Thumb in Capstone usage
  - Parse not only `.init` but also `.text` sections
- **main**
  - Fixed invalid usage of both `shlex.split()` and `shell=True` in `Popen()`
  - Support for running flp, nop, jump, and zero fault models separately if required

## FaultArm
- **Analyzer**
  - Avoid errors in `static_analysis()` using try-except logic
- **patterns**
  - Avoid errors when adding empty "bypass patterns" for x86

## fault-injection-simulation
The repository includes `notebooks/01_introduction.ipynb`. You can refer to this Jupyter notebook to create your own FVD script.
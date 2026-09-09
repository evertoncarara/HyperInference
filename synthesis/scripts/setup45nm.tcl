# LISTS OF PATHS AND ARCHIVES
set LIB_LEF_PATH []
set LIBS_FAST []
set LIBS_SLOW []
set LEFS []

# USED TO EQUIVALENT GATES
set NAND2X1_NAME NAND2X1

# SET PATHS
lappend LIB_LEF_PATH /home/tools/design_kits/cadence/GPDK045/gsclib045_svt_v4.4/gsclib045/timing
lappend LIB_LEF_PATH /home/tools/design_kits/cadence/GPDK045/giolib045_v3.3/timing
lappend LIB_LEF_PATH /home/tools/design_kits/cadence/GPDK045/gsclib045_svt_v4.4/gsclib045/lef/
lappend LIB_LEF_PATH /home/tools/design_kits/cadence/GPDK045/giolib045_v3.3/lef/

set QRC /home/tools/design_kits/cadence/GPDK045/gpdk045_v_6_0/qrc/rcworst/qrcTechFile

# SET ARCHIVES
lappend LIBS_FAST fast_vdd1v2_basicCells.lib
lappend LIBS_SLOW slow_vdd1v0_basicCells.lib

lappend LEFS gsclib045_tech.lef
lappend LEFS gsclib045_macro.lef 

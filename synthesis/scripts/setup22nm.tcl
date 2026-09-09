# LISTS OF PATHS AND ARCHIVES
set LIB_LEF_PATH []
set LIBS_FAST []
set LIBS_SLOW []
set LEFS []

# USED TO EQUIVALENT GATES
set NAND2X1_NAME ND2SGD0BWP7T40P140

# SET PATHS
lappend LIB_LEF_PATH /home/tools/design_kits/tsmc/22/digital/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn22ullbwp7t40p140sg_110b \
lappend LIB_LEF_PATH /home/tools/design_kits/tsmc/22/digital/CapTbl_qrcdeck_5X1Z/PRTF_Innovus_22nm_001_Cad_V16b/PRTF_Innovus_22nm_001_Cad_V16b/PR_tech/Cadence/LefHeader/VHV \
lappend LIB_LEF_PATH /home/tools/design_kits/tsmc/22/digital/TSMCHOME/digital/Back_End/lef/tcbn22ullbwp7t40p140sg_110a/lef \



set QRC /home/tools/design_kits/tsmc/22/digital/CapTbl_qrcdeck_5X1Z/WORST_capTbl_VHV_rc_7M_5X1ZRDL_7T.16b.capTbl

# SET ARCHIVES
lappend LIBS_FAST tcbn22ullbwp7t40p140sgffg0p77v0c.lib.gz

lappend LIBS_SLOW tcbn22ullbwp7t40p140sgssg0p81v125c.lib.gz

lappend LEFS PRTF_Innovus_N22_7M_5X1Z_RDL_7T.16b.tlef
lappend LEFS tcbn22ullbwp7t40p140sg.lef

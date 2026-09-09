

# ---------------------------------------------------------------
# --------------- Setting some variables ------------------------
# ---------------------------------------------------------------


set DESIGN $env(CIRCUIT)
set ROOT_DIR $env(ROOT)/HDLs/HyperInference
set freq_mhz $env(FREQ_MHZ)
set CORNER $env(OP_CORNER)
set NODE $env(TECH)

# ---------------------------------------------------------------
# ------------ Setting paths from archivers ---------------------
# ---------------------------------------------------------------

if {$NODE == 22} {
  source ${ROOT_DIR}/synthesis/scripts/setup22nm.tcl
} else {
  source ${ROOT_DIR}/synthesis/scripts/setup45nm.tcl
}


# Set the paths to search the HDL files
set_db init_hdl_search_path { \
    ${ROOT_DIR}/src/comon     \
    ${ROOT_DIR}/src/MNIST     \
    ${ROOT_DIR}/src/ISOLET    \
    ${ROOT_DIR}/src/UCIHAR    \
}


# Set the paths to search the libs and LEF files
set_db init_lib_search_path $LIB_LEF_PATH

# Set the path to search SDC files
set SDC_SEARCH_PATH         ${ROOT_DIR}/synthesis/constraints/

# Set the path to search HDL filelist
set FILELIST_SEARCH_PATH    ${ROOT_DIR}/src/Filelists/

# Set the path to save the reports and deliverables
set REPORTS_PATH            ${ROOT_DIR}/synthesis/outputs/reports/
set DELIVERABLES_PATH       ${ROOT_DIR}/synthesis/outputs/deliverables/




# ---------------------------------------------------------------
# ------------ Setting and load the archivers -------------------
# ---------------------------------------------------------------

# Load the TLEF and LEF files


# Load the standard cells libraries : STD, MB, IO
switch -- $CORNER {

    "slow" {
        read_libs $LIBS_SLOW
    }

    "fast" {
        read_libs $LIBS_FAST
    }

    "typical" {
        puts "\n\n ERROR: Do not have typical corner libraries defined."
        exit
    }

    default {
        puts "\n\n ERROR: The specified corner '$CORNER' is not valid.\n"
        exit
    }
}


read_physical -lefs $LEFS
if {$NODE == 45} {
  set_db qrc_tech_file  $QRC
} else {
  set_db cap_table_file  $QRC
}


# Load the HDL filelist
read_hdl -language v2001 -f "${FILELIST_SEARCH_PATH}${DESIGN}.flist"


# ---------------------------------------------------------------
# ------ Elabore the design and defines constraints -------------
# ---------------------------------------------------------------

# Elaborate the design
elaborate HyperInference


check_design > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_check_design.rpt"

# Read constraints SDC files
# create_mode -name FUNCTIONAL -default -design ${DESIGN}
# read_sdc -mode FUNCTIONAL "${SDC_SEARCH_PATH}${DESIGN}_n22.sdc"
read_sdc "${SDC_SEARCH_PATH}constraints.sdc"
# define_cost_group -name FUNCTIONAL
report_timing -lint > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_constraints_summary.rpt"

# read_vcd "${SDC_SEARCH_PATH}${DESIGN}_HDL_simulation.vcd.gz"
# report_sdb_annotation >> "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_read_vcd.rpt"  

# Defines the instances that could not ungroup
#set_db hinst:cv32e40p_wrapper/core_i/id_stage_i/register_file_i .ungroup_ok false

# A tcl script to make a list with MBFF cell names


set_db use_multibit_cells false

#suspend

# Allow and dimiss the use of some cells
set_db [get_db lib_cells *CKLNQ*] .avoid false
set_db [get_db lib_cells *CKLHQ*] .avoid false


set_db [get_db hinst:trunc_adder_SH/Decision_Tree_inst/R0_inst] .ungroup_ok false
set_db [get_db hinst:trunc_adder_SH/Decision_Tree_inst/R1_inst] .ungroup_ok false
set_db [get_db hinst:trunc_adder_SH/Decision_Tree_inst/R2_inst] .ungroup_ok false
set_db [get_db hinst:trunc_adder_SH/Decision_Tree_inst/R3_inst] .ungroup_ok false
set_db [get_db hinst:trunc_adder_SH/Decision_Tree_inst/R4_inst] .ungroup_ok false
set_db [get_db hinst:trunc_adder_SH/comp_inst] .ungroup_ok false

# Set the effort in the synthesis stages
# set_db syn_generic_effort    high
# set_db syn_map_effort        high
# set_db syn_opt_effort        high
# set_db design_power_effort    high
# set_db optimize_constant_0_flops true
# set_db optimize_constant_1_flops true


# ---------------------------------------------------------------
# ----------------------- Synthesizes ---------------------------
# ---------------------------------------------------------------

syn_gen
write_hdl > "${DELIVERABLES_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_generic.v"
syn_map 

#compress_scan_chains -ratio 8 -compressor xor -decompressor xor -mask wide1 -auto_create
#add_test_compression -compressor xor -decompressor xor -auto_create
#report_scan_chains

#suspend

# syn_opt

#report_scan_setup

# ---------------------------------------------------------------
# ------------------- Save the archivers ------------------------
# ---------------------------------------------------------------
set_db lp_power_unit uW 

write_hdl > "${DELIVERABLES_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}.v"
write_sdf > "${DELIVERABLES_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}.sdf"
write_hdl > "${DELIVERABLES_PATH}last/${DESIGN}.v"
write_sdf > "${DELIVERABLES_PATH}last/${DESIGN}.sdf"
report_timing > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_timing.rpt"
report_area > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_area.rpt"
report_area -normalize_with_gate $NAND2X1_NAME > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_EG.rpt"
report_area -detail > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_area_detail.rpt"
report_power -unit uW > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_power.rpt"
report_gates > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_gates.rpt"
report_hierarchy > "${REPORTS_PATH}${NODE}nm/${freq_mhz}/${CORNER}/${DESIGN}_hierarchy.rpt"


report_timing

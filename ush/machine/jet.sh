#!/bin/bash

function file_location() {

  # Return the default location of external model files on disk

  local external_file_fmt external_model location

  external_model=${1}
  external_file_fmt=${2}

  location=""
  case ${external_model} in

    "FV3GFS")
      case $external_file_fmt in
        "nemsio")
          location='/public/data/grids/gfs/nemsio'
          ;;
        "grib2")
          location='/public/data/grids/gfs/0p25deg/grib2'
          ;;
        "netcdf")
          location='/public/data/grids/gfs/anl/netcdf/'
          ;;
      esac
      ;;
    "RAP")
      location='/public/data/grids/rap/full/wrfprs/grib2'
      ;;
    "HRRR")
      location='/public/data/grids/hrrr/conus/wrfprs/grib2'
      ;;

  esac
  echo ${location:-}

}

EXTRN_MDL_SYSBASEDIR_ICS=${EXTRN_MDL_SYSBASEDIR_ICS:-$(file_location \
  ${EXTRN_MDL_NAME_ICS} \
  ${FV3GFS_FILE_FMT_ICS})}
EXTRN_MDL_SYSBASEDIR_LBCS=${EXTRN_MDL_SYSBASEDIR_LBCS:-$(file_location \
  ${EXTRN_MDL_NAME_LBCS} \
  ${FV3GFS_FILE_FMT_LBCS})}

EXTRN_MDL_DATA_STORES=${EXTRN_MDL_DATA_STORES:-"hpss aws nomads"}

# System scripts to source to initialize various commands within workflow
# scripts (e.g. "module").
if [ -z ${ENV_INIT_SCRIPTS_FPS:-""} ]; then
  ENV_INIT_SCRIPTS_FPS=( "/etc/profile" )
fi

# Commands to run at the start of each workflow task.
PRE_TASK_CMDS='{ ulimit -s unlimited; ulimit -a; }'

# Architecture information
WORKFLOW_MANAGER="rocoto"
NCORES_PER_NODE=${NCORES_PER_NODE:-24}
SCHED=${SCHED:-"slurm"}
PARTITION_DEFAULT=${PARTITION_DEFAULT:-"sjet,vjet,kjet,xjet"}
QUEUE_DEFAULT=${QUEUE_DEFAULT:-"batch"}
PARTITION_HPSS=${PARTITION_HPSS:-"service"}
QUEUE_HPSS=${QUEUE_HPSS:-"batch"}
PARTITION_FCST=${PARTITION_FCST:-"sjet,vjet,kjet,xjet"}
QUEUE_FCST=${QUEUE_FCST:-"batch"}

# UFS SRW App specific paths
staged_data_dir="/mnt/lfs4/BMC/wrfruc/UFS_SRW_App/develop"
FIXgsm=${FIXgsm:-"${staged_data_dir}/fix/fix_am"}
FIXaer=${FIXaer:-"${staged_data_dir}/fix/fix_aer"}
FIXlut=${FIXlut:-"${staged_data_dir}/fix/fix_lut"}
TOPO_DIR=${TOPO_DIR:-"${staged_data_dir}/fix/fix_orog"}
SFC_CLIMO_INPUT_DIR=${SFC_CLIMO_INPUT_DIR:-"${staged_data_dir}/fix/fix_sfc_climo"}
DOMAIN_PREGEN_BASEDIR=${DOMAIN_PREGEN_BASEDIR:-"${staged_data_dir}/FV3LAM_pregen"}

# Run commands for executables
RUN_CMD_SERIAL="time"
RUN_CMD_UTILS="srun"
RUN_CMD_FCST="srun"
RUN_CMD_POST="srun"

# Test Data Locations
TEST_COMIN="${staged_data_dir}/COMGFS"
TEST_PREGEN_BASEDIR="${staged_data_dir}/FV3LAM_pregen"
TEST_EXTRN_MDL_SOURCE_BASEDIR="${staged_data_dir}/input_model_data"

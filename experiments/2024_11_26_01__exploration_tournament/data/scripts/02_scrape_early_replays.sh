#!/bin/bash
IS_VERBOSE=0

# Grab global variables and helper functions
# Root directory -> The root level of the repo, should be directory just above 'experiments'
REPO_ROOT_DIR=$(pwd | grep -oP ".+(?=/experiments/)")
if [ ! ${IS_VERBOSE} -eq 0 ]
then
  echo "[VERBOSE] Found repo root dir: ${REPO_ROOT_DIR}"
  echo "[VERBOSE] Loading global config and helper functions..."
fi
. ${REPO_ROOT_DIR}/config_global.sh
. ${REPO_ROOT_DIR}/global_shared_files/helper_functions.sh

# Extract info about this experiment
EXP_NAME=$( get_cur_exp_name )
EXP_REL_PATH=$( get_cur_relative_exp_path )
EXP_ROOT_DIR=${REPO_ROOT_DIR}/${EXP_REL_PATH}
if [ ! ${IS_VERBOSE} -eq 0 ]
then
  echo "[VERBOSE] Experiment name: ${EXP_NAME}"
  echo "[VERBOSE] Experiment path (relative): ${EXP_REL_PATH}"
  echo "[VERBOSE] Experiment root dir (not relative): ${EXP_ROOT_DIR}"
  echo ""
fi

# Grab references to the various directories used in setup
MABE_DIR=${REPO_ROOT_DIR}/MABE2
#MABE_EXTRAS_DIR=${REPO_ROOT_DIR}/MABE2_extras
SCRATCH_EXP_DIR=${SCRATCH_ROOT_DIR}/${EXP_REL_PATH}
SCRATCH_REP_DIR=${SCRATCH_EXP_DIR}/reps
if [ ! ${IS_VERBOSE} -eq 0 ]
then
  echo ""
  echo "[VERBOSE] MABE dir: ${MABE_DIR}"
  echo "[VERBOSE] Global shared file dir: ${GLOBAL_FILE_DIR}"
  echo "[VERBOSE] Scratch directories:"
  echo "[VERBOSE]     Main exp dir: ${SCRATCH_EXP_DIR}"
  echo "[VERBOSE]     Scratch reps dir: ${SCRATCH_REP_DIR}"
fi

num_trials=50
rep_list=("043")

output_file=../02_early_replay_data.csv
#echo "exp_name,rep_id,replay_gen,trial_id,gen,replay_gen,fitness_mean,fitness_max,scores_entropy,scores_unique,collective_score" > $output_file
echo "exp_name,rep_id,trial_id,gen,replay_gen,fitness_mean,fitness_max,scores_entropy,scores_unique,collective_score" > $output_file
#for dir_name in $( ls ${SCRATCH_REP_DIR} )
for dir_name in ${rep_list[@]}
do
    full_name=${SCRATCH_REP_DIR}/${dir_name}
    if ! [ -d $full_name ]
    then
        continue
    fi
    echo "$dir_name"
    for replay_gen in $(seq 1 100)
    do
        echo "  $replay_gen"
        for trial_id in $(seq 1 ${num_trials})
        do
            final_line=$(tail -n 1 ${SCRATCH_REP_DIR}/${dir_name}/replay_${replay_gen}__trial_${trial_id}.csv)
            echo "${EXP_NAME},${dir_name},${trial_id},${final_line}" >> $output_file
        done
    done
done

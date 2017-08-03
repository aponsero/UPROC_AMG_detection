#!/bin/sh
set -u
#
# Checking args
#

source scripts/config.sh

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "$SAMPLE does not exist. Please provide a directory containing files to process Job terminated."
    exit 1
fi

if [[ ! -d "$DB_DIR" ]]; then
    echo "$DB_DIR does not exist. Please provide a directory containing the Uproc database. Job terminated."
    exit 1
fi

if [[ ! -d "$MODEL" ]]; then
    echo "$MODEL does not exist. Please provide a directory containing the Uproc model. Job terminated."
    exit 1
fi

if [[ ! -f "$PFAM_VIR" ]]; then
    echo "$PFAM_VIR does not exist. Please provide a file containing viral pfam. Job terminated."
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "$SCRIPT_DIR does not exist. Job terminated."
    exit 1
fi

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "$SAMPLE_DIR does not exist. Directory created for output files."
    mkdir -p "$SAMPLE_DIR"
fi


#
# Job submission
#

PREV_JOB_ID=""
ARGS="-q $QUEUE -W group_list=$GROUP -M $MAIL_USER -m $MAIL_TYPE"


#
## 01-run-analysis
#


PROG2="01-run-analysis"
export STDERR_DIR2="$SCRIPT_DIR/err/$PROG2"
export STDOUT_DIR2="$SCRIPT_DIR/out/$PROG2"


init_dir "$STDERR_DIR2" "$STDOUT_DIR2"

export PRODIGAL_DIR="$SAMPLE_DIR/div/prodigal"
export SELECTED="$SAMPLE_DIR/div/selected"
export UPROC_DIR="$SAMPLE_DIR/Uproc"

init_dir "$PRODIGAL_DIR" "$SELECTED" "$UPROC_DIR"

export SPLIT="$SAMPLE_DIR/div/raw"

export FILES_LIST="$SPLIT/list-files"

cd $SPLIT

find . -type f -name "*.fasta" > $FILES_LIST

export NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$SPLIT\"

if [ $NUM_FILES -gt 0 ]; then

    if [ $NUM_FILES -gt 1 ]; then
         JOB_ID=`qsub $ARGS -v WORKER_DIR,SPLIT,PRODIGAL_DIR,SELECTED,UPROC_DIR,FILES_LIST,SAMPLE_DIR,STDERR_DIR2,STDOUT_DIR2,PFAM_VIR,MODEL,DB_DIR,PRODIGAL -N run_analysis -e "$STDERR_DIR2" -o "$STDOUT_DIR2" -J 1-$NUM_FILES $SCRIPT_DIR/run_analysis_array.sh`

          if [ "${JOB_ID}x" != "x" ]; then
             echo Job: \"$JOB_ID\"
             PREV_JOB_ID=$JOB_ID
          else
              echo Problem submitting job.
          fi
     else
          XFILE=find . -type f -name "*.fasta" 
          JOB_ID=`qsub $ARGS -v XFILE,WORKER_DIR,SPLIT,PRODIGAL_DIR,SELECTED,UPROC_DIR,FILES_LIST,SAMPLE_DIR,STDERR_DIR,STDOUT_DIR,PFAM_VIR,MODEL,DB_DIR,PRODIGAL -N run_analysis -e "$STDERR_DIR2" -o "$STDOUT_DIR2"  $SCRIPT_DIR/run_analysis.sh`

          if [ "${JOB_ID}x" != "x" ]; then
             echo Job: \"$JOB_ID\"
             PREV_JOB_ID=$JOB_ID
          else
              echo Problem submitting job.
          fi
      fi 

#
## 02- get-results
#

       PROG3="02-get-results"
       export STDERR_DIR3="$SCRIPT_DIR/err/$PROG3"
       export STDOUT_DIR3="$SCRIPT_DIR/out/$PROG3"


       init_dir "$STDERR_DIR3" "$STDOUT_DIR3"


        JOB_ID=`qsub $ARGS -v WORKER_DIR,SAMPLE_DIR,STDERR_DIR3,STDOUT_DIR3 -N run_results -e "$STDERR_DIR3" -o "$STDOUT_DIR3" -W depend=afterok:$PREV_JOB_ID $SCRIPT_DIR/run_get_result.sh`

        if [ "${JOB_ID}x" != "x" ]; then
             echo Job: \"$JOB_ID\"
        else
             echo Problem submitting job.
        fi


        echo "job successfully submited"


else
    echo Nothing to do.
fi


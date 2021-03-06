export CWD=$PWD
# where programs are
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export PRODIGAL="/rsgrps/bhurwitz/alise/tools/Prodigal/prodigal"
# where the sample to analyze are
export SAMPLE="YOUR/FILE"
export SAMPLE_DIR="YOUR/PATH"
# scripts of the pipeline
export SCRIPT_DIR="$PWD/scripts"
export WORKER_DIR="$SCRIPT_DIR/workers"
#Where the blast Databases are
export DB_DIR="/rsgrps/bhurwitz/alise/my_data/databases/Uproc_DB/pfam24"
export MODEL="/rsgrps/bhurwitz/alise/my_data/databases/Uproc_DB/model"
export PFAM_VIR="/rsgrps/bhurwitz/alise/my_data/databases/Uproc_DB/Vir_PFAM.txt"
#user informations
export QUEUE="standard"
export GROUP="yourgroup"
export MAIL_USER="yourmail@email.arizona.edu"
export MAIL_TYPE="bea"


#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
